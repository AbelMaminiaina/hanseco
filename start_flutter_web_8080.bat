@echo off
echo ================================
echo HansEco Flutter App - Port 8080
echo ================================
echo.

cd hanseco_app

echo [1/2] Installation des dependances...
call flutter pub get

echo.
echo [2/2] Demarrage sur http://localhost:8080...
echo.
echo IMPORTANT: Configurez Google Cloud Console avec:
echo   Origines JavaScript: http://localhost:8080
echo   URI de redirection: http://localhost:8080 et http://localhost:8080/
echo.

flutter run -d chrome --web-port=8080

pause
