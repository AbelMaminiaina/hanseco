# Firebase & Google Sign-In Setup Guide for HansEco Android

This guide walks you through setting up Firebase and Google Sign-In for your HansEco Android app.

## Prerequisites

- [ ] Java JDK 17 installed
- [ ] Android platform added to Flutter project
- [ ] Google account for Firebase Console

## Step 1: Get SHA-1 Certificate Fingerprints

You need SHA-1 fingerprints for both debug and release builds.

### For Debug Build (Development):

```bash
# Windows (Git Bash or WSL)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Windows (Command Prompt)
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Look for the **SHA1** line, example:
```
SHA1: A1:B2:C3:D4:E5:F6:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB
```

**Copy this SHA-1 fingerprint** - you'll need it for Firebase.

### For Release Build (Production):

First, create your release signing key if you haven't already:

```bash
cd hanseco_app/android/app

keytool -genkey -v -keystore hanseco-upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias hanseco
```

Answer the prompts:
- Keystore password: (create a strong password)
- Re-enter password
- First and last name: Your Name or Company Name
- Organizational unit: Development
- Organization: HansEco
- City/Locality: Your City
- State/Province: Your State
- Country code: MG (for Madagascar)
- Confirm: yes
- Key password: (can be same as keystore password)

**IMPORTANT**: Save these passwords securely! If lost, you cannot update your app on Play Store.

Then get the SHA-1:

```bash
keytool -list -v -keystore hanseco-upload-key.jks -alias hanseco
```

**Copy this SHA-1 fingerprint too.**

### Configure Signing:

Create `hanseco_app/android/key.properties`:
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=hanseco
storeFile=hanseco-upload-key.jks
```

## Step 2: Firebase Console Setup

### Create/Configure Firebase Project:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select existing project
3. Project name: `HansEco` (or your preferred name)
4. Enable Google Analytics (recommended)
5. Click "Create project"

### Add Android App:

1. In Firebase Console, click the Android icon to add Android app
2. **Android package name**: `com.hanseco.app`
3. **App nickname**: HansEco (optional)
4. Click "Register app"

### Add SHA-1 Fingerprints:

1. In Firebase Console > Project Settings > General
2. Scroll to "Your apps" section
3. Click on your Android app
4. Under "SHA certificate fingerprints", click "Add fingerprint"
5. Add your **debug SHA-1** fingerprint
6. Click "Add fingerprint" again
7. Add your **release SHA-1** fingerprint
8. Click "Save"

### Download google-services.json:

1. In the same page, click "Download google-services.json"
2. Save the file
3. Move it to: `hanseco_app/android/app/google-services.json`

```bash
# From your downloads folder
mv ~/Downloads/google-services.json hanseco_app/android/app/
```

## Step 3: Enable Google Sign-In in Firebase

1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Click on **Google** provider
3. Toggle "Enable"
4. **Project support email**: your email
5. Click "Save"

## Step 4: Configure OAuth Consent Screen

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** > **OAuth consent screen**
4. Choose **External** user type
5. Fill in required fields:
   - App name: HansEco
   - User support email: your email
   - Developer contact: your email
6. Click "Save and Continue"
7. Skip "Scopes" (click "Save and Continue")
8. Add test users if needed
9. Click "Save and Continue"

## Step 5: Create Android OAuth Client

1. In Google Cloud Console, go to **APIs & Services** > **Credentials**
2. Click "Create Credentials" > "OAuth client ID"
3. Application type: **Android**
4. Name: `HansEco Android`
5. **Package name**: `com.hanseco.app`
6. **SHA-1 certificate fingerprint**: Paste your debug SHA-1
7. Click "Create"
8. Repeat for release SHA-1 (create another OAuth client)

## Step 6: Get Web Client ID

You need the Web Client ID for Google Sign-In to work on Android.

1. In Google Cloud Console > Credentials
2. Find the "Web client (auto created by Google Service)" OAuth 2.0 Client ID
3. Click on it to view details
4. **Copy the Client ID** (format: `XXXXX.apps.googleusercontent.com`)

## Step 7: Update Flutter .env File

Update `hanseco_app/.env`:

```env
# OAuth Configuration
GOOGLE_OAUTH_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

Replace `YOUR_WEB_CLIENT_ID` with the Web Client ID from Step 6.

## Step 8: Enable Google Services Plugin

Uncomment the plugin in `hanseco_app/android/app/build.gradle`:

Find this line at the bottom:
```gradle
// apply plugin: 'com.google.gms.google-services'
```

Change it to:
```gradle
apply plugin: 'com.google.gms.google-services'
```

## Step 9: Verify Configuration

### Check Files:
```bash
# Verify google-services.json exists
ls hanseco_app/android/app/google-services.json

# Verify signing key exists (for release)
ls hanseco_app/android/app/hanseco-upload-key.jks

# Verify key.properties exists
ls hanseco_app/android/key.properties
```

### Check Package Name Matches:
```bash
# Should show: com.hanseco.app
grep applicationId hanseco_app/android/app/build.gradle
```

## Step 10: Test the Build

### Clean and Build:
```bash
cd hanseco_app

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build debug APK
flutter build apk --debug
```

### Install and Test:
```bash
# Connect Android device via USB with USB debugging enabled

# Install the app
flutter install

# Or run directly
flutter run
```

### Test Google Sign-In:
1. Launch the app
2. Navigate to Login page
3. Tap "Sign in with Google"
4. Select Google account
5. Verify successful login

## Troubleshooting

### "SHA-1 not valid" or Sign-In Fails:

**Solution**: Verify SHA-1 fingerprints match:
```bash
# Check debug keystore
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1

# Check release keystore
keytool -list -v -keystore hanseco_app/android/app/hanseco-upload-key.jks -alias hanseco | grep SHA1
```

Make sure these SHA-1 values are added to Firebase Console.

### "Package name mismatch":

**Solution**: Ensure package name is `com.hanseco.app` everywhere:
- Firebase Console app configuration
- `android/app/build.gradle` (applicationId)
- `android/app/src/main/AndroidManifest.xml` (namespace)
- Google Cloud OAuth clients

### "google-services.json not found":

**Solution**:
```bash
# Check file exists
ls hanseco_app/android/app/google-services.json

# If not, download again from Firebase Console
```

### Build fails with "google-services plugin not found":

**Solution**: Make sure `android/build.gradle` has:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### Sign-In works in debug but not release:

**Solution**: Add release SHA-1 to Firebase:
```bash
# Get release SHA-1
keytool -list -v -keystore hanseco_app/android/app/hanseco-upload-key.jks -alias hanseco

# Add this SHA-1 to Firebase Console
```

## Security Checklist

- [ ] `google-services.json` is in `.gitignore`
- [ ] `key.properties` is in `.gitignore`
- [ ] `*.jks` files are in `.gitignore`
- [ ] Release keystore is backed up securely offline
- [ ] Keystore passwords are stored securely (password manager)
- [ ] Never commit signing keys to git

## Production Checklist

Before releasing to Play Store:

- [ ] Release keystore created
- [ ] Release SHA-1 added to Firebase
- [ ] OAuth consent screen configured
- [ ] Privacy policy URL set
- [ ] Google Sign-In tested on release build
- [ ] All credentials secured and backed up

## Quick Reference

### Important Files:
```
hanseco_app/
├── .env                                    # OAuth Client IDs
├── android/
│   ├── app/
│   │   ├── google-services.json           # Firebase config
│   │   ├── hanseco-upload-key.jks         # Release signing key
│   │   └── build.gradle                   # App config
│   ├── key.properties                     # Signing credentials
│   └── build.gradle                       # Google services plugin
```

### Key Package Name:
```
com.hanseco.app
```

### Key Commands:
```bash
# Get debug SHA-1
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Get release SHA-1
keytool -list -v -keystore hanseco-upload-key.jks -alias hanseco

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

---

**Need Help?** Check the main [Android Deployment Guide](./ANDROID_DEPLOYMENT_GUIDE.md) or contact the development team.
