# Configuration OAuth pour HansEco

Ce guide vous aidera à configurer l'authentification Google et Facebook pour votre application.

## 1. Configuration Google OAuth

### Étape 1: Créer un projet Google Cloud

1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. Créez un nouveau projet ou sélectionnez un projet existant
3. Nommez votre projet (ex: "HansEco")

### Étape 2: Activer l'API Google Sign-In

1. Dans le menu de navigation, allez à **APIs & Services** > **Library**
2. Recherchez "Google+ API" ou "Google Identity"
3. Cliquez sur **Enable**

### Étape 3: Créer des identifiants OAuth 2.0

1. Allez à **APIs & Services** > **Credentials**
2. Cliquez sur **Create Credentials** > **OAuth client ID**
3. Si demandé, configurez l'écran de consentement OAuth:
   - Type d'application: **Externe**
   - Nom de l'application: **HansEco**
   - Email d'assistance utilisateur: votre email
   - Domaines autorisés: `localhost` (pour le développement)
   - Scopes: ajoutez `email` et `profile`

4. Créez l'identifiant OAuth client ID:
   - Type d'application: **Application Web**
   - Nom: **HansEco Web Client**
   - Origines JavaScript autorisées:
     - `http://localhost:3000`
     - `http://localhost` (si nécessaire)
   - URI de redirection autorisés:
     - `http://localhost:3000`

5. Cliquez sur **Create**
6. **Copiez le Client ID** (format: `xxxxx.apps.googleusercontent.com`)

### Étape 4: Configurer l'application Flutter

1. Ouvrez le fichier `hanseco_app/.env`
2. Remplacez `your_google_client_id.apps.googleusercontent.com` par votre vrai Client ID:
   ```env
   GOOGLE_CLIENT_ID=123456789-abc123def456.apps.googleusercontent.com
   ```

3. Ouvrez le fichier `hanseco_app/web/index.html`
4. Remplacez également le Client ID dans la balise meta:
   ```html
   <meta name="google-signin-client_id" content="123456789-abc123def456.apps.googleusercontent.com">
   ```

### Étape 5: Configurer le backend Django

1. Ouvrez `backend/hanseco_backend/core/settings.py`
2. Ajoutez votre Google Client ID:
   ```python
   GOOGLE_OAUTH_CLIENT_ID = '123456789-abc123def456.apps.googleusercontent.com'
   ```

## 2. Configuration Facebook OAuth

### Étape 1: Créer une application Facebook

1. Allez sur [Facebook Developers](https://developers.facebook.com/)
2. Cliquez sur **My Apps** > **Create App**
3. Sélectionnez **Consumer** comme type d'application
4. Nommez votre app: **HansEco**

### Étape 2: Configurer Facebook Login

1. Dans le tableau de bord de votre app, ajoutez le produit **Facebook Login**
2. Sélectionnez **Web** comme plateforme
3. Site Web URL: `http://localhost:3000`

### Étape 3: Récupérer l'App ID

1. Allez à **Settings** > **Basic**
2. Copiez l'**App ID**
3. Copiez l'**App Secret** (pour le backend)

### Étape 4: Configurer les domaines autorisés

1. Dans **Facebook Login** > **Settings**
2. Ajoutez dans **Valid OAuth Redirect URIs**:
   - `http://localhost:3000`
3. Ajoutez dans **App Domains**:
   - `localhost`

### Étape 5: Configurer l'application Flutter

1. Ouvrez `hanseco_app/.env`
2. Remplacez `your_facebook_app_id`:
   ```env
   FACEBOOK_APP_ID=1234567890123456
   ```

### Étape 6: Configurer le backend Django

1. Les tokens Facebook sont vérifiés côté backend via l'API Graph
2. Aucune configuration supplémentaire n'est nécessaire dans Django

## 3. Tester l'authentification

### Redémarrer l'application

1. Arrêtez le serveur Flutter (Ctrl+C)
2. Relancez avec:
   ```bash
   cd hanseco_app
   flutter run -d chrome --web-port 3000
   ```

### Tester Google Sign In

1. Allez sur `http://localhost:3000`
2. Cliquez sur "Connexion avec Google"
3. Sélectionnez votre compte Google
4. Vous devriez être redirigé vers la page d'accueil

### Tester Facebook Sign In

1. Sur la page de connexion
2. Cliquez sur "Connexion avec Facebook"
3. Connectez-vous avec votre compte Facebook
4. Autorisez l'application
5. Vous devriez être redirigé vers la page d'accueil

## 4. Dépannage

### Erreur: "Client ID not set"

- Vérifiez que le Client ID est bien dans `.env`
- Vérifiez que le Client ID est bien dans `web/index.html`
- Redémarrez l'application Flutter

### Erreur: "Invalid token" (Backend)

- Vérifiez que `GOOGLE_OAUTH_CLIENT_ID` dans `settings.py` correspond au Client ID
- Vérifiez que l'origine JavaScript est autorisée dans Google Cloud Console

### Erreur: "Origin not allowed" (Facebook)

- Vérifiez que `localhost` est dans App Domains
- Vérifiez que `http://localhost:3000` est dans Valid OAuth Redirect URIs

### Erreur CORS

- Vérifiez que CORS est bien configuré dans Django (déjà fait dans ce projet)
- `CORS_ALLOWED_ORIGINS` doit inclure `http://localhost:3000`

## 5. Production

Quand vous passerez en production, vous devrez:

1. **Google OAuth**:
   - Ajouter votre domaine de production dans Google Cloud Console
   - Mettre à jour le Client ID dans `.env` et `index.html`

2. **Facebook OAuth**:
   - Passer l'app en mode "Live" (pas "Development")
   - Ajouter votre domaine de production dans les App Domains
   - Mettre à jour les URLs de redirection

3. **Backend**:
   - Mettre à jour `CORS_ALLOWED_ORIGINS` avec votre domaine de production
   - Utiliser HTTPS pour toutes les communications

## 6. Ressources

- [Google Sign-In for Web](https://developers.google.com/identity/sign-in/web/sign-in)
- [Facebook Login for the Web](https://developers.facebook.com/docs/facebook-login/web)
- [Flutter google_sign_in package](https://pub.dev/packages/google_sign_in)
- [Flutter flutter_facebook_auth package](https://pub.dev/packages/flutter_facebook_auth)
