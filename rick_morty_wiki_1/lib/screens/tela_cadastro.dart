import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';

class TelaCadastro extends StatelessWidget {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Isso faz o gradiente passar por baixo da barra de voltar (AppBar)
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fundo invisível
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF97CE4C)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF202329), Color(0xFF3C3E44)],
          ),
        ),
        child: SingleChildScrollView( // Garante que não quebre se o teclado subir
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ícone de Novo Usuário
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black26,
                    border: Border.all(color: Color(0xFF97CE4C), width: 2)
                ),
                child: Icon(Icons.person_add, size: 60, color: Color(0xFF97CE4C)),
              ),

              SizedBox(height: 20),

              Text("Junte-se ao Multiverso",
                textAlign: TextAlign.center,
                style: GoogleFonts.creepster(fontSize: 32, color: Colors.white),
              ),

              SizedBox(height: 10),
              Text("Crie sua conta para salvar seus personagens favoritos.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              SizedBox(height: 40),

              // Campos de Texto (Reutilizando o estilo do Login)
              _buildTextField("Novo Email", Icons.email_outlined, _emailController, false),
              SizedBox(height: 20),
              _buildTextField("Criar Senha", Icons.lock_outline, _senhaController, true),

              SizedBox(height: 40),

              // Botão de Cadastrar
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF97CE4C), // Verde Neon
                    foregroundColor: Colors.black, // Cor do texto
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () async {
                    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Preencha todos os campos!"),
                        backgroundColor: Colors.orange,
                      ));
                      return;
                    }

                    bool sucesso = await context.read<AuthProvider>().cadastrar(
                        _emailController.text,
                        _senhaController.text
                    );

                    if (sucesso) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Conta criada com sucesso! Faça login."),
                        backgroundColor: Colors.green,
                      ));
                      Navigator.pop(context); // Volta para a tela de Login
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Este email já está cadastrado."),
                        backgroundColor: Colors.redAccent,
                      ));
                    }
                  },
                  child: Text("CRIAR CONTA",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para estilizar os campos (Igual ao do Login)
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF97CE4C), width: 2),
        ),
      ),
    );
  }
}