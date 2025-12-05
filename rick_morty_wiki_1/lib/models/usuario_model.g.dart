// Indica que este arquivo é uma parte "irmã" do arquivo usuario_model.dart
part of 'usuario_model.dart';

// Cria a classe Adaptadora que estende a funcionalidade do Hive
class UsuarioAdapter extends TypeAdapter<Usuario> {
  
  @override
  final int typeId = 0; // Este é o ID que você definiu com @HiveType(typeId: 0)

  // Essa função roda quando você pede dados ao banco (ex: box.values)
  // Ela pega os bits do arquivo e remonta o objeto Usuario na memória RAM.
  @override
  Usuario read(BinaryReader reader) {
    // 1. Lê o primeiro byte para saber quantos campos foram salvos
    final numOfFields = reader.readByte();
    
    // 2. Cria um mapa temporário para segurar os dados brutos
    final fields = <int, dynamic>{
      // 3. Faz um loop para ler cada campo salvo
      for (int i = 0; i < numOfFields; i++) 
        reader.readByte(): reader.read(), // Lê a chave (ex: 0) e depois o valor (ex: "email@teste.com")
    };
    
    // 4. Constrói e retorna o objeto Usuario final
    return Usuario(
      // Pega o que está no índice 0 do mapa e força ser uma String (cast)
      email: fields[0] as String, 
      // Pega o que está no índice 1 do mapa e força ser uma String
      senha: fields[1] as String, 
    );
  }

  // --- FUNÇÃO WRITE (ESCREVER) ---
  // Essa função roda quando você faz box.add() ou box.put()
  // Ela pega seu objeto Usuario e desmonta ele em bits para salvar no disco.
  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer
      ..writeByte(2) // Passo 1: Avisa o banco "Vou escrever 2 campos agora"
      ..writeByte(0) // Passo 2: Escreve o índice do campo Email (que é 0)
      ..write(obj.email) // Passo 3: Escreve o valor do email (ex: "joao@gmail.com")
      ..writeByte(1) // Passo 4: Escreve o índice do campo Senha (que é 1)
      ..write(obj.senha); // Passo 5: Escreve o valor da senha
  }

  
  @override
  int get hashCode => typeId.hashCode; // Gera um código único baseado no ID (0)

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId; // Verifica se são o mesmo adaptador
}