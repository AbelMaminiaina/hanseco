@echo off
echo ========================================
echo Migration vers PostgreSQL - HansEco
echo ========================================
echo.

cd backend

echo [1/5] Activation de l'environnement virtuel...
call venv\Scripts\activate.bat

echo.
echo [2/5] Installation/Mise a jour des dependances PostgreSQL...
pip install psycopg2-binary dj-database-url python-dotenv

echo.
echo [3/5] Verification de la connexion PostgreSQL...
python -c "import os; from dotenv import load_dotenv; load_dotenv(); print('DATABASE_URL:', 'CONFIGUREE' if os.getenv('DATABASE_URL') else 'NON CONFIGUREE')"

echo.
echo [4/5] Execution des migrations...
python manage.py migrate

if errorlevel 1 (
    echo.
    echo ERREUR: Les migrations ont echoue
    echo.
    echo Verifiez:
    echo 1. DATABASE_URL est correctement configuree dans .env
    echo 2. La base de donnees PostgreSQL est accessible
    echo 3. Les credentials sont corrects
    echo.
    pause
    exit /b 1
)

echo.
echo [5/5] Creation d'un superutilisateur...
echo.
echo Voulez-vous creer un superutilisateur? (O/N)
set /p create_super="Votre choix: "

if /i "%create_super%"=="O" (
    python manage.py createsuperuser
)

echo.
echo ========================================
echo Migration terminee avec succes!
echo ========================================
echo.
echo Votre application utilise maintenant PostgreSQL sur Neon
echo.
echo Pour demarrer le backend:
echo   .\start_backend.bat
echo.
echo Pour acceder a l'admin Django:
echo   http://localhost:8000/admin
echo.

cd ..
pause
