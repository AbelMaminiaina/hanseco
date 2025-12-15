#!/bin/bash

echo "========================================"
echo "Java JDK 17 Installation Verification"
echo "========================================"
echo ""

echo "[1/4] Checking Java installation..."
if ! command -v java &> /dev/null; then
    echo "❌ ERROR: Java not found in PATH"
    echo "Please ensure Java is installed and added to PATH"
    exit 1
fi
java -version
echo ""

echo "[2/4] Checking JAVA_HOME..."
if [ -z "$JAVA_HOME" ]; then
    echo "❌ ERROR: JAVA_HOME is not set"
    echo "Please set JAVA_HOME environment variable"
    exit 1
else
    echo "✅ JAVA_HOME=$JAVA_HOME"
fi
echo ""

echo "[3/4] Verifying JAVA_HOME directory exists..."
if [ -f "$JAVA_HOME/bin/java" ] || [ -f "$JAVA_HOME/bin/java.exe" ]; then
    echo "✅ SUCCESS: JAVA_HOME is correctly set"
else
    echo "❌ ERROR: JAVA_HOME points to invalid directory"
    echo "Please verify the path: $JAVA_HOME"
    exit 1
fi
echo ""

echo "[4/4] Configuring Flutter to use JDK 17..."
cd "$(dirname "$0")/hanseco_app"
flutter config --jdk-dir="$JAVA_HOME"
echo ""

echo "========================================"
echo "Running Flutter Doctor..."
echo "========================================"
flutter doctor -v
echo ""

echo "========================================"
echo "✅ Verification Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Follow FIREBASE_SETUP_GUIDE.md to configure Google Sign-In"
echo "2. Run: cd hanseco_app"
echo "3. Run: flutter build apk --debug"
echo ""
