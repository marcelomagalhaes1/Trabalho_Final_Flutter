import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Importe a fonte

import 'models/usuario_model.dart';
import 'models/favorito_model.dart';
import 'providers/auth_provider.dart';
import 'providers/favoritos_provider.dart';
import 'screens/tela_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UsuarioAdapter());
  Hive.registerAdapter(FavoritoAdapter());
  await Hive.openBox<Usuario>('box_usuarios');
  await Hive.openBox<Favorito>('box_favoritos');

  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FavoritosProvider()),
      ],
      child: MaterialApp(
        title: 'Rick & Morty Wiki',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define o modo escuro como padrão
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF202329), // Cinza do desenho
          primaryColor: Color(0xFF97CE4C), // Verde do Portal

          // Configura a fonte global
          textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),

          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF202329),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.creepster( // Fonte estilo "Terror/Cartoon" para títulos
                fontSize: 28,
                color: Color(0xFF97CE4C),
                letterSpacing: 2
            ),
          ),

          colorScheme: ColorScheme.dark(
            primary: Color(0xFF97CE4C),
            secondary: Color(0xFF00B5CC), // Azul claro do Rick
          ),
          useMaterial3: true,
        ),
        home: TelaLogin(),
      ),
    );
  }
}