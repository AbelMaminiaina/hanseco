#!/bin/bash

echo "============================================"
echo "Verification de la Configuration OAuth"
echo "============================================"
echo ""

echo "[1] Verification du fichier .env du Frontend..."
cd hanseco_app || exit 1

if [ ! -f .env ]; then
    echo "ERREUR: Le fichier .env n'existe pas!"
    echo "Copiez .env.example vers .env et configurez-le."
    exit 1
fi

echo ""
echo "--- Variables OAuth dans hanseco_app/.env ---"
grep -i "GOOGLE_CLIENT_ID\|FACEBOOK_APP_ID\|API_BASE_URL" .env
echo ""

echo "[2] Verification du meta tag Google dans web/index.html..."
echo ""
echo "--- Meta tag dans web/index.html ---"
grep -i "google-signin-client_id" web/index.html
echo ""

echo "[3] Verification du fichier .env du Backend..."
cd ../backend || exit 1

if [ ! -f .env ]; then
    echo "ATTENTION: Le fichier backend/.env n'existe pas!"
    echo "Copiez .env.example vers .env et configurez-le."
    echo ""
else
    echo "--- Variables OAuth dans backend/.env ---"
    grep -i "GOOGLE_OAUTH_CLIENT_ID\|GOOGLE_OAUTH_CLIENT_SECRET\|CORS_ALLOWED_ORIGINS" .env
    echo ""
fi

echo "[4] Verification du backend Django..."
echo ""
echo "Tentative de connexion au backend..."
if curl -s http://localhost:8000/api/ > /dev/null 2>&1; then
    echo "OK: Backend accessible sur http://localhost:8000"
else
    echo "ATTENTION: Le backend ne semble pas etre demarre sur http://localhost:8000"
    echo "Demarrez-le avec: cd backend && python manage.py runserver"
fi
echo ""

echo "============================================"
echo "Checklist de Configuration"
echo "============================================"
echo ""
echo "[ ] Avez-vous cree un projet dans Google Cloud Console?"
echo "[ ] Avez-vous active Google Sign-In API?"
echo "[ ] Avez-vous cree un OAuth Client ID (Web application)?"
echo "[ ] Avez-vous ajoute les origines autorisees (http://localhost:3000, etc.)?"
echo "[ ] Avez-vous copie le Client ID dans hanseco_app/.env?"
echo "[ ] Avez-vous copie le Client ID dans hanseco_app/web/index.html?"
echo "[ ] Avez-vous copie le Client ID et Secret dans backend/.env?"
echo "[ ] Le backend Django est-il demarre?"
echo ""
echo "============================================"
echo ""
echo "Pour plus d'informations, consultez OAUTH_SETUP_GUIDE.md"
echo ""

cd ..
