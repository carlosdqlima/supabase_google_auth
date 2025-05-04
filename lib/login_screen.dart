import 'dart:io'; // Importação adicionada
import 'package:flutter/foundation.dart'; // Importação adicionada
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart'; // Importação adicionada

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
      _updateUserId(initialSession.user.id);
    }
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      if (event == AuthChangeEvent.signedIn && session != null) {
        _updateUserId(session.user.id);
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

  // Renomeado de _googleSignIn para _nativeGoogleSignIn
  Future<void> _nativeGoogleSignIn() async {
    const webClientId = '249987982928-elmor03q36g9r0eibih4fcrh5fna7v4h.apps.googleusercontent.com';
    const iosClientId = '249987982928-omum2tseq7mvdkedon7is0h1q7og6mpq.apps.googleusercontent.com';

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
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

  // Novo método adicionado
  Future<void> handleGoogleSignIn() async {
    try {
      // Verificar se estamos na plataforma web ou mobile
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // Implementação nativa para iOS/Android
        return _nativeGoogleSignIn();
      } else {
        // Implementação para web
        await supabase.auth.signInWithOAuth(
          OAuthProvider.google, // Provider pode ser passado diretamente
          // redirectTo é necessário para mobile deep linking, opcional para web se configurado no Supabase dashboard
          redirectTo: kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/', // Ajuste o scheme se necessário
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
      body: Padding( // Adicionado Padding para melhor visualização
        padding: const EdgeInsets.all(16.0),
        // Substituído SupaEmailAuth por SupaSocialsAuth focado no Google
        child: SupaSocialsAuth(
          socialProviders: const [ // Apenas Google habilitado
            OAuthProvider.google,
          ],
          colored: true, // Usar botões coloridos
          redirectUrl: kIsWeb
              ? null
              : 'io.supabase.flutterquickstart://login-callback/', // Ajuste o scheme se necessário
          onSuccess: (Session response) {
            // Navegar ou mostrar mensagem de sucesso
            print('Sign in complete: ${response.user.id}');
            _updateUserId(response.user.id);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login com Google bem-sucedido!')));
            // Exemplo: Navigator.of(context).pushReplacementNamed('/home');
          },
          onError: (error) {
            // Mostrar mensagem de erro
            print('Erro no login social: $error');
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro no login: ${error.toString()}')));
            // Exemplo: Navigator.of(context).pushReplacementNamed('/error_page');
          },
        ),
      ),
    );
  }
}