part of 'favorito_model.dart';

class FavoritoAdapter extends TypeAdapter<Favorito> {
  @override
  final int typeId = 1;

  @override
  Favorito read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorito(
      emailUsuario: fields[0] as String,
      idPersonagem: fields[1] as int,
      nome: fields[2] as String,
      imagemUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Favorito obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.emailUsuario)
      ..writeByte(1)
      ..write(obj.idPersonagem)
      ..writeByte(2)
      ..write(obj.nome)
      ..writeByte(3)
      ..write(obj.imagemUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
