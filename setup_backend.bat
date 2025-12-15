@echo off
echo ========================================
echo Configuration Initiale du Backend Django
echo ========================================
echo.

cd backend

echo [1/6] Creation de l'environnement virtuel...
if exist venv (
    echo Environnement virtuel existe deja
) else (
    python -m venv venv
    echo OK
)

echo.
echo [2/6] Activation de l'environnement virtuel...
call venv\Scripts\activate.bat

echo.
echo [3/6] Mise a jour de pip...
python -m pip install --upgrade pip

echo.
echo [4/6] Installation des dependances...
pip install -r requirements.txt

echo.
echo [5/6] Configuration du fichier .env...
if not exist .env (
    copy .env.example .env
    echo Fichier .env cree depuis .env.example
    echo.
    echo IMPORTANT: Editez backend\.env et configurez:
    echo   - SECRET_KEY (generez une nouvelle cle)
    echo   - DATABASE_URL (votre base de donnees PostgreSQL)
    echo   - GOOGLE_OAUTH_CLIENT_ID (deja configure)
    echo   - GOOGLE_OAUTH_CLIENT_SECRET (deja configure)
    echo.
) else (
    echo Fichier .env existe deja
)

echo.
echo [6/6] Migrations de la base de donnees...
echo.
set /p migrate="Voulez-vous executer les migrations maintenant? (O/N): "
if /i "%migrate%"=="O" (
    python manage.py makemigrations
    python manage.py migrate
    echo.
    echo Migrations terminees!
    echo.
    set /p createsuperuser="Voulez-vous creer un superutilisateur? (O/N): "
    if /i "%createsuperuser%"=="O" (
        python manage.py createsuperuser
    )
)

echo.
echo ========================================
echo Configuration terminee!
echo ========================================
echo.
echo Pour demarrer le backend:
echo   .\start_backend.bat
echo.
echo Pour acceder a l'admin Django:
echo   http://localhost:8000/admin
echo.

cd ..
pause
