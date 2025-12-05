import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/favorito_model.dart';

class FavoritosProvider extends ChangeNotifier {

  // Lista que vai aparecer na tela de favoritos
  List<Favorito> _meusFavoritos = [];
  List<Favorito> get meusFavoritos => _meusFavoritos;

  // Carrega os favoritos SÓ do usuário que passou por parâmetro
  void carregarFavoritos(String emailUsuario) {
    var box = Hive.box<Favorito>('box_favoritos');

    // Filtro manual: pego todos e só guardo os que são desse email
    _meusFavoritos = box.values
        .where((fav) => fav.emailUsuario == emailUsuario)
        .toList();

    notifyListeners();
  }

  // Adiciona ou Remove (Toggle)
  Future<void> alternarFavorito(String emailUsuario, int idPersonagem, String nome, String imagem) async {
    var box = Hive.box<Favorito>('box_favoritos');

    // Verifica se esse personagem já está favoritado por esse usuário
    int indice = box.values.toList().indexWhere(
            (fav) => fav.emailUsuario == emailUsuario && fav.idPersonagem == idPersonagem
    );

    if (indice >= 0) {
      // Se achou (índice maior que -1), então REMOVE
      var chaveParaDeletar = box.keyAt(indice);
      await box.delete(chaveParaDeletar);
    } else {
      // Se não achou, ADICIONA
      var novoFav = Favorito(
          emailUsuario: emailUsuario,
          idPersonagem: idPersonagem,
          nome: nome,
          imagemUrl: imagem
      );
      await box.add(novoFav);
    }

    // Atualiza a lista local para a tela saber
    carregarFavoritos(emailUsuario);
  }

  // Função auxiliar para saber se o coração deve ficar pintado ou não na Home
  bool ehFavorito(int idPersonagem) {
    return _meusFavoritos.any((fav) => fav.idPersonagem == idPersonagem);
  }
}