import 'package:hive/hive.dart';

// O comando build_runner vai gerar esse arquivo .g.dart depois
part 'usuario_model.g.dart';

@HiveType(typeId: 0) // ID único para o Hive saber que é um Usuário
class Usuario extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String senha;

  Usuario({required this.email, required this.senha});
}