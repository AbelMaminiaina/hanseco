@echo off
echo ============================================
echo Configuration Rapide OAuth Google
echo ============================================
echo.
echo Ce script va vous guider pour configurer OAuth Google rapidement.
echo.

set /p CLIENT_ID="Entrez votre Google Client ID (format: xxxxx.apps.googleusercontent.com): "

if "%CLIENT_ID%"=="" (
    echo ERREUR: Client ID requis!
    pause
    exit /b 1
)

echo.
echo Configuration en cours...
echo.

REM Update hanseco_app/.env
echo [1/3] Mise a jour de hanseco_app/.env...
cd hanseco_app
if not exist .env (
    copy .env.example .env
)

REM Use PowerShell to update the .env file
powershell -Command "(Get-Content .env) -replace 'GOOGLE_CLIENT_ID=.*', 'GOOGLE_CLIENT_ID=%CLIENT_ID%' | Set-Content .env"
echo OK

REM Update web/index.html
echo [2/3] Mise a jour de web/index.html...
powershell -Command "(Get-Content web\index.html) -replace 'content=\"YOUR_GOOGLE_CLIENT_ID\.apps\.googleusercontent\.com\"', 'content=\"%CLIENT_ID%\"' | Set-Content web\index.html"
echo OK

REM Update backend/.env
echo [3/3] Mise a jour de backend/.env...
cd ..\backend
if not exist .env (
    copy .env.example .env
)

powershell -Command "(Get-Content .env) -replace 'GOOGLE_OAUTH_CLIENT_ID=.*', 'GOOGLE_OAUTH_CLIENT_ID=%CLIENT_ID%' | Set-Content .env"
echo OK

cd ..

echo.
echo ============================================
echo Configuration terminee!
echo ============================================
echo.
echo Client ID configure dans:
echo   - hanseco_app/.env
echo   - hanseco_app/web/index.html
echo   - backend/.env
echo.
echo IMPORTANT: N'oubliez pas de configurer aussi:
echo   1. GOOGLE_OAUTH_CLIENT_SECRET dans backend/.env
echo   2. Les origines autorisees dans Google Cloud Console:
echo      - http://localhost:3000
echo      - http://localhost:8080
echo      - http://127.0.0.1:3000
echo.
echo Pour plus d'details, consultez OAUTH_SETUP_GUIDE.md
echo.

pause
