# Exemplo de Autenticação Google com Supabase e Flutter

Este é um projeto Flutter de exemplo que demonstra como implementar a autenticação de usuários usando o Google como provedor OAuth através do Supabase.

## Funcionalidades

*   Login com conta Google.
*   Integração com Supabase para gerenciamento de autenticação e backend.
*   Uso de variáveis de ambiente para configuração segura das credenciais do Supabase.

## Começando

Siga estas instruções para obter uma cópia do projeto em execução na sua máquina local para desenvolvimento e teste.

### Pré-requisitos

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
*   Uma conta no [Supabase](https://supabase.com/).
*   Credenciais OAuth do Google configuradas no seu projeto Supabase.

### Instalação

1.  Clone o repositório:
    ```bash
    git clone <url-do-repositorio>
    cd supabase_google_auth
    ```
2.  Instale as dependências:
    ```bash
    flutter pub get
    ```
3.  Configure as variáveis de ambiente:
    *   Crie um arquivo chamado `.env` na raiz do projeto.
    *   Adicione as seguintes variáveis ao arquivo `.env`, substituindo pelos valores do seu projeto Supabase e das suas credenciais Google Cloud:
        ```dotenv
        SUPABASE_URL=SUA_SUPABASE_URL
        SUPABASE_ANON_KEY=SUA_SUPABASE_ANON_KEY
        GOOGLE_WEB_CLIENT_ID=SEU_GOOGLE_WEB_CLIENT_ID
        GOOGLE_IOS_CLIENT_ID=SEU_GOOGLE_IOS_CLIENT_ID
        ```
    *   Você pode encontrar a URL e a Chave Anônima (Anon Key) nas configurações de API do seu projeto Supabase.
    *   Os `GOOGLE_WEB_CLIENT_ID` e `GOOGLE_IOS_CLIENT_ID` são obtidos no [Google Cloud Console](https://console.cloud.google.com/) ao configurar as credenciais do OAuth 2.0 para as plataformas Web e iOS, respectivamente. Eles são necessários para o fluxo de login do Google funcionar corretamente em cada plataforma.

### Configuração do Supabase e Google OAuth

1.  **Crie um projeto no Supabase.**
2.  **Habilite o provedor Google Auth:**
    *   Vá para `Authentication` -> `Providers` no seu painel Supabase.
    *   Ative o provedor `Google`.
    *   Siga as instruções do Supabase para configurar as credenciais OAuth do Google (Client ID e Client Secret). Você precisará criar credenciais no [Google Cloud Console](https://console.cloud.google.com/). Certifique-se de criar credenciais separadas para Web e iOS, se aplicável, para obter os IDs corretos.
    *   Certifique-se de adicionar os URIs de redirecionamento corretos fornecidos pelo Supabase nas configurações do seu cliente OAuth no Google Cloud Console.

## Executando o Aplicativo

Para executar o aplicativo em um navegador Chrome na porta 3000, use o comando:

```bash
flutter run -d chrome --web-port 3000
```

## Estrutura do Projeto

*   `lib/main.dart`: Ponto de entrada da aplicação, inicialização do Supabase.
*   `lib/login_screen.dart`: Tela de login onde o usuário inicia o fluxo de autenticação com o Google.
*   `lib/profile_screen.dart`: Tela exibida após o login bem-sucedido, mostrando informações básicas do usuário (a ser implementada ou detalhada).
*   `.env`: Arquivo (não versionado) para armazenar as credenciais do Supabase.
*   `pubspec.yaml`: Define as dependências do projeto, incluindo `supabase_flutter` e `flutter_dotenv`.

## Dependências Principais

*   [supabase_flutter](https://pub.dev/packages/supabase_flutter): Cliente Dart e Flutter para Supabase.
*   [flutter_dotenv](https://pub.dev/packages/flutter_dotenv): Para carregar variáveis de ambiente de um arquivo `.env`.

## Fontes e Documentação

*   [Documentação Oficial do Supabase Flutter](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)
*   [Guia de Autenticação OAuth do Supabase](https://supabase.com/docs/guides/auth/social-login/auth-google)
*   [Pacote `supabase_flutter` no pub.dev](https://pub.dev/packages/supabase_flutter)
*   [Pacote `google_sign_in` no pub.dev](https://pub.dev/packages/google_sign_in)
*   [Configuração do Google Cloud Console para OAuth 2.0](https://developers.google.com/identity/protocols/oauth2)
*   [Exemplo Completo: Flutter Native Google Auth (Supabase GitHub)](https://github.com/supabase/supabase/tree/master/examples/auth/flutter-native-google-auth)
*   [Artigo: Flutter Authentication (Supabase Blog)](https://supabase.com/blog/flutter-authentication)
