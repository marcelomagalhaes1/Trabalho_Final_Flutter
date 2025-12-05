import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/usuario_model.dart';

class AuthProvider extends ChangeNotifier {
  Usuario? _usuarioLogado;

  Usuario? get usuarioLogado => _usuarioLogado;
  bool get estaLogado => _usuarioLogado != null;

  Future<bool> cadastrar(String email, String senha) async {
    var box = Hive.box<Usuario>('box_usuarios');

    for (var u in box.values) {
      if (u.email == email) {
        return false;
      }
    }

    var novoUsuario = Usuario(email: email, senha: senha);
    await box.add(novoUsuario);
    return true;
  }

  Future<bool> logar(String email, String senha) async {
    var box = Hive.box<Usuario>('box_usuarios');

    try {
      var usuarioEncontrado = box.values.firstWhere(
              (u) => u.email == email && u.senha == senha
      );

      _usuarioLogado = usuarioEncontrado;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void deslogar() {
    _usuarioLogado = null;
    notifyListeners();
  }

}
