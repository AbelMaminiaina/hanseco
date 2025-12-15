# Android Deployment Guide for HansEco

This guide will help you deploy your HansEco Flutter app to Android devices.

## Prerequisites Checklist

### 1. Install Java JDK 17

Android builds require Java Development Kit (JDK) 17.

#### Download and Install:
- **Option 1 - OpenJDK (Recommended)**: https://adoptium.net/temurin/releases/?version=17
- **Option 2 - Oracle JDK**: https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html

#### Configure Environment Variables:
After installation, set up environment variables:

**Windows:**
1. Open System Properties > Advanced > Environment Variables
2. Add new system variable:
   - Name: `JAVA_HOME`
   - Value: `C:\Program Files\Java\jdk-17` (adjust path to your installation)
3. Edit PATH variable and add: `%JAVA_HOME%\bin`

**Verify Installation:**
```bash
java -version
# Should show: java version "17.x.x"
```

#### Configure Flutter to Use JDK:
```bash
flutter config --jdk-dir="C:\Program Files\Java\jdk-17"
```

### 2. Android SDK Setup

The Android SDK should already be installed at: `C:\Users\amami\AppData\Local\Android\sdk`

Ensure you have the required SDK components:
```bash
# Check SDK location
flutter doctor -v
```

Required SDK components:
- Android SDK Platform 35
- Android SDK Build-Tools 35.0.0
- Android SDK Command-line Tools

## App Configuration

### Current Configuration:
- **Package Name**: `com.hanseco.app`
- **App Name**: HansEco
- **Min SDK**: 24 (Android 7.0)
- **Target SDK**: 35 (Android 15)
- **Version**: 1.0.0 (Build 1)

### Google Sign-In Configuration

#### Step 1: Get SHA-1 Certificate Fingerprint

For **Debug builds**:
```bash
cd hanseco_app/android
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

For **Release builds** (after creating signing key):
```bash
keytool -list -v -keystore hanseco-upload-key.jks -alias hanseco
```

Copy the **SHA-1** fingerprint (looks like: `A1:B2:C3:D4:E5:...`)

#### Step 2: Configure Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your HansEco project
3. Go to Project Settings > General
4. Scroll to "Your apps" section
5. Click "Add app" > Android icon
6. Enter package name: `com.hanseco.app`
7. Add SHA-1 fingerprint from Step 1
8. Download `google-services.json`
9. Place it in: `hanseco_app/android/app/google-services.json`

#### Step 3: Add Google Services Plugin

Add to `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

Add to `android/app/build.gradle` (at the bottom):
```gradle
apply plugin: 'com.google.gms.google-services'
```

#### Step 4: Get OAuth Client ID for Android

In Firebase Console:
1. Go to Authentication > Sign-in method > Google
2. Expand the "Web SDK configuration"
3. You'll see your Web Client ID
4. Also add Android OAuth client in Google Cloud Console:
   - Go to APIs & Credentials > Credentials
   - Create OAuth 2.0 Client ID for Android
   - Package name: `com.hanseco.app`
   - SHA-1: (from Step 1)

## Creating Release Signing Key

For production releases, you need a signing key:

```bash
cd hanseco_app/android/app

# Create keystore
keytool -genkey -v -keystore hanseco-upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias hanseco

# Answer the prompts:
# - Enter keystore password (remember this!)
# - Re-enter password
# - Enter your details (name, organization, etc.)
# - Enter key password (can be same as keystore password)
```

**IMPORTANT**: Backup this file and passwords securely! If lost, you cannot update your app on Play Store.

### Configure Signing in Gradle

Create `android/key.properties`:
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=hanseco
storeFile=hanseco-upload-key.jks
```

**Add to `.gitignore`**:
```
android/key.properties
android/app/*.jks
```

Update `android/app/build.gradle`:
```gradle
// Add before android block
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...

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
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

## Building the App

### Debug Build (for testing):
```bash
cd hanseco_app

# Build debug APK
flutter build apk --debug

# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### Release Build (for production):
```bash
cd hanseco_app

# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk

# Or build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### Install on Device:
```bash
# Connect device via USB and enable USB debugging

# Install APK
flutter install

# Or install specific APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Testing the Build

Before release, test these features:
- [ ] App launches successfully
- [ ] Google Sign-In works
- [ ] Can connect to backend API
- [ ] Products load correctly
- [ ] Images display properly
- [ ] All navigation works
- [ ] Payment integration (Mvola, Orange Money, Airtel Money)

## Environment Configuration

Make sure your `.env` file is properly configured for production:

```env
# Backend API URL (use your production URL)
API_BASE_URL=https://your-production-api.com/api
GOOGLE_OAUTH_CLIENT_ID=your-web-client-id.apps.googleusercontent.com

# Payment Gateway URLs
MVOLA_API_URL=https://api.mvola.mg
ORANGE_MONEY_API_URL=https://api.orange.mg
AIRTEL_MONEY_API_URL=https://api.airtel.mg
```

## Play Store Submission

### Prepare Assets:
1. **App Icon**: 512x512 PNG
2. **Feature Graphic**: 1024x500 PNG
3. **Screenshots**: At least 2, max 8 (phone and tablet)
4. **Privacy Policy**: Required URL

### Create Play Console Account:
1. Go to [Google Play Console](https://play.google.com/console)
2. Pay one-time $25 registration fee
3. Complete account verification

### Upload App:
1. Create new app in Play Console
2. Fill in app details
3. Upload AAB file (app-release.aab)
4. Complete content rating questionnaire
5. Set pricing and distribution
6. Submit for review

## Troubleshooting

### Build Fails with "JAVA_HOME not set":
- Install JDK 17 and configure environment variables
- Run: `flutter config --jdk-dir="path/to/jdk"`

### Google Sign-In Not Working:
- Verify SHA-1 fingerprint in Firebase Console
- Check package name matches: `com.hanseco.app`
- Ensure google-services.json is in android/app/

### APK Too Large:
- Use App Bundle instead: `flutter build appbundle`
- Enable code shrinking in release build
- Optimize images and assets

### Network Requests Failing:
- Check `android:usesCleartextTraffic="true"` in AndroidManifest.xml
- For production, use HTTPS and remove cleartext traffic

## Next Steps

1. Install Java JDK 17
2. Configure environment variables
3. Set up Firebase for Android
4. Create signing key for release builds
5. Build and test debug APK
6. Build release APK/AAB
7. Submit to Play Store

## Useful Commands Reference

```bash
# Check Flutter setup
flutter doctor -v

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Analyze code
flutter analyze

# Run tests
flutter test

# Check package name
grep applicationId android/app/build.gradle
```

---

**Need Help?** Check the deployment guide in the repository or contact the development team.
