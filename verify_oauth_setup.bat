@echo off
echo ============================================
echo Verification OAuth - Configuration Complete
echo ============================================
echo.

set CLIENT_ID=YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com

echo [1] Configuration Backend
echo.
cd backend
findstr /i "GOOGLE_OAUTH_CLIENT_ID GOOGLE_OAUTH_CLIENT_SECRET" .env
echo.

echo [2] Configuration Frontend (.env)
echo.
cd ..\hanseco_app
findstr /i "GOOGLE_CLIENT_ID" .env
echo.

echo [3] Configuration Frontend (web/index.html)
echo.
findstr /i "google-signin-client_id" web\index.html
echo.

echo ============================================
echo Configuration Google Cloud Console Requise
echo ============================================
echo.
echo Assurez-vous que dans Google Cloud Console:
echo https://console.cloud.google.com/apis/credentials
echo.
echo Pour le Client ID: %CLIENT_ID%
echo.
echo 1. Origines JavaScript autorisees:
echo    - http://localhost
echo    - http://localhost:3000
echo    - http://localhost:8080
echo    - http://localhost:50000-65535
echo    - http://127.0.0.1
echo    - http://127.0.0.1:3000
echo    - http://127.0.0.1:8080
echo.
echo 2. URI de redirection autorises:
echo    - http://localhost
echo    - http://localhost:3000
echo    - http://localhost:8080
echo.
echo ============================================
echo Test de connexion
echo ============================================
echo.

echo Verification du backend...
curl -s http://localhost:8000/api/ >nul 2>&1
if errorlevel 1 (
    echo [X] Backend NON demarre
    echo     Lancez: cd backend ^&^& python manage.py runserver
) else (
    echo [OK] Backend accessible
)
echo.

cd ..
echo ============================================
echo.
echo Si la configuration est correcte, lancez:
echo   .\start_flutter_app.bat
echo.

pause
