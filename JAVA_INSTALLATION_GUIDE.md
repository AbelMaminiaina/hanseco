# Java JDK 17 Installation Guide for Windows

## Quick Installation Steps

### Option 1: Manual Download & Install (Recommended)

#### Step 1: Download JDK 17

Download Eclipse Temurin JDK 17 (OpenJDK):
- **Direct Download Link**: https://adoptium.net/temurin/releases/?version=17
- Select: **Windows x64**
- Package type: **JDK**
- Choose: **.msi installer** (easiest)

Or use these direct links:
- MSI Installer: https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.13%2B11/OpenJDK17U-jdk_x64_windows_hotspot_17.0.13_11.msi
- ZIP Archive: https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.13%2B11/OpenJDK17U-jdk_x64_windows_hotspot_17.0.13_11.zip

#### Step 2: Install JDK

1. Run the downloaded `.msi` installer
2. Click "Next" through the installation wizard
3. **IMPORTANT**: Note the installation path (default: `C:\Program Files\Eclipse Adoptium\jdk-17.x.x.x-hotspot\`)
4. Complete the installation

#### Step 3: Set Environment Variables

**Method A - Using Windows Settings (Recommended):**

1. Press `Windows + R`, type `sysdm.cpl`, press Enter
2. Go to "Advanced" tab
3. Click "Environment Variables"
4. Under "System variables", click "New"
5. Variable name: `JAVA_HOME`
6. Variable value: `C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot` (adjust version if different)
7. Click OK

8. Find "Path" in System variables, click "Edit"
9. Click "New"
10. Add: `%JAVA_HOME%\bin`
11. Click OK on all windows

**Method B - Using Command Prompt (Admin):**

Open Command Prompt as Administrator and run:
```cmd
setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot" /M
setx PATH "%PATH%;%JAVA_HOME%\bin" /M
```

#### Step 4: Verify Installation

**Close your current terminal and open a NEW terminal**, then run:
```bash
java -version
```

Expected output:
```
openjdk version "17.0.13" 2024-10-15
OpenJDK Runtime Environment Temurin-17.0.13+11 (build 17.0.13+11)
OpenJDK 64-Bit Server VM Temurin-17.0.13+11 (build 17.0.13+11, mixed mode, sharing)
```

Also verify JAVA_HOME:
```bash
echo %JAVA_HOME%
```

Should output something like:
```
C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot
```

#### Step 5: Configure Flutter

```bash
# Navigate to your project
cd C:\Users\amami\GitHub\HansEco\hanseco_app

# Configure Flutter to use JDK 17
flutter config --jdk-dir="C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot"

# Verify Flutter configuration
flutter doctor -v
```

---

### Option 2: Chocolatey (Administrator Required)

If you have administrator access, open **PowerShell as Administrator** and run:

```powershell
choco install temurin17 -y
```

Then configure Flutter:
```bash
flutter config --jdk-dir="C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot"
```

---

### Option 3: Manual Installation from ZIP

If you don't have admin rights:

1. Download ZIP from: https://adoptium.net/temurin/releases/?version=17
2. Extract to a location you have write access (e.g., `C:\Users\amami\Java\jdk-17`)
3. Set JAVA_HOME to that location (User variables, not System)
4. Add `%JAVA_HOME%\bin` to your User PATH

---

## After Installation - Build Your App

Once Java is installed and verified:

```bash
# Navigate to your Flutter project
cd C:\Users\amami\GitHub\HansEco\hanseco_app

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build debug APK
flutter build apk --debug
```

---

## Troubleshooting

### "java -version" not working after installation

**Solution**:
1. Close ALL terminal windows
2. Open a NEW terminal
3. Try `java -version` again

Environment variables only load when you start a new terminal session.

### JAVA_HOME not found

**Solution**:
```bash
# Check if JAVA_HOME is set
echo %JAVA_HOME%

# If empty, set it manually (replace with your actual path)
setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot"

# Close terminal and open a new one
```

### Wrong Java version showing

**Solution**: You may have multiple Java versions installed.
```bash
# Check which java is being used
where java

# Update PATH to prioritize JDK 17
# Move %JAVA_HOME%\bin to the top of your PATH variable
```

### Flutter still can't find Java

**Solution**:
```bash
# Set JDK path explicitly in Flutter
flutter config --jdk-dir="C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot"

# Verify
flutter doctor -v
```

---

## Quick Reference

**Download JDK 17**:
- https://adoptium.net/temurin/releases/?version=17

**Default Installation Path**:
```
C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot
```

**Environment Variables**:
- `JAVA_HOME`: `C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot`
- `PATH`: Add `%JAVA_HOME%\bin`

**Verify Commands**:
```bash
java -version
echo %JAVA_HOME%
flutter doctor -v
```

---

## Next Steps After Java Installation

1. ✅ Install Java JDK 17
2. ✅ Verify installation with `java -version`
3. ✅ Configure Flutter with `flutter config --jdk-dir`
4. 📝 Follow [Firebase Setup Guide](./FIREBASE_SETUP_GUIDE.md)
5. 🔨 Build Android APK
6. 📱 Deploy to device

---

**Need help?** Come back here after installation and I'll help you verify everything is working correctly!
