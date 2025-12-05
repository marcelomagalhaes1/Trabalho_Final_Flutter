import 'package:hive/hive.dart';

part 'favorito_model.g.dart';

@HiveType(typeId: 1)
class Favorito extends HiveObject {
  @HiveField(0)
  final String emailUsuario;

  @HiveField(1)
  final int idPersonagem;

  @HiveField(2)
  final String nome;

  @HiveField(3)
  final String imagemUrl;

  Favorito({
    required this.emailUsuario,
    required this.idPersonagem,
    required this.nome,
    required this.imagemUrl,
  });

}
