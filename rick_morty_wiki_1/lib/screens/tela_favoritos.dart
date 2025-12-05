import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favoritos_provider.dart';

class TelaFavoritos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lista = context.watch<FavoritosProvider>().meusFavoritos;

    return Scaffold(
      appBar: AppBar(title: Text("MEUS FAVORITOS")),
      body: lista.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.heart_broken, size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text("Sem favoritos ainda...", style: TextStyle(color: Colors.grey))
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: lista.length,
        itemBuilder: (context, index) {
          var fav = lista[index];
          return Card(
            color: Color(0xFF3C3E44), // Fundo do Card
            margin: EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(fav.imagemUrl, width: 60, height: 60, fit: BoxFit.cover),
              ),
              title: Text(fav.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text("#${fav.idPersonagem}", style: TextStyle(color: Color(0xFF97CE4C))),
              trailing: Icon(Icons.favorite, color: Colors.redAccent),
            ),
          );
        },
      ),
    );
  }
}