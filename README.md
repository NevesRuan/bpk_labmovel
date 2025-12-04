
# LabMóvel

> Sistema de gerenciamento de empréstimos de equipamentos para Bibliotecas e/ou laboratórios móveis.

## Descrição

O **BPK LabMóvel** é uma aplicação multiplataforma desenvolvida em Flutter para facilitar o controle de empréstimos de equipamentos em Bibliotecas e/ou laboratórios móveis. O sistema permite o cadastro de usuários, equipamentos, blocos e o gerenciamento completo dos empréstimos, tornando o processo mais ágil, seguro e eficiente.

## Funcionalidades

- Cadastro e autenticação de usuários
- Cadastro de equipamentos e blocos
- Gerenciamento de empréstimos e devoluções
- Visualização de histórico de empréstimos
- Interface intuitiva e responsiva
- Leitura de QR Code para identificação de equipamentos
- Geração de relatórios em PDF
- Seleção e upload de imagens
- Integração completa com Firebase

## Tecnologias Utilizadas

- **Flutter** - Framework multiplataforma
- **Dart** - Linguagem de programação
- **Firebase Authentication** - Autenticação de usuários
- **Cloud Firestore** - Banco de dados NoSQL
- **Provider** - Gerenciamento de estado

## Principais Dependências

- `firebase_core` - SDK do Firebase
- `firebase_auth` - Autenticação
- `cloud_firestore` - Banco de dados
- `firebase_storage` - Storage de arquivos
- `provider` - Gerenciamento de estado
- `qr_code_scanner` / `mobile_scanner` - Leitura de QR Code
- `printing` / `pdf` - Geração de PDFs
- `image_picker` / `file_picker` - Seleção de arquivos
- `url_launcher` - Abertura de URLs

## 📋 Requisitos

- Flutter SDK (versão 3.9.2 ou superior)
- Dart SDK 
- Conta no Firebase (para autenticação e banco de dados)
- Dispositivo ou emulador para testes (Android/iOS)

## Instalação

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/NevesRuan/bpk_labmovel.git
   cd bpk_labmovel
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase:**
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/).
   - Adicione os arquivos de configuração:
     - `android/app/google-services.json` (para Android)
     - `ios/Runner/GoogleService-Info.plist` (para iOS)
     - Configure as regras de segurança no Firestore e Authentication.
   - Atualize o arquivo `lib/firebase_options.dart` com suas configurações do Firebase.

4. **Configure as variáveis de ambiente (opcional):**
   - Crie um arquivo `.env` na raiz do projeto com as chaves do Firebase, conforme o exemplo abaixo.

## Configuração de Variáveis de Ambiente (.env)

O sistema pode utilizar um arquivo `.env` para armazenar variáveis sensíveis e configurações, como chaves de API, URLs de serviços e credenciais. Este arquivo não deve ser versionado no Git para garantir a segurança dos dados.

Exemplo de conteúdo do `.env`:
```env
# Firebase Web Configuration
FIREBASE_WEB_API_KEY=
FIREBASE_WEB_APP_ID=
FIREBASE_MESSAGING_SENDER_ID=
FIREBASE_PROJECT_ID=
FIREBASE_AUTH_DOMAIN=
FIREBASE_STORAGE_BUCKET=

# Firebase Android Configuration
FIREBASE_ANDROID_API_KEY=
FIREBASE_ANDROID_APP_ID=

# Firebase iOS Configuration
FIREBASE_IOS_API_KEY=
FIREBASE_IOS_APP_ID=
FIREBASE_IOS_BUNDLE_ID=

# Firebase Windows Configuration
FIREBASE_WINDOWS_APP_ID=
```

## Como Executar

1. **Conecte um dispositivo ou inicie um emulador.**

2. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

## Build

Para gerar um APK para Android:
```bash
flutter build apk --release
```

Para gerar um IPA para iOS:
```bash
flutter build ios --release
```

## Testes

Execute os testes unitários:
```bash
flutter test
```

Para análise de código:
```bash
flutter analyze
```

## Estrutura do Projeto

```
lib/
├── firebase_options.dart      # Configurações do Firebase
├── main.dart                  # Ponto de entrada da aplicação
├── models/                    # Modelos de dados
├── providers/                 # Gerenciamento de estado
├── services/                  # Serviços e lógica de negócio
├── utils/                     # Utilitários e helpers
└── views/                     # Interfaces e telas
    ├── components/            # Componentes reutilizáveis
    └── pages/                 # Páginas da aplicação
```

## Documentação

- Consulte o arquivo `docs/MPC.md` para detalhes sobre permissões e regras de uso
- Consulte `docs/permissions.yaml` para configuração de permissões

## Autores

- **Ruan Neves** - [@NevesRuan](https://github.com/NevesRuan)
- **Vitor Calliari** - [@Vitor-Calliari](https://github.com/Vitor-Calliari)
- **Herick Neumann** - [@Herick Neumann](https://github.com/Cassinokled)
- **Izadora Morais** - [@Izadora de Morais Weigert](https://github.com/izaweigert)
- **Maria Konrad** - [@MekoWho](https://github.com/MekoWho)

---

Desenvolvido com ❤️ usando Flutter

