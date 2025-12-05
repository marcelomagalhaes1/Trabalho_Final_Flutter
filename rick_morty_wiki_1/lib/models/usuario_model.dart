import 'package:hive/hive.dart';

part 'usuario_model.g.dart';

@HiveType(typeId: 0)
class Usuario extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String senha;

  Usuario({required this.email, required this.senha});

}
