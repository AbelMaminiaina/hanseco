@echo off
echo ================================
echo Demarrage de HansEco Flutter App
echo ================================
echo.

cd hanseco_app

echo [1/3] Verification de Flutter...
flutter --version
if errorlevel 1 (
    echo ERREUR: Flutter n'est pas installe ou n'est pas dans le PATH
    echo Veuillez installer Flutter: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo.
echo [2/3] Installation des dependances...
call flutter pub get
if errorlevel 1 (
    echo ERREUR: Impossible d'installer les dependances
    pause
    exit /b 1
)

echo.
echo [3/3] Demarrage de l'application...
echo.
echo Options disponibles:
echo   - Chrome: flutter run -d chrome
echo   - Edge: flutter run -d edge
echo   - Appareil connecte: flutter run
echo.

flutter run -d chrome

pause
