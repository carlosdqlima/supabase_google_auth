import 'package:flutter/material.dart';
import 'package:myapp/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
await Supabase.initialize(
    url: 'https://ocziktxkwnhqzefwndbc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9jemlrdHhrd25ocXplZnduZGJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYyOTYwNjMsImV4cCI6MjA2MTg3MjA2M30.N_rkzUvWOwECHpq34iFgI95Zh_VexpyLiJ4Z1SWkVog',
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