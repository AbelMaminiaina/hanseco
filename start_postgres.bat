@echo off
echo ========================================
echo Demarrage de PostgreSQL pour HansEco
echo ========================================
echo.

echo Verifiez que Docker Desktop est lance...
echo.

docker-compose up -d postgres

if errorlevel 1 (
    echo.
    echo ERREUR: Impossible de demarrer PostgreSQL
    echo.
    echo Verifiez que:
    echo 1. Docker Desktop est installe et demarre
    echo 2. Le port 5432 n'est pas deja utilise
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo PostgreSQL demarre avec succes!
echo ========================================
echo.
echo Connection:
echo   Host: localhost
echo   Port: 5432
echo   Database: hanseco_db
echo   User: hanseco
echo   Password: hanseco123
echo.
echo Pour arreter: docker-compose down
echo Pour voir les logs: docker-compose logs postgres
echo.

pause
