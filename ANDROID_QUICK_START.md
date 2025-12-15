# Android Deployment - Quick Start

This is a quick reference guide to get your HansEco app running on Android. For detailed instructions, see:
- [Android Deployment Guide](./ANDROID_DEPLOYMENT_GUIDE.md) - Complete deployment instructions
- [Firebase Setup Guide](./FIREBASE_SETUP_GUIDE.md) - Google Sign-In & Firebase configuration

## Current Status ✅

Your Android platform is configured with:
- ✅ Package name: `com.hanseco.app`
- ✅ App name: HansEco
- ✅ Min SDK: 24 (Android 7.0+)
- ✅ Target SDK: 35 (Android 15)
- ✅ Gradle 8.7 configured
- ✅ Signing configuration ready
- ✅ ProGuard rules configured
- ✅ Google Services plugin ready

## What You Need to Do ⚠️

### 1. Install Java JDK 17 (REQUIRED)

**Download**: https://adoptium.net/temurin/releases/?version=17

**Configure**:
```bash
# Set JAVA_HOME environment variable
# Windows: Add to System Environment Variables
JAVA_HOME=C:\Program Files\Java\jdk-17

# Add to PATH
%JAVA_HOME%\bin

# Configure Flutter
flutter config --jdk-dir="C:\Program Files\Java\jdk-17"

# Verify
java -version
```

### 2. Set Up Firebase & Google Sign-In

Follow the [Firebase Setup Guide](./FIREBASE_SETUP_GUIDE.md) to:
1. Get SHA-1 fingerprints
2. Configure Firebase Console
3. Download `google-services.json`
4. Enable Google Sign-In

Quick commands:
```bash
# Get debug SHA-1
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Look for the SHA1 line and add it to Firebase Console
```

### 3. Create Release Signing Key

```bash
cd hanseco_app/android/app

# Generate keystore
keytool -genkey -v -keystore hanseco-upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias hanseco

# Create key.properties file
cd ..
echo "storePassword=YOUR_PASSWORD" > key.properties
echo "keyPassword=YOUR_PASSWORD" >> key.properties
echo "keyAlias=hanseco" >> key.properties
echo "storeFile=hanseco-upload-key.jks" >> key.properties
```

**⚠️ IMPORTANT**: Backup `hanseco-upload-key.jks` and passwords securely!

### 4. Build the App

```bash
cd hanseco_app

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build debug APK (for testing)
flutter build apk --debug

# Build release APK (for distribution)
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### 5. Test on Device

```bash
# Connect Android device via USB
# Enable USB debugging on device

# Install the app
flutter install

# Or run directly
flutter run
```

## File Checklist

Before building, ensure these files are configured:

```
hanseco_app/
├── .env                                   ✅ Created (update GOOGLE_OAUTH_CLIENT_ID)
├── android/
│   ├── app/
│   │   ├── google-services.json          ⚠️ Download from Firebase
│   │   ├── hanseco-upload-key.jks        ⚠️ Create with keytool
│   │   ├── build.gradle                  ✅ Configured
│   │   └── proguard-rules.pro            ✅ Created
│   ├── key.properties                    ⚠️ Create with signing credentials
│   ├── key.properties.example            ✅ Reference template
│   └── build.gradle                      ✅ Configured
```

## Quick Commands Reference

```bash
# Check Flutter setup
flutter doctor -v

# Clean build cache
flutter clean

# Get dependencies
flutter pub get

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Install on device
flutter install

# Run on device
flutter run

# Get SHA-1 fingerprint (debug)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Get SHA-1 fingerprint (release)
keytool -list -v -keystore android/app/hanseco-upload-key.jks -alias hanseco
```

## Common Issues & Solutions

### Issue: "JAVA_HOME is not set"
**Solution**: Install JDK 17 and configure environment variables

### Issue: "google-services.json not found"
**Solution**: Download from Firebase Console and place in `android/app/`

### Issue: Google Sign-In not working
**Solution**:
1. Verify SHA-1 in Firebase Console
2. Check package name is `com.hanseco.app`
3. Enable Google Sign-In in Firebase Authentication

### Issue: Build fails with Gradle errors
**Solution**: Update Gradle to 8.7 (already configured)

## Security Reminders ⚠️

**NEVER commit these files to git:**
- `android/app/*.jks` - Signing keys
- `android/key.properties` - Signing credentials
- `android/app/google-services.json` - Firebase config
- `.env` - OAuth client IDs

These are already in `.gitignore` ✅

## Next Steps

1. **Install Java JDK 17** ← Do this first!
2. **Follow [Firebase Setup Guide](./FIREBASE_SETUP_GUIDE.md)**
3. **Create release signing key**
4. **Build and test the app**
5. **Deploy to Play Store** (see [Android Deployment Guide](./ANDROID_DEPLOYMENT_GUIDE.md))

## Need Help?

- Full guide: [ANDROID_DEPLOYMENT_GUIDE.md](./ANDROID_DEPLOYMENT_GUIDE.md)
- Firebase guide: [FIREBASE_SETUP_GUIDE.md](./FIREBASE_SETUP_GUIDE.md)
- Flutter docs: https://docs.flutter.dev/deployment/android

---

**Ready to build?** Start with installing Java JDK 17!
