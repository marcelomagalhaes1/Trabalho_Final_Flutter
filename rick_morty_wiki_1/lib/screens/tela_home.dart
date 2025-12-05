import 'dart:convert'; // Biblioteca para converter JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Biblioteca para fazer requisições web
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favoritos_provider.dart';
import 'tela_favoritos.dart';
import 'tela_login.dart';

class TelaHome extends StatefulWidget {
  @override
  _TelaHomeState createState() => _TelaHomeState(); // Cria o estado da tela
}

class _TelaHomeState extends State<TelaHome> {
  List<dynamic> personagens = []; // Lista que vai guardar os dados vindos da API
  bool carregando = true; // Variável para controlar se mostra o loading ou a lista

  @override
  void initState() {
    super.initState();
    _iniciarDados(); // Chama a função de carregar assim que a tela abre
  }

  void _iniciarDados() async {
    // Pega o email do usuário logado atualmente
    final email = context.read<AuthProvider>().usuarioLogado?.email;
    
    // Se tiver email, manda carregar os favoritos desse usuário específico
    if (email != null) context.read<FavoritosProvider>().carregarFavoritos(email);

    try {
      // Faz o pedido (GET) para a API do Rick and Morty
      var response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));
      
      if (response.statusCode == 200) { 
        setState(() { // Atualiza a tela
          personagens = jsonDecode(response.body)['results']; // Converte JSON e pega a lista 'results'
          carregando = false; // Desliga o loading
        });
      }
    } catch (e) {
      // Se der erro (sem internet), também desliga o loading para não travar
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // context.watch: Fica "ouvindo" o Provider. Se favoritar algo, ele redesenha esta tela
    final favProvider = context.watch<FavoritosProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("RICK & MORTY WIKI"), // Título
        actions: [
          IconButton( // Botão de Favoritos
            icon: Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TelaFavoritos())),
          ),
          IconButton( // Botão de Sair
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              context.read<AuthProvider>().deslogar(); // Chama o logout
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TelaLogin())); // Volta pro login
            },
          )
        ],
      ),
      // Se 'carregando' for true, mostra rodinha. Se false, mostra a lista.
      body: carregando
          ? Center(child: CircularProgressIndicator(color: Color(0xFF97CE4C)))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              // GridView.builder: Cria uma grade (colunas) eficiente para muitos itens
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Quantas colunas (2 cards por linha)
                  childAspectRatio: 0.75, // Proporção do card (mais alto que largo)
                  crossAxisSpacing: 10, // Espaço horizontal entre cards
                  mainAxisSpacing: 10, // Espaço vertical entre cards
                ),
                itemCount: personagens.length, // Quantos itens tem na lista
                itemBuilder: (context, index) {
                  var p = personagens[index]; // Pega o personagem atual
                  bool isFav = favProvider.ehFavorito(p['id']); // Verifica se ele é favorito
                  
                  // Lógica visual: define a cor da bolinha baseado no status
                  Color statusColor = Colors.grey;
                  if (p['status'] == 'Alive') statusColor = Colors.greenAccent;
                  if (p['status'] == 'Dead') statusColor = Colors.redAccent;

                  return Container(
                    decoration: BoxDecoration( // Estilo do Card
                      color: Color(0xFF3C3E44), // Fundo cinza escuro
                      borderRadius: BorderRadius.circular(15), // Bordas redondas
                      boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 5)], // Sombra
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Estica itens na largura
                      children: [
                        Expanded( // A imagem ocupa todo o espaço que sobrar
                          child: ClipRRect( // Corta a imagem com bordas redondas no topo
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(p['image'], fit: BoxFit.cover), // Carrega imagem da URL
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Alinha texto à esquerda
                            children: [
                              Text(p['name'], // Nome do personagem
                                overflow: TextOverflow.ellipsis, // Se for grande, põe "..."
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)
                              ),
                              SizedBox(height: 4),
                              Row( // Linha com a bolinha de status + texto
                                children: [
                                  CircleAvatar(radius: 4, backgroundColor: statusColor),
                                  SizedBox(width: 6),
                                  Text("${p['status']} - ${p['species']}", 
                                    style: TextStyle(fontSize: 12, color: Colors.white70)
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align( // Alinha o botão de coração à direita
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            // Se favorito: ícone cheio vermelho. Se não: ícone borda branco.
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, 
                            color: isFav ? Colors.redAccent : Colors.white54),
                            onPressed: () {
                              // Ação de clicar no coração: Chama o provider
                              favProvider.alternarFavorito(
                                context.read<AuthProvider>().usuarioLogado!.email, 
                                p['id'], p['name'], p['image']
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}