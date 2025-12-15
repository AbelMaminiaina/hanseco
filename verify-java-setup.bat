@echo off
echo ========================================
echo Java JDK 17 Installation Verification
echo ========================================
echo.

echo [1/4] Checking Java installation...
java -version
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Java not found in PATH
    echo Please ensure Java is installed and added to PATH
    pause
    exit /b 1
)
echo.

echo [2/4] Checking JAVA_HOME...
if "%JAVA_HOME%"=="" (
    echo ERROR: JAVA_HOME is not set
    echo Please set JAVA_HOME environment variable
    pause
    exit /b 1
) else (
    echo JAVA_HOME=%JAVA_HOME%
)
echo.

echo [3/4] Verifying JAVA_HOME directory exists...
if exist "%JAVA_HOME%\bin\java.exe" (
    echo SUCCESS: JAVA_HOME is correctly set
) else (
    echo ERROR: JAVA_HOME points to invalid directory
    echo Please verify the path: %JAVA_HOME%
    pause
    exit /b 1
)
echo.

echo [4/4] Configuring Flutter to use JDK 17...
cd /d "%~dp0hanseco_app"
flutter config --jdk-dir="%JAVA_HOME%"
echo.

echo ========================================
echo Running Flutter Doctor...
echo ========================================
flutter doctor -v
echo.

echo ========================================
echo Verification Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Follow FIREBASE_SETUP_GUIDE.md to configure Google Sign-In
echo 2. Run: cd hanseco_app
echo 3. Run: flutter build apk --debug
echo.
pause
