# Guide d'Implémentation OAuth 2.0 + JWT pour HansEco

Ce guide explique comment configurer et utiliser l'authentification OAuth 2.0 avec JWT dans l'application HansEco.

## 📋 Table des Matières

1. [Vue d'ensemble](#vue-densemble)
2. [Architecture](#architecture)
3. [Configuration Backend (Django)](#configuration-backend-django)
4. [Configuration Frontend (Flutter)](#configuration-frontend-flutter)
5. [Utilisation](#utilisation)
6. [Endpoints API](#endpoints-api)
7. [Sécurité](#sécurité)
8. [Dépannage](#dépannage)

---

## 📖 Vue d'ensemble

L'application utilise:
- **OAuth 2.0** pour l'authentification sociale (Google, Facebook, Apple)
- **JWT (JSON Web Tokens)** pour la gestion des sessions
- **flutter_secure_storage** pour le stockage sécurisé des tokens

### Flux d'Authentification

```
1. Utilisateur → Clic sur "Sign in with Google/Facebook"
2. Application → Affiche l'écran de connexion du provider
3. Provider → Retourne un token d'accès
4. Application → Envoie le token au backend Django
5. Backend → Vérifie le token et crée/récupère l'utilisateur
6. Backend → Génère des tokens JWT (access + refresh)
7. Application → Stocke les tokens de manière sécurisée
8. Application → Utilise l'access token pour les requêtes API
```

---

## 🏗️ Architecture

### Backend (Django)
```
hanseco_backend/
├── apps/
│   └── oauth/
│       ├── __init__.py
│       ├── apps.py
│       ├── serializers.py     # Serializers OAuth2
│       ├── views.py            # Views Google/Facebook
│       └── urls.py             # Routes OAuth2
└── core/
    └── settings/
        └── base.py             # Configuration JWT + OAuth2
```

### Frontend (Flutter)
```
hanseco_app/
├── lib/
│   ├── core/
│   │   └── auth/
│   │       ├── token_manager.dart    # Gestion des tokens JWT
│   │       └── oauth_service.dart    # Service OAuth2
│   └── features/
       └── auth/
           └── presentation/
               ├── providers/
               │   └── oauth_provider.dart  # Provider Riverpod
               └── widgets/
                   └── oauth_buttons.dart   # Boutons OAuth

```

---

## 🔧 Configuration Backend (Django)

### 1. Installer les dépendances

```bash
cd backend
pip install -r requirements.txt
```

Les packages installés incluent:
- `djangorestframework-simplejwt` - JWT authentication
- `google-auth` - Google OAuth2
- `google-auth-oauthlib` - Google OAuth2 library

### 2. Créer le fichier `.env`

```bash
cp .env.example .env
```

### 3. Configurer Google OAuth2

#### a. Créer un projet Google Cloud

1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. Créez un nouveau projet
3. Activez "Google+ API"
4. Allez dans "Credentials" > "Create Credentials" > "OAuth client ID"
5. Type: "Web application"
6. Authorized redirect URIs:
   - `http://localhost:8000/api/oauth/google/callback/`
   - `http://localhost:3000` (pour le développement web)

#### b. Récupérer les credentials

Copiez le **Client ID** et **Client Secret** dans `.env`:

```env
GOOGLE_OAUTH_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=your-google-client-secret
```

### 4. Configurer Facebook OAuth2

#### a. Créer une app Facebook

1. Allez sur [Facebook Developers](https://developers.facebook.com/)
2. Créez une nouvelle app
3. Ajoutez "Facebook Login" à votre app
4. Dans Settings > Basic:
   - Notez l'App ID et App Secret
5. Dans Facebook Login > Settings:
   - Valid OAuth Redirect URIs: `http://localhost:8000/api/oauth/facebook/callback/`

#### b. Configurer `.env`

```env
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-app-secret
```

### 5. Appliquer les migrations

```bash
cd backend
python manage.py migrate
```

### 6. Lancer le serveur

```bash
python manage.py runserver
```

---

## 📱 Configuration Frontend (Flutter)

### 1. Installer les dépendances

```bash
cd hanseco_app
flutter pub get
```

Les packages installés:
- `google_sign_in` - Google Sign In
- `flutter_facebook_auth` - Facebook Authentication
- `sign_in_with_apple` - Apple Sign In
- `jwt_decoder` - JWT decoding
- `flutter_secure_storage` - Secure token storage

### 2. Configuration Android (Google Sign In)

#### a. Fichier `android/app/build.gradle`

```gradle
defaultConfig {
    // ...
    minSdkVersion 21  // Minimum requis
}
```

#### b. SHA-1 Certificate

```bash
# Debug
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Production
keytool -list -v -keystore /path/to/your-release-key.keystore -alias your-key-alias
```

Ajoutez le SHA-1 dans Google Cloud Console.

### 3. Configuration iOS (Google Sign In)

#### Fichier `ios/Runner/Info.plist`

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Reversed client ID from Google -->
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

### 4. Configuration Facebook

#### Android: `android/app/src/main/res/values/strings.xml`

```xml
<resources>
    <string name="app_name">HansEco</string>
    <string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
    <string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
</resources>
```

#### Android: `android/app/src/main/AndroidManifest.xml`

```xml
<meta-data
    android:name="com.facebook.sdk.ApplicationId"
    android:value="@string/facebook_app_id"/>
```

#### iOS: `ios/Runner/Info.plist`

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fbYOUR_FACEBOOK_APP_ID</string>
        </array>
    </dict>
</array>
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookDisplayName</key>
<string>HansEco</string>
```

### 5. Mettre à jour `.env`

```env
API_BASE_URL=http://localhost:8000/api
```

---

## 🚀 Utilisation

### Exemple d'utilisation dans une page

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/oauth_provider.dart';
import '../widgets/oauth_buttons.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oauthState = ref.watch(oauthNotifierProvider);
    final oauthNotifier = ref.read(oauthNotifierProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google Sign In
            GoogleSignInButton(
              onPressed: () async {
                await oauthNotifier.signInWithGoogle();

                if (oauthState.isAuthenticated) {
                  // Navigation vers la page principale
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              isLoading: oauthState.isLoading,
            ),

            const SizedBox(height: 16),

            // Facebook Sign In
            FacebookSignInButton(
              onPressed: () async {
                await oauthNotifier.signInWithFacebook();

                if (oauthState.isAuthenticated) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              isLoading: oauthState.isLoading,
            ),

            // Afficher les erreurs
            if (oauthState.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  oauthState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

### Déconnexion

```dart
// Bouton de déconnexion
ElevatedButton(
  onPressed: () async {
    await ref.read(oauthNotifierProvider.notifier).signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  },
  child: const Text('Se déconnecter'),
)
```

### Vérifier l'authentification

```dart
// Dans un ConsumerWidget
final isAuthenticated = ref.watch(isAuthenticatedProvider);

if (!isAuthenticated) {
  return LoginPage();
}

return HomePage();
```

### Utiliser le token JWT dans les requêtes

```dart
import 'package:dio/dio.dart';
import '../core/auth/token_manager.dart';

class ApiClient {
  final Dio dio;
  final TokenManager tokenManager;

  ApiClient(this.dio, this.tokenManager) {
    // Intercepteur pour ajouter le token à chaque requête
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenManager.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Gérer l'expiration du token
          if (error.response?.statusCode == 401) {
            // Rafraîchir le token
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Réessayer la requête
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    // Implémenter le refresh du token
    // ...
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
```

---

## 🔌 Endpoints API

### Google OAuth2
```http
POST /api/oauth/google/
Content-Type: application/json

{
  "auth_token": "google_id_token_here"
}

Response 200:
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbG...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbG...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe"
  },
  "is_new_user": false
}
```

### Facebook OAuth2
```http
POST /api/oauth/facebook/
Content-Type: application/json

{
  "auth_token": "facebook_access_token_here"
}

Response 200: (same as Google)
```

### Refresh Token
```http
POST /api/oauth/token/refresh/
Content-Type: application/json

{
  "refresh": "refresh_token_here"
}

Response 200:
{
  "access": "new_access_token_here"
}
```

---

## 🔒 Sécurité

### Bonnes pratiques

1. **Ne jamais stocker les tokens en clair**
   - Utilisez `flutter_secure_storage`
   - Les tokens sont chiffrés dans Keychain (iOS) et EncryptedSharedPreferences (Android)

2. **Vérifier l'expiration des tokens**
   ```dart
   final isExpired = await tokenManager.isAccessTokenExpired();
   if (isExpired) {
     await oauthService.refreshAccessToken();
   }
   ```

3. **HTTPS en production**
   - Utilisez toujours HTTPS pour les requêtes API
   - Configurez SSL Pinning pour plus de sécurité

4. **Rotation des tokens**
   - Les refresh tokens sont automatiquement renouvelés
   - Configuré dans `SIMPLE_JWT` settings

5. **Validation backend**
   - Tous les tokens OAuth sont vérifiés côté serveur
   - Les tokens Google sont validés avec `google.oauth2.id_token`
   - Les tokens Facebook sont validés via Graph API

---

## 🐛 Dépannage

### Google Sign In ne fonctionne pas

**Problème**: "PlatformException(sign_in_failed)"

**Solution**:
1. Vérifiez que le SHA-1 est correctement ajouté dans Google Cloud Console
2. Assurez-vous que l'API Google+ est activée
3. Vérifiez que le package name correspond

### Facebook Login échoue

**Problème**: "Invalid key hash"

**Solution**:
```bash
# Générer le key hash
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64

# Ajoutez-le dans Facebook Developer Console
```

### Token JWT expiré

**Problème**: Erreur 401 Unauthorized

**Solution**:
```dart
// Le token manager gère automatiquement le refresh
final service = OAuthService(dio);
await service.refreshAccessToken();
```

### Erreur CORS

**Problème**: "Access to XMLHttpRequest has been blocked by CORS policy"

**Solution**:
Vérifiez `CORS_ALLOWED_ORIGINS` dans `.env`:
```env
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080,http://127.0.0.1:8080
```

---

## 📚 Ressources

- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Facebook Login Flutter](https://pub.dev/packages/flutter_facebook_auth)
- [Django REST Framework SimpleJWT](https://django-rest-framework-simplejwt.readthedocs.io/)
- [Google OAuth2 Documentation](https://developers.google.com/identity/protocols/oauth2)
- [Facebook Login Documentation](https://developers.facebook.com/docs/facebook-login)

---

## ✅ Checklist de déploiement

- [ ] Configurer Google OAuth2 pour production
- [ ] Configurer Facebook OAuth2 pour production
- [ ] Ajouter les domaines de production dans CORS_ALLOWED_ORIGINS
- [ ] Utiliser des secrets sécurisés (pas de .env dans le code)
- [ ] Activer HTTPS
- [ ] Configurer SSL Pinning
- [ ] Tester sur iOS et Android
- [ ] Ajouter la politique de confidentialité
- [ ] Ajouter les conditions d'utilisation

---

**Développé par l'équipe HansEco** 🚀
