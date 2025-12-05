import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/usuario_model.dart';

class AuthProvider extends ChangeNotifier {
  Usuario? _usuarioLogado; // Guarda quem está usando o app agora

  Usuario? get usuarioLogado => _usuarioLogado;
  bool get estaLogado => _usuarioLogado != null;

  // Função para Cadastrar
  Future<bool> cadastrar(String email, String senha) async {
    var box = Hive.box<Usuario>('box_usuarios');

    // Verifica se já existe esse email (Varrendo a lista toda)
    for (var u in box.values) {
      if (u.email == email) {
        return false; // Já existe, não cadastra
      }
    }

    // Se não existe, cria e salva
    var novoUsuario = Usuario(email: email, senha: senha);
    await box.add(novoUsuario);
    return true; // Sucesso
  }

  // Função para Logar
  Future<bool> logar(String email, String senha) async {
    var box = Hive.box<Usuario>('box_usuarios');

    try {
      // Procura o primeiro usuário que bater email e senha
      var usuarioEncontrado = box.values.firstWhere(
              (u) => u.email == email && u.senha == senha
      );

      _usuarioLogado = usuarioEncontrado;
      notifyListeners(); // AVISA AS TELAS QUE MUDOU O ESTADO!
      return true;
    } catch (e) {
      return false; // Não achou ninguém
    }
  }

  void deslogar() {
    _usuarioLogado = null;
    notifyListeners(); // Avisa a tela para voltar pro Login
  }
}