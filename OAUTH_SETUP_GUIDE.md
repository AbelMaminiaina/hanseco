# Guide de Configuration OAuth Google pour HansEco

Ce guide vous aidera à configurer Google OAuth pour l'application Flutter HansEco.

## Problèmes Courants et Solutions

### Erreur: "idpiframe_initialization_failed" ou "popup_closed_by_user"
**Cause**: Configuration Google Cloud Console incorrecte ou Client ID manquant

---

## Étape 1: Créer un Projet Google Cloud

1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. Créez un nouveau projet nommé "HansEco" (ou utilisez un existant)
3. Sélectionnez votre projet

## Étape 2: Activer Google Sign-In API

1. Dans le menu, allez à **APIs & Services** > **Library**
2. Recherchez "Google Sign-In API" ou "Google Identity"
3. Cliquez sur **Enable**

## Étape 3: Créer les Credentials OAuth 2.0

### Pour Flutter Web (Navigateur)

1. Allez à **APIs & Services** > **Credentials**
2. Cliquez sur **Create Credentials** > **OAuth client ID**
3. Type d'application: **Web application**
4. Nom: `HansEco Web Client`
5. **Origines JavaScript autorisées** (Authorized JavaScript origins):
   ```
   http://localhost:3000
   http://localhost:8080
   http://127.0.0.1:3000
   http://127.0.0.1:8080
   ```

6. **URI de redirection autorisés** (Authorized redirect URIs):
   ```
   http://localhost:3000
   http://localhost:8080
   http://127.0.0.1:3000
   http://127.0.0.1:8080
   ```

7. Cliquez sur **Create**
8. **IMPORTANT**: Copiez le **Client ID** (format: `xxxxx.apps.googleusercontent.com`)

### Pour Android (Optionnel - Future)

1. Créez un autre OAuth client ID
2. Type: **Android**
3. Vous aurez besoin du SHA-1 fingerprint:
   ```bash
   cd hanseco_app/android
   ./gradlew signingReport
   ```

### Pour iOS (Optionnel - Future)

1. Créez un autre OAuth client ID
2. Type: **iOS**
3. Bundle ID: `com.hanseco.app` (ou votre bundle ID)

## Étape 4: Configurer le Frontend Flutter

### 4.1 Mettre à jour le fichier `.env`

Ouvrez `hanseco_app/.env` et remplacez:

```env
GOOGLE_CLIENT_ID=VOTRE_VRAI_CLIENT_ID.apps.googleusercontent.com
```

**Exemple**:
```env
GOOGLE_CLIENT_ID=123456789-abc123def456.apps.googleusercontent.com
```

### 4.2 Mettre à jour `web/index.html`

Ouvrez `hanseco_app/web/index.html` et remplacez:

```html
<meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com">
```

Par:

```html
<meta name="google-signin-client_id" content="VOTRE_VRAI_CLIENT_ID.apps.googleusercontent.com">
```

**IMPORTANT**: Utilisez le MÊME Client ID que dans le fichier `.env`

## Étape 5: Configurer le Backend Django

### 5.1 Mettre à jour le fichier `.env` du backend

Ouvrez `backend/.env` et configurez:

```env
# OAuth2 Providers
GOOGLE_OAUTH_CLIENT_ID=VOTRE_CLIENT_ID.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=VOTRE_CLIENT_SECRET

# CORS - Ajoutez les origines autorisées
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080,http://127.0.0.1:3000
```

### 5.2 Vérifier les settings Django

Assurez-vous que `backend/config/settings.py` contient:

```python
INSTALLED_APPS = [
    # ...
    'corsheaders',
    'rest_framework',
    'rest_framework_simplejwt',
    # ...
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # Doit être en premier
    # ...
]

CORS_ALLOWED_ORIGINS = os.getenv('CORS_ALLOWED_ORIGINS', '').split(',')
CORS_ALLOW_CREDENTIALS = True
```

## Étape 6: Vérifier la Configuration

### 6.1 Test de la configuration

Exécutez le script de diagnostic:

```bash
# Windows
.\check_oauth_config.bat

# Linux/Mac
./check_oauth_config.sh
```

### 6.2 Vérifications manuelles

1. **Client ID présent**:
   ```bash
   cd hanseco_app
   grep GOOGLE_CLIENT_ID .env
   ```
   Devrait afficher votre vrai Client ID, PAS `your_google_client_id`

2. **Meta tag configuré**:
   ```bash
   grep "google-signin-client_id" web/index.html
   ```
   Devrait afficher votre vrai Client ID

3. **Backend configuré**:
   ```bash
   cd ../backend
   grep GOOGLE_OAUTH_CLIENT_ID .env
   ```

## Étape 7: Démarrer l'Application

### 7.1 Démarrer le Backend

```bash
cd backend
python manage.py runserver
```

### 7.2 Démarrer le Frontend

```bash
# Depuis la racine du projet
.\start_flutter_app.bat
```

L'application devrait s'ouvrir sur `http://localhost:XXXX`

## Étape 8: Tester OAuth Google

1. Sur la page de login, cliquez sur "Sign in with Google"
2. Une popup Google devrait s'ouvrir
3. Sélectionnez votre compte Google
4. Autorisez l'application
5. Vous devriez être redirigé vers l'application avec votre session active

## Résolution des Problèmes Courants

### Erreur: "idpiframe_initialization_failed"

**Causes possibles**:
- Client ID incorrect ou manquant
- Origines JavaScript non autorisées dans Google Cloud Console
- Cookies bloqués par le navigateur

**Solutions**:
1. Vérifiez que le Client ID est correct dans `.env` ET `web/index.html`
2. Vérifiez les origines autorisées dans Google Cloud Console
3. Essayez en navigation privée
4. Vérifiez que les cookies tiers sont autorisés

### Erreur: "popup_closed_by_user"

L'utilisateur a fermé la popup avant de terminer la connexion.

### Erreur: "access_denied"

**Causes**:
- L'utilisateur a refusé l'autorisation
- Les scopes demandés ne sont pas autorisés

**Solution**: Vérifiez les scopes dans `oauth_service.dart:26-29`

### Erreur: "redirect_uri_mismatch"

**Cause**: L'URI de redirection n'est pas autorisé

**Solution**:
1. Allez sur Google Cloud Console
2. APIs & Services > Credentials
3. Éditez votre OAuth client ID
4. Ajoutez l'URI exact qui apparaît dans l'erreur aux "Authorized redirect URIs"

### Erreur: "Network error" ou "Backend authentication failed"

**Causes**:
- Backend Django non démarré
- URL du backend incorrecte
- CORS mal configuré

**Solutions**:
1. Vérifiez que le backend tourne sur `http://localhost:8000`
2. Vérifiez `API_BASE_URL` dans `hanseco_app/.env`
3. Vérifiez les logs Django pour les erreurs CORS
4. Vérifiez que `CORS_ALLOWED_ORIGINS` contient l'origine du frontend

### Erreur: "Invalid token"

**Cause**: Le backend ne peut pas vérifier le token Google

**Solution**:
1. Vérifiez que `GOOGLE_OAUTH_CLIENT_SECRET` est configuré dans `backend/.env`
2. Vérifiez les logs Django pour plus de détails

## Vérification Finale

Checklist avant de lancer:

- [ ] Projet créé dans Google Cloud Console
- [ ] Google Sign-In API activée
- [ ] OAuth Client ID créé (Web application)
- [ ] Origines JavaScript autorisées configurées
- [ ] Client ID copié dans `hanseco_app/.env`
- [ ] Client ID copié dans `hanseco_app/web/index.html`
- [ ] Client ID et Secret copiés dans `backend/.env`
- [ ] CORS configuré dans `backend/.env`
- [ ] Backend Django démarré
- [ ] Frontend Flutter démarré

## Ressources Supplémentaires

- [Documentation Google Sign-In pour Web](https://developers.google.com/identity/sign-in/web/sign-in)
- [Documentation Flutter google_sign_in](https://pub.dev/packages/google_sign_in)
- [Google Cloud Console](https://console.cloud.google.com/)

## Support

En cas de problème, vérifiez:
1. Les logs du backend Django
2. La console du navigateur (F12)
3. Les logs Flutter dans le terminal

Pour des erreurs spécifiques, consultez la section "Résolution des Problèmes Courants" ci-dessus.
