# Guide de Configuration CI/CD - HansEco

Ce guide explique comment configurer le déploiement automatique via GitHub Actions pour Android et iOS.

---

## 📋 Vue d'ensemble

### Workflows disponibles

1. **`test.yml`** - Tests automatiques sur chaque push/PR
   - Tests backend Django
   - Tests frontend Flutter
   - Linting du code

2. **`deploy-android.yml`** - Déploiement Android automatique
   - Build APK et App Bundle
   - Upload sur GitHub Releases
   - Déploiement sur Google Play (Internal Testing)

3. **`deploy-ios.yml`** - Déploiement iOS automatique
   - Build IPA
   - Upload sur GitHub Releases
   - Déploiement sur TestFlight

---

## 🔧 Configuration des Secrets GitHub

### Étape 1: Accéder aux secrets

1. Allez sur votre repo GitHub: https://github.com/AbelMaminiaina/hanseco
2. Settings → Secrets and variables → Actions
3. Cliquez sur "New repository secret"

### Étape 2: Configurer les secrets communs

#### `API_BASE_URL`
- **Valeur**: URL de votre API de production
- **Exemple**: `https://api.hanseco.com/api`
- **Description**: URL du backend pour l'app en production

#### `GOOGLE_CLIENT_ID`
- **Valeur**: Votre Google OAuth Client ID
- **Exemple**: `989504216135-49n11u6da00cc1gd300qid99fchd1la9.apps.googleusercontent.com`
- **Description**: Client ID pour OAuth Google

---

## 🗄️ Configuration Backend (Django + PostgreSQL Neon)

### Secrets Backend requis

#### 1. `DATABASE_URL`
- **Valeur**: Connection string PostgreSQL de Neon
- **Exemple**: `postgresql://user:password@ep-bold-dawn-a8c6i3pn-pooler.eastus2.azure.neon.tech/neondb?sslmode=require`
- **Comment obtenir**:
  1. Allez sur https://console.neon.tech/
  2. Sélectionnez votre projet
  3. Dashboard → Connection Details
  4. Copiez la connection string complète

#### 2. `DJANGO_SECRET_KEY`
- **Valeur**: Clé secrète Django pour la production
- **Comment générer**:
  ```python
  from django.core.management.utils import get_random_secret_key
  print(get_random_secret_key())
  ```
- **Exemple**: `django-insecure-abc123xyz...`

#### 3. `DJANGO_ALLOWED_HOSTS`
- **Valeur**: Hosts autorisés (séparés par des virgules)
- **Exemple**: `hanseco.com,www.hanseco.com,api.hanseco.com`

#### 4. `CORS_ALLOWED_ORIGINS`
- **Valeur**: Origines CORS autorisées (séparées par des virgules)
- **Exemple**: `https://hanseco.com,https://www.hanseco.com`

#### 5. `JWT_SECRET_KEY`
- **Valeur**: Clé secrète pour JWT
- **Comment générer**: Utilisez le même script que pour `DJANGO_SECRET_KEY`

#### 6. `GOOGLE_OAUTH_CLIENT_SECRET`
- **Valeur**: Votre Google OAuth Client Secret
- **Exemple**: `GOCSPX-abc123xyz...`

### Options de déploiement Backend

Le workflow `deploy-backend.yml` supporte plusieurs plateformes:

#### Option 1: Railway (Recommandé - Gratuit)

1. Créez un compte sur https://railway.app/
2. Installez Railway CLI
3. Obtenez un token:
   ```bash
   railway login
   railway whoami --token
   ```
4. Ajoutez `RAILWAY_TOKEN` aux secrets GitHub

#### Option 2: Render (Gratuit)

1. Créez un compte sur https://render.com/
2. Créez un nouveau Web Service
3. Connectez votre repo GitHub
4. Dans Settings → Deploy Hook, copiez l'URL
5. Ajoutez `RENDER_DEPLOY_HOOK` aux secrets GitHub

#### Option 3: Heroku

1. Créez un compte sur https://heroku.com/
2. Obtenez votre API Key: Account Settings → API Key
3. Ajoutez ces secrets:
   - `HEROKU_API_KEY`
   - `HEROKU_APP_NAME`
   - `HEROKU_EMAIL`

#### Option 4: VPS personnalisé (DigitalOcean, AWS EC2, etc.)

1. Configurez votre serveur VPS
2. Générez une clé SSH:
   ```bash
   ssh-keygen -t rsa -b 4096
   cat ~/.ssh/id_rsa  # Copiez la clé privée
   ```
3. Ajoutez ces secrets:
   - `VPS_HOST`: IP ou domaine du serveur
   - `VPS_USERNAME`: nom d'utilisateur SSH
   - `VPS_SSH_KEY`: clé SSH privée

---

## 🤖 Configuration Android

### Secrets Android requis

#### 1. `KEYSTORE_BASE64`

**Comment obtenir:**
```bash
# Encodez votre keystore en base64
cd hanseco_app/android
base64 -i hanseco-release-key.jks -o keystore.txt

# Sur Windows (PowerShell):
certutil -encode hanseco-release-key.jks keystore.txt
```

Copiez le contenu de `keystore.txt` (sans les lignes BEGIN/END sur Windows)

#### 2. `KEYSTORE_PASSWORD`
- **Valeur**: Le mot de passe de votre keystore
- **Exemple**: `MySecurePassword123`

#### 3. `KEY_PASSWORD`
- **Valeur**: Le mot de passe de votre clé
- **Exemple**: `MySecurePassword123`

#### 4. `KEY_ALIAS`
- **Valeur**: L'alias de votre clé
- **Exemple**: `hanseco`

#### 5. `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

**Comment obtenir:**

1. Allez sur Google Play Console: https://play.google.com/console
2. Setup → API access
3. Créez un nouveau service account:
   - Cliquez sur "Create new service account"
   - Suivez le lien vers Google Cloud Console
   - Create Service Account
   - Nom: `github-actions-hanseco`
   - Rôle: Aucun (pour l'instant)
   - Create and Continue → Done

4. Téléchargez la clé JSON:
   - Dans Google Cloud Console
   - IAM & Admin → Service Accounts
   - Cliquez sur le service account créé
   - Keys → Add Key → Create new key
   - Type: JSON → Create
   - Le fichier JSON sera téléchargé

5. Accordez les permissions dans Play Console:
   - Retournez sur Play Console → Setup → API access
   - Cliquez sur le service account
   - Grant access
   - Account permissions:
     - ✅ Admin (View app information and download bulk reports)
     - ✅ Release apps to testing tracks
   - Save changes

6. Copiez le contenu du fichier JSON dans le secret GitHub

---

## 🍎 Configuration iOS

### Prérequis iOS

- Compte Apple Developer actif ($99/an)
- Certificat de distribution créé
- App créée sur App Store Connect

### Secrets iOS requis

#### 1. `IOS_CERTIFICATES_P12`

**Comment obtenir:**

```bash
# Exportez votre certificat depuis Keychain Access (Mac)
# 1. Ouvrez Keychain Access
# 2. My Certificates → Trouvez votre certificat "Apple Distribution"
# 3. Clic droit → Export "Apple Distribution..."
# 4. Format: Personal Information Exchange (.p12)
# 5. Choisissez un mot de passe

# Encodez en base64
base64 -i Certificates.p12 -o certificates.txt
```

Copiez le contenu de `certificates.txt`

#### 2. `IOS_CERTIFICATES_PASSWORD`
- **Valeur**: Le mot de passe du fichier P12
- **Exemple**: `MyCertPassword123`

#### 3. `APPSTORE_ISSUER_ID`

**Comment obtenir:**
1. App Store Connect: https://appstoreconnect.apple.com/
2. Users and Access → Keys (onglet)
3. Dans "Issuer ID", copiez l'ID (format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)

#### 4. `APPSTORE_KEY_ID`

**Comment obtenir:**
1. App Store Connect → Users and Access → Keys
2. Cliquez sur "+" pour créer une nouvelle clé
3. Name: `GitHub Actions`
4. Access: **App Manager**
5. Generate
6. Copiez le Key ID (format: `ABCD1234EF`)

#### 5. `APPSTORE_PRIVATE_KEY`

**Comment obtenir:**
1. Après avoir créé la clé ci-dessus, téléchargez le fichier `.p8`
2. **⚠️ IMPORTANT**: Vous ne pouvez télécharger qu'une seule fois!
3. Ouvrez le fichier `.p8` avec un éditeur de texte
4. Copiez tout le contenu (y compris `-----BEGIN PRIVATE KEY-----` et `-----END PRIVATE KEY-----`)

#### 6. Créer `ExportOptions.plist`

Créez le fichier `hanseco_app/ios/ExportOptions.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>signingStyle</key>
    <string>manual</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.hanseco.app</key>
        <string>YOUR_PROVISIONING_PROFILE_NAME</string>
    </dict>
</dict>
</plist>
```

**Remplacez:**
- `YOUR_TEAM_ID`: Votre Team ID Apple (10 caractères, ex: `ABC123XYZ4`)
- `YOUR_PROVISIONING_PROFILE_NAME`: Nom de votre profil de provisioning

**Comment trouver votre Team ID:**
1. https://developer.apple.com/account
2. Membership → Team ID

---

## 🚀 Utilisation des Workflows

### Déploiement automatique (via tags)

Le déploiement se déclenche automatiquement quand vous créez un tag de version:

```bash
# Créez un tag de version
git tag v1.0.0

# Poussez le tag
git push origin v1.0.0
```

Cela déclenchera:
- Build Android (APK + AAB)
- Build iOS (IPA)
- Upload sur GitHub Releases
- Déploiement sur Google Play Internal Testing
- Déploiement sur TestFlight

### Déploiement manuel

Vous pouvez aussi déclencher manuellement:

1. Allez sur GitHub → Actions
2. Sélectionnez "Deploy Android" ou "Deploy iOS"
3. Cliquez sur "Run workflow"
4. Choisissez la branche → Run workflow

### Tests automatiques

Les tests se déclenchent automatiquement sur chaque:
- Push sur `main` ou `develop`
- Pull Request vers `main` ou `develop`

---

## 📊 Monitoring des Workflows

### Voir les builds en cours

1. GitHub → Actions
2. Vous verrez tous les workflows en cours et terminés

### Télécharger les artifacts

1. GitHub → Actions
2. Cliquez sur un workflow terminé
3. Section "Artifacts" en bas
4. Téléchargez APK/AAB/IPA

### Voir les releases

1. GitHub → Releases
2. Chaque tag créera une release avec les fichiers APK/AAB/IPA

---

## 🔒 Sécurité

### Bonnes pratiques

✅ **À FAIRE:**
- Gardez vos secrets GitHub privés
- Ne committez JAMAIS les keystores, certificats ou clés API
- Utilisez des mots de passe forts pour keystores/certificats
- Sauvegardez vos keystores en lieu sûr (hors du repo)
- Renouvelez les clés API régulièrement

❌ **À NE PAS FAIRE:**
- Ne partagez jamais vos secrets GitHub
- N'exposez pas les keystores dans les logs
- Ne commitez pas les fichiers `.p12` ou `.jks`

### Fichiers à protéger

Assurez-vous que ces fichiers sont dans `.gitignore`:

```gitignore
# Android
android/key.properties
android/*.jks
android/*.keystore

# iOS
ios/*.p12
ios/*.mobileprovision
ios/ExportOptions.plist
ios/*.cer

# Secrets
.env
*.p8
```

---

## 🐛 Dépannage

### Android

**Erreur: "Keystore not found"**
- Vérifiez que `KEYSTORE_BASE64` est correctement encodé
- Assurez-vous qu'il n'y a pas de retours à la ligne dans le secret

**Erreur: "Google Play API error"**
- Vérifiez que le service account a les bonnes permissions
- Assurez-vous que l'app existe dans Play Console

### iOS

**Erreur: "Certificate not found"**
- Vérifiez que `IOS_CERTIFICATES_P12` est correctement encodé
- Assurez-vous que le certificat n'a pas expiré

**Erreur: "Provisioning profile doesn't match"**
- Vérifiez le Bundle ID dans `ExportOptions.plist`
- Assurez-vous que le provisioning profile est actif

### Général

**Erreur: "Flutter version mismatch"**
- Modifiez `flutter-version` dans les workflows
- Utilisez la version de Flutter de votre projet

**Erreur: "Secret not found"**
- Vérifiez l'orthographe exacte du nom du secret
- Les secrets sont sensibles à la casse

---

## 📈 Améliorer le Workflow

### Ajouter des tests E2E

Ajoutez dans `.github/workflows/test.yml`:

```yaml
- name: Run E2E tests
  working-directory: hanseco_app
  run: flutter drive --driver=test_driver/integration_driver.dart --target=test_driver/app.dart
```

### Notifications Slack/Discord

Ajoutez à la fin de vos workflows:

```yaml
- name: Notify success
  if: success()
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK_URL }}
    payload: |
      {
        "text": "✅ Build succeeded for ${{ github.ref }}"
      }
```

### Cache des dépendances

Ajoutez pour accélérer les builds:

```yaml
- name: Cache Flutter dependencies
  uses: actions/cache@v4
  with:
    path: /opt/hostedtoolcache/flutter
    key: ${{ runner.OS }}-flutter-install-cache
```

---

## 📚 Ressources

### Documentation officielle:
- **GitHub Actions**: https://docs.github.com/en/actions
- **Flutter CI/CD**: https://docs.flutter.dev/deployment/cd
- **Fastlane** (alternative): https://fastlane.tools/

### Actions GitHub utilisées:
- `actions/checkout@v4`
- `actions/setup-java@v4`
- `subosito/flutter-action@v2`
- `r0adkll/upload-google-play@v1`
- `apple-actions/import-codesign-certs@v2`
- `apple-actions/upload-testflight-build@v1`

---

## ✅ Checklist de Configuration

### Android
- [ ] Keystore créé et sauvegardé
- [ ] `KEYSTORE_BASE64` ajouté aux secrets GitHub
- [ ] `KEYSTORE_PASSWORD` ajouté aux secrets GitHub
- [ ] `KEY_PASSWORD` ajouté aux secrets GitHub
- [ ] `KEY_ALIAS` ajouté aux secrets GitHub
- [ ] Service account créé sur Google Cloud
- [ ] Service account lié à Play Console
- [ ] `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` ajouté aux secrets GitHub
- [ ] App créée dans Play Console
- [ ] Premier build uploadé manuellement dans Play Console

### iOS
- [ ] Compte Apple Developer actif
- [ ] Certificat de distribution créé
- [ ] `IOS_CERTIFICATES_P12` ajouté aux secrets GitHub
- [ ] `IOS_CERTIFICATES_PASSWORD` ajouté aux secrets GitHub
- [ ] Clé API App Store Connect créée
- [ ] `APPSTORE_ISSUER_ID` ajouté aux secrets GitHub
- [ ] `APPSTORE_KEY_ID` ajouté aux secrets GitHub
- [ ] `APPSTORE_PRIVATE_KEY` ajouté aux secrets GitHub
- [ ] `ExportOptions.plist` créé avec les bonnes valeurs
- [ ] App créée dans App Store Connect
- [ ] Premier build uploadé manuellement dans App Store Connect

### Commun
- [ ] `API_BASE_URL` ajouté aux secrets GitHub
- [ ] `GOOGLE_CLIENT_ID` ajouté aux secrets GitHub
- [ ] Fichiers sensibles dans `.gitignore`
- [ ] Test workflow déclenché avec succès
- [ ] Premier tag de version créé

---

Une fois tout configuré, le déploiement sera entièrement automatique! 🎉

```bash
# Pour déployer une nouvelle version:
git tag v1.0.1
git push origin v1.0.1

# GitHub Actions va automatiquement:
# 1. Builder Android (APK + AAB)
# 2. Builder iOS (IPA)
# 3. Créer une GitHub Release
# 4. Déployer sur Google Play Internal Testing
# 5. Déployer sur TestFlight
```
