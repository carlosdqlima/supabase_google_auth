import 'package:flutter/material.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

void main() async {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Autenticação com Supabase e Google',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 191, 243, 33),
      ),
      home: const LoginScreen(),
    );
  }
}

// Variável global para facilitar o acesso ao cliente Supabase.
final supabase = Supabase.instance.client;

