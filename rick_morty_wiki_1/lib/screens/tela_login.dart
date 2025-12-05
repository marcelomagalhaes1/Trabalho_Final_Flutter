import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import 'tela_cadastro.dart';
import 'tela_home.dart';

class TelaLogin extends StatelessWidget {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 1. GestureDetector: Fecha o teclado ao clicar fora
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          height: double.infinity, // Garante que o gradiente pegue a tela toda
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF202329), Color(0xFF3C3E44)],
            ),
          ),
          // 2. Center: Centraliza o conteúdo verticalmente
          child: Center(
            // 3. SingleChildScrollView: Evita o erro de "overflow" quando o teclado sobe
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo ou Título Grande
                  Icon(Icons.science, size: 80, color: Color(0xFF97CE4C)),
                  SizedBox(height: 10),
                  Text(
                    "WUBBA LUBBA\nDUB DUB!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.creepster(fontSize: 40, color: Color(0xFF00B5CC)),
                  ),
                  SizedBox(height: 40),

                  // Campo Email
                  _buildTextField("Email", Icons.email, _emailController, false),
                  SizedBox(height: 16),

                  // Campo Senha
                  _buildTextField("Senha", Icons.lock, _senhaController, true),
                  SizedBox(height: 30),

                  // Botão Entrar Grande e Bonito
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF97CE4C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        // Fecha o teclado antes de tentar logar (boa prática)
                        FocusScope.of(context).unfocus();

                        bool sucesso = await context.read<AuthProvider>().logar(
                            _emailController.text, _senhaController.text
                        );
                        if (sucesso) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TelaHome()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Credenciais inválidas!"), backgroundColor: Colors.redAccent,
                          ));
                        }
                      },
                      child: Text("ACESSAR PORTAL",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TelaCadastro())),
                    child: Text("Ainda não é um viajante? Cadastre-se", style: TextStyle(color: Colors.white70)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Color(0xFF97CE4C)),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF97CE4C))),
      ),
    );
  }
}