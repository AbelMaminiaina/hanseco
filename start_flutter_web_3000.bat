@echo off
echo ================================
echo HansEco Flutter App - Port 3000
echo ================================
echo.

cd hanseco_app

echo [1/2] Installation des dependances...
call flutter pub get

echo.
echo [2/2] Demarrage sur http://localhost:3000...
echo.
echo IMPORTANT: Configurez Google Cloud Console avec:
echo   Origines JavaScript: http://localhost:3000
echo   URI de redirection: http://localhost:3000 et http://localhost:3000/
echo.

flutter run -d chrome --web-port=3000

pause
