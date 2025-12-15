@echo off
echo ========================================
echo Demarrage du Backend Django - HansEco
echo ========================================
echo.

cd backend

REM Verifier si Python est installe
python --version >nul 2>&1
if errorlevel 1 (
    echo ERREUR: Python n'est pas installe ou n'est pas dans le PATH
    echo Installez Python depuis: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [1/5] Verification de l'environnement virtuel...
if not exist venv (
    echo Creation de l'environnement virtuel...
    python -m venv venv
    if errorlevel 1 (
        echo ERREUR: Impossible de creer l'environnement virtuel
        pause
        exit /b 1
    )
    echo OK - Environnement virtuel cree
) else (
    echo OK - Environnement virtuel existe
)

echo.
echo [2/5] Activation de l'environnement virtuel...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ERREUR: Impossible d'activer l'environnement virtuel
    pause
    exit /b 1
)

echo.
echo [3/5] Installation des dependances...
pip install -r requirements.txt
if errorlevel 1 (
    echo ERREUR: Impossible d'installer les dependances
    pause
    exit /b 1
)

echo.
echo [4/5] Verification du fichier .env...
if not exist .env (
    echo ATTENTION: Fichier .env manquant, copie depuis .env.example...
    copy .env.example .env
    echo.
    echo IMPORTANT: Configurez les variables dans backend\.env avant de continuer!
    echo Particulierement:
    echo   - DATABASE_URL
    echo   - SECRET_KEY
    echo.
    pause
)

echo.
echo [5/5] Demarrage du serveur Django...
echo.
echo ========================================
echo Backend demarre sur http://localhost:8000
echo ========================================
echo.
echo Pour arreter le serveur: Ctrl+C
echo.

python manage.py runserver
