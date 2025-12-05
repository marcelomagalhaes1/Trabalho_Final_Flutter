import 'package:hive/hive.dart';

part 'favorito_model.g.dart';

@HiveType(typeId: 1) // ID diferente do usuário
class Favorito extends HiveObject {
  @HiveField(0)
  final String emailUsuario; // Isso liga o favorito ao dono dele!

  @HiveField(1)
  final int idPersonagem; // ID que vem da API

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