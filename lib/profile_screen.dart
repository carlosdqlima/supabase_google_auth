import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obter a instância do SupabaseClient
    final supabase = Supabase.instance.client; 
    // Obter o usuário atual do Supabase
    final user = supabase.auth.currentUser;
    // Extrair metadados do usuário Google
    final profileImageUrl = user?.userMetadata?['avatar_url'];
    final fullName = user?.userMetadata?['full_name'];
    final email = user?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          TextButton(
            onPressed: () async {
              await supabase.auth.signOut();
              if (context.mounted) {
                // Usar pushAndRemoveUntil para limpar a pilha de navegação
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false, // Remove todas as rotas anteriores
                );
              }
            },
            child: const Text('Sair'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (profileImageUrl != null)
              ClipOval(
                child: Image.network(
                  profileImageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  // Adicionar tratamento de erro para a imagem
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.account_circle, size: 100); // Placeholder
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              fullName ?? 'Nome não disponível', // Adicionar fallback
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8), // Espaçamento adicional
            Text(
              email ?? 'Email não disponível', // Adicionar fallback
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}