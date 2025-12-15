# Guide de Déploiement - HansEco

Guide complet pour déployer l'application HansEco sur Android et iOS/Apple.

---

## 📱 DÉPLOIEMENT ANDROID

### 1. Configuration Android

#### Étape 1: Installer Android Studio
- Téléchargez Android Studio: https://developer.android.com/studio
- Installez les composants:
  - Android SDK
  - Android SDK Platform-Tools
  - Android SDK Build-Tools

#### Étape 2: Accepter les licences Android
```bash
flutter doctor --android-licenses
```
Acceptez toutes les licences en tapant `y`.

#### Étape 3: Configurer le signing (signature de l'app)

**Créer un keystore:**
```bash
cd hanseco_app/android
keytool -genkey -v -keystore hanseco-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias hanseco
```

**Informations à fournir:**
- Mot de passe du keystore: `[votre-mot-de-passe-sécurisé]`
- Nom et prénom: `HansEco Team`
- Unité organisationnelle: `Development`
- Organisation: `HansEco`
- Ville: `Antananarivo`
- État/Province: `Analamanga`
- Code pays: `MG`

**⚠️ IMPORTANT:** Sauvegardez le fichier `hanseco-release-key.jks` et le mot de passe en lieu sûr!

#### Étape 4: Créer le fichier de configuration de signature

Créez `hanseco_app/android/key.properties`:
```properties
storePassword=VOTRE_MOT_DE_PASSE_KEYSTORE
keyPassword=VOTRE_MOT_DE_PASSE_CLE
keyAlias=hanseco
storeFile=hanseco-release-key.jks
```

**Ajoutez `key.properties` au `.gitignore`:**
```bash
echo "android/key.properties" >> .gitignore
echo "android/*.jks" >> .gitignore
```

#### Étape 5: Configurer `android/app/build.gradle`

Ouvrez `hanseco_app/android/app/build.gradle` et ajoutez AVANT `android {`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
```

Dans la section `buildTypes`, remplacez:
```gradle
buildTypes {
    release {
        // TODO: Add your own signing config for the release build.
        signingConfig signingConfigs.debug
    }
}
```

Par:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true
        shrinkResources true
    }
}
```

#### Étape 6: Configurer les métadonnées de l'app

Modifiez `hanseco_app/android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.hanseco.app">

    <application
        android:label="HansEco"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <!-- Permissions nécessaires -->
        <uses-permission android:name="android.permission.INTERNET"/>
        <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

        <!-- Google OAuth -->
        <meta-data
            android:name="com.google.android.gms.version"
            android:value="@integer/google_play_services_version" />
    </application>
</manifest>
```

Modifiez `hanseco_app/android/app/build.gradle`:
```gradle
android {
    namespace "com.hanseco.app"
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.hanseco.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

### 2. Build Android

#### Build pour tester (Debug APK):
```bash
cd hanseco_app
flutter build apk --debug
```

L'APK sera dans: `build/app/outputs/flutter-apk/app-debug.apk`

#### Build pour production (Release APK):
```bash
flutter build apk --release
```

L'APK sera dans: `build/app/outputs/flutter-apk/app-release.apk`

#### Build App Bundle pour Google Play Store:
```bash
flutter build appbundle --release
```

L'AAB sera dans: `build/app/outputs/bundle/release/app-release.aab`

### 3. Tester sur un appareil Android

#### Option 1: Appareil physique
1. Activez le **Mode développeur** sur votre téléphone:
   - Allez dans Paramètres → À propos du téléphone
   - Tapez 7 fois sur "Numéro de build"
2. Activez le **Débogage USB**:
   - Paramètres → Options développeur → Débogage USB
3. Connectez le téléphone à votre PC via USB
4. Autorisez le débogage USB sur le téléphone
5. Vérifiez que Flutter détecte l'appareil:
   ```bash
   flutter devices
   ```
6. Lancez l'app:
   ```bash
   flutter run
   ```

#### Option 2: Émulateur Android
1. Ouvrez Android Studio
2. AVD Manager → Create Virtual Device
3. Choisissez un appareil (ex: Pixel 6)
4. Téléchargez une image système (ex: Android 13)
5. Créez et lancez l'émulateur
6. Lancez l'app:
   ```bash
   flutter run
   ```

### 4. Publier sur Google Play Store

#### Étape 1: Créer un compte développeur Google Play
- Allez sur https://play.google.com/console
- Créez un compte (frais unique de $25)

#### Étape 2: Créer une nouvelle application
1. Console Play → Créer une application
2. Remplissez les informations:
   - Nom: **HansEco**
   - Langue par défaut: **Français**
   - Type: **Application**
   - Gratuite ou payante: **Gratuite**

#### Étape 3: Configurer la fiche du Store
Remplissez obligatoirement:
- **Description courte** (80 caractères max)
- **Description complète** (4000 caractères max)
- **Icône de l'application** (512x512 px)
- **Captures d'écran** (au moins 2, format 16:9)
- **Bannière de l'application** (1024x500 px)
- **Catégorie**: Shopping
- **Adresse e-mail de contact**
- **Politique de confidentialité** (URL)

#### Étape 4: Configurer la tarification
- Gratuite
- Pays de distribution: Sélectionnez Madagascar + autres pays

#### Étape 5: Upload l'App Bundle
1. Production → Créer une nouvelle version
2. Uploadez `app-release.aab`
3. Remplissez les notes de version
4. Envoyez en révision

#### Étape 6: Attendre l'approbation
- Délai: 1-7 jours
- Vous recevrez un email quand l'app sera approuvée

---

## 🍎 DÉPLOIEMENT iOS/APPLE

### 1. Prérequis iOS

⚠️ **IMPORTANT:** Vous avez besoin d'un **Mac** pour compiler une app iOS!

#### Ce dont vous avez besoin:
- **Mac** (MacBook, iMac, Mac Mini)
- **Xcode** (gratuit sur l'App Store)
- **Compte Apple Developer** ($99/an)
- **iPhone/iPad** pour tester (ou simulateur Xcode)

### 2. Configuration iOS

#### Étape 1: Installer Xcode
1. Ouvrez l'App Store sur votre Mac
2. Recherchez "Xcode"
3. Installez Xcode (gratuit, ~15 GB)
4. Lancez Xcode et acceptez les termes
5. Installez les outils en ligne de commande:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

#### Étape 2: S'inscrire au Apple Developer Program
1. Allez sur https://developer.apple.com/programs/
2. Inscrivez-vous ($99/an)
3. Attendez l'approbation (24-48h)

#### Étape 3: Configurer le projet iOS

Ouvrez le projet dans Xcode:
```bash
cd hanseco_app
open ios/Runner.xcworkspace
```

Dans Xcode:
1. Sélectionnez **Runner** dans la barre latérale
2. Dans l'onglet **General**:
   - **Display Name**: `HansEco`
   - **Bundle Identifier**: `com.hanseco.app`
   - **Version**: `1.0.0`
   - **Build**: `1`

3. Dans **Signing & Capabilities**:
   - **Team**: Sélectionnez votre équipe Apple Developer
   - **Bundle Identifier**: `com.hanseco.app`
   - Cochez **Automatically manage signing**

#### Étape 4: Configurer les permissions iOS

Modifiez `hanseco_app/ios/Runner/Info.plist`:

```xml
<dict>
    <!-- Nom de l'app -->
    <key>CFBundleName</key>
    <string>HansEco</string>

    <key>CFBundleDisplayName</key>
    <string>HansEco</string>

    <!-- Permissions -->
    <key>NSCameraUsageDescription</key>
    <string>HansEco a besoin d'accéder à votre caméra pour prendre des photos de produits.</string>

    <key>NSPhotoLibraryUsageDescription</key>
    <string>HansEco a besoin d'accéder à vos photos pour sélectionner des images.</string>

    <key>NSLocationWhenInUseUsageDescription</key>
    <string>HansEco a besoin de votre position pour trouver les magasins près de vous.</string>

    <!-- Google OAuth -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID</string>
            </array>
        </dict>
    </array>
</dict>
```

**Remplacez `YOUR_REVERSED_CLIENT_ID`** par votre Client ID inversé (exemple: si votre Client ID est `123-abc.apps.googleusercontent.com`, utilisez `com.googleusercontent.apps.123-abc`)

### 3. Build iOS

#### Build pour tester (Debug):
```bash
cd hanseco_app
flutter build ios --debug
```

#### Build pour production (Release):
```bash
flutter build ios --release
```

#### Créer une archive pour l'App Store:
```bash
flutter build ipa
```

L'IPA sera dans: `build/ios/ipa/hanseco_app.ipa`

### 4. Tester sur un iPhone/iPad

#### Option 1: Appareil physique
1. Connectez votre iPhone/iPad à votre Mac via USB
2. Déverrouillez l'appareil et faites confiance au Mac
3. Dans Xcode, sélectionnez votre appareil dans la barre d'outils
4. Lancez l'app:
   ```bash
   flutter run
   ```

#### Option 2: Simulateur iOS
1. Ouvrez Xcode
2. Window → Devices and Simulators
3. Simulators → Créez un nouveau simulateur (ex: iPhone 14)
4. Lancez le simulateur
5. Lancez l'app:
   ```bash
   flutter run
   ```

### 5. Publier sur l'App Store

#### Étape 1: Créer l'app sur App Store Connect
1. Allez sur https://appstoreconnect.apple.com/
2. My Apps → ＋ → New App
3. Remplissez:
   - **Name**: HansEco
   - **Primary Language**: French
   - **Bundle ID**: com.hanseco.app
   - **SKU**: com.hanseco.app
   - **User Access**: Full Access

#### Étape 2: Configurer la fiche de l'App Store
1. **App Information**:
   - Nom: HansEco
   - Catégorie: Shopping
   - Sous-catégorie: E-commerce

2. **Pricing and Availability**:
   - Prix: Gratuit
   - Disponibilité: Madagascar + autres pays

3. **App Privacy**:
   - Remplissez le questionnaire sur les données collectées
   - Créez une politique de confidentialité

4. **Préparation pour soumission**:
   - **Captures d'écran** (obligatoire):
     - iPhone 6.5": 1242 x 2688 px (au moins 3)
     - iPhone 5.5": 1242 x 2208 px (au moins 3)
     - iPad Pro 12.9": 2048 x 2732 px (optionnel)

   - **Icône de l'app**: 1024 x 1024 px (format PNG, pas de transparence)

   - **Description**:
     - Description courte
     - Description complète
     - Mots-clés (100 caractères max)
     - URL de support
     - URL marketing (optionnel)

#### Étape 3: Uploader le build avec Xcode

**Option A: Via Xcode (recommandé)**
1. Ouvrez le projet: `open ios/Runner.xcworkspace`
2. Product → Archive
3. Attendez la fin de l'archivage
4. Window → Organizer
5. Sélectionnez votre archive → **Distribute App**
6. Choisissez **App Store Connect**
7. **Upload** → Next → Upload
8. Attendez la fin de l'upload

**Option B: Via Flutter + Transporter**
1. Créez l'IPA:
   ```bash
   flutter build ipa
   ```
2. Téléchargez **Transporter** (App Store)
3. Ouvrez Transporter
4. Glissez-déposez `build/ios/ipa/hanseco_app.ipa`
5. Cliquez sur **Deliver**

#### Étape 4: Soumettre pour révision
1. Retournez sur App Store Connect
2. My Apps → HansEco → App Store
3. Cliquez sur **+ Version** ou **Prepare for Submission**
4. Sélectionnez le build uploadé
5. Remplissez toutes les informations manquantes
6. **Submit for Review**

#### Étape 5: Attendre l'approbation
- Délai: 1-7 jours (généralement 24-48h)
- Apple testera votre app
- Vous recevrez un email avec le statut

---

## 🔧 PROBLÈMES COURANTS

### Android

**Erreur: "Gradle build failed"**
- Solution: Nettoyez le projet:
  ```bash
  cd hanseco_app
  flutter clean
  flutter pub get
  cd android
  ./gradlew clean
  cd ..
  flutter build apk
  ```

**Erreur: "SDK license not accepted"**
- Solution:
  ```bash
  flutter doctor --android-licenses
  ```

**Erreur: "Keystore password was incorrect"**
- Vérifiez le fichier `key.properties`
- Assurez-vous que le mot de passe est correct

### iOS

**Erreur: "Provisioning profile doesn't include signing certificate"**
- Solution: Dans Xcode, Signing & Capabilities → Cochez "Automatically manage signing"

**Erreur: "The operation couldn't be completed"**
- Solution: Redémarrez Xcode et le Mac

**Erreur: "No valid iOS Distribution certificate"**
- Solution: Créez un certificat de distribution sur developer.apple.com

---

## 📦 CHECKLIST AVANT PUBLICATION

### Android
- [ ] Version et versionCode mis à jour dans `build.gradle`
- [ ] Icône de l'app créée (512x512 px)
- [ ] Keystore créé et sauvegardé en sécurité
- [ ] `key.properties` dans `.gitignore`
- [ ] Permissions Android configurées dans `AndroidManifest.xml`
- [ ] App testée sur un appareil physique
- [ ] Screenshots pris (au moins 2)
- [ ] Description et métadonnées rédigées
- [ ] Politique de confidentialité créée
- [ ] App Bundle (.aab) généré avec succès

### iOS
- [ ] Version et Build number mis à jour
- [ ] Bundle Identifier configuré
- [ ] Compte Apple Developer actif ($99/an)
- [ ] Certificat de distribution créé
- [ ] Provisioning profile configuré
- [ ] Icône de l'app créée (1024x1024 px)
- [ ] Permissions iOS configurées dans `Info.plist`
- [ ] App testée sur iPhone/iPad physique
- [ ] Screenshots pris pour toutes les tailles requises
- [ ] Description et métadonnées rédigées
- [ ] Politique de confidentialité créée
- [ ] IPA généré avec succès
- [ ] Build uploadé sur App Store Connect

---

## 🚀 COMMANDES RAPIDES

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK (pour tests)
flutter build apk --release

# App Bundle (pour Google Play)
flutter build appbundle --release

# Installer sur appareil connecté
flutter install
```

### iOS
```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release

# IPA pour App Store
flutter build ipa

# Lancer sur simulateur
flutter run -d "iPhone 14"
```

---

## 📞 SUPPORT

### Documentation officielle:
- **Flutter**: https://docs.flutter.dev/deployment
- **Android**: https://developer.android.com/distribute
- **iOS**: https://developer.apple.com/app-store/

### Problèmes spécifiques:
- Google Play Console: https://play.google.com/console
- App Store Connect: https://appstoreconnect.apple.com/
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter

---

Bonne chance pour le déploiement de HansEco! 🎉
