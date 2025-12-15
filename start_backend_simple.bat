@echo off
REM Script de demarrage rapide du backend (suppose que l'environnement est deja configure)

echo Demarrage du backend Django...
cd backend
call venv\Scripts\activate.bat
python manage.py runserver
