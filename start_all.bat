@echo off
echo ========================================
echo Demarrage Complet - HansEco
echo Backend Django + Frontend Flutter
echo ========================================
echo.

REM Demarrer le backend en arriere-plan
echo [1/2] Demarrage du Backend Django...
start "HansEco Backend" cmd /k "cd backend && call venv\Scripts\activate.bat && python manage.py runserver"

REM Attendre 3 secondes pour que le backend demarre
timeout /t 3 /nobreak >nul

echo.
echo [2/2] Demarrage du Frontend Flutter...
echo.

REM Demarrer le frontend
cd hanseco_app
call flutter pub get
call flutter run -d chrome

echo.
echo ========================================
echo Applications demarrees!
echo ========================================
echo.
echo Backend: http://localhost:8000
echo Frontend: (voir la sortie ci-dessus)
echo.
