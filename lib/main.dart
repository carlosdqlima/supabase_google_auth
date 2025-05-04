import 'package:flutter/material.dart';
import 'package:myapp/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importar flutter_dotenv

void main() async {
  // Carregar variáveis de ambiente do .env
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Supabase Google Auth',
      home: LoginScreen(),
    );
  }
}

// Variável global para facilitar o acesso ao cliente Supabase
final supabase = Supabase.instance.client;