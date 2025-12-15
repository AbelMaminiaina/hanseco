@echo off
echo =========================================
echo Mode Developpement HansEco Flutter App
echo =========================================
echo.

cd hanseco_app

echo [1/4] Verification de Flutter...
flutter doctor
if errorlevel 1 (
    echo ATTENTION: Certains outils Flutter ne sont pas configures correctement
    echo.
)

echo.
echo [2/4] Nettoyage du cache...
call flutter clean

echo.
echo [3/4] Installation des dependances...
call flutter pub get

echo.
echo [4/4] Generation du code (build_runner)...
call flutter pub run build_runner build --delete-conflicting-outputs

echo.
echo ====================================
echo Environnement pret pour le dev!
echo ====================================
echo.
echo Commandes utiles:
echo   flutter run -d chrome          : Lancer en mode debug sur Chrome
echo   flutter run -d chrome --release: Lancer en mode release
echo   flutter test                   : Executer les tests
echo   flutter build web              : Construire pour le web
echo.

pause
