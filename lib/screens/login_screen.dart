import 'dart:io'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart'; 
import 'package:myapp/screens/profile_screen.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userId = 'Não autenticado';
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
    final initialSession = supabase.auth.currentSession;
    if (initialSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      });
      _updateUserId(initialSession.user.id);
    }
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      if (event == AuthChangeEvent.signedIn && session != null) {
        _updateUserId(session.user.id);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      } else if (event == AuthChangeEvent.signedOut) {
        setState(() {
          userId = 'Não autenticado';
        });
      }
    });
  }

  void _updateUserId(String newUserId) {
    if (mounted) {
      setState(() {
        userId = newUserId;
      });
    }
  }

  Future<void> _nativeGoogleSignIn() async {
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
    final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];

    // Verificar se os IDs foram carregados
    if (webClientId == null || iosClientId == null) {
       print('Erro: Client IDs do Google não encontrados no .env');
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Erro de configuração: Client IDs ausentes.'))
         );
       }
       return;
    }

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId, // Usar variável carregada
        serverClientId: webClientId, // Usar variável carregada
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login com Google cancelado.')));
        }
        return;
      }
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'ID Token não encontrado.';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro no login nativo: ${error.toString()}')));
      }
      print('Erro no Google Sign In Nativo: $error');
    }
  }

  Future<void> handleGoogleSignIn() async {
    try {
      // Verificar se estamos na plataforma web ou mobile
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // Implementação nativa para iOS/Android
        return _nativeGoogleSignIn();
      } else {
        // Implementação para web
        await supabase.auth.signInWithOAuth(
          OAuthProvider.google, 
          redirectTo: kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
        );
      }
    } catch (e) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Erro no login: ${e.toString()}')));
       }
      print('Erro no handleGoogleSignIn: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Sign Up')),
      body: Padding( 
        padding: const EdgeInsets.all(16.0),
        child: SupaSocialsAuth(
          socialProviders: const [
            OAuthProvider.google,
          ],
          colored: true,
          redirectUrl: kIsWeb
              ? null
              : 'io.supabase.flutterquickstart://login-callback/',
          onSuccess: (Session response) {
            print('Login completo via button: ${response.user.id}');
            _updateUserId(response.user.id);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login com Google bem-sucedido!')));
          },
          onError: (error) {
            // Mostrar mensagem de erro
            print('Erro no login social: $error');
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro no login: ${error.toString()}')));
          },
        ),
      ),
    );
  }
}