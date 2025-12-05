import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/favorito_model.dart';

class FavoritosProvider extends ChangeNotifier {

  List<Favorito> _meusFavoritos = [];
  List<Favorito> get meusFavoritos => _meusFavoritos;

  void carregarFavoritos(String emailUsuario) {
    var box = Hive.box<Favorito>('box_favoritos');

    _meusFavoritos = box.values
        .where((fav) => fav.emailUsuario == emailUsuario)
        .toList();

    notifyListeners();
  }

  Future<void> alternarFavorito(String emailUsuario, int idPersonagem, String nome, String imagem) async {
    var box = Hive.box<Favorito>('box_favoritos');

    int indice = box.values.toList().indexWhere(
            (fav) => fav.emailUsuario == emailUsuario && fav.idPersonagem == idPersonagem
    );

    if (indice >= 0) {
      var chaveParaDeletar = box.keyAt(indice);
      await box.delete(chaveParaDeletar);
    } else {
      var novoFav = Favorito(
          emailUsuario: emailUsuario,
          idPersonagem: idPersonagem,
          nome: nome,
          imagemUrl: imagem
      );
      await box.add(novoFav);
    }

    carregarFavoritos(emailUsuario);
  }

  bool ehFavorito(int idPersonagem) {
    return _meusFavoritos.any((fav) => fav.idPersonagem == idPersonagem);
  }

}
