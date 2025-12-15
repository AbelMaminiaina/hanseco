#!/bin/bash

echo "========================================"
echo "Demarrage du Backend Django - HansEco"
echo "========================================"
echo ""

cd backend || exit 1

# Verifier si Python est installe
if ! command -v python3 &> /dev/null; then
    echo "ERREUR: Python3 n'est pas installe"
    echo "Installez Python depuis: https://www.python.org/downloads/"
    exit 1
fi

echo "[1/5] Verification de l'environnement virtuel..."
if [ ! -d "venv" ]; then
    echo "Creation de l'environnement virtuel..."
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "ERREUR: Impossible de creer l'environnement virtuel"
        exit 1
    fi
    echo "OK - Environnement virtuel cree"
else
    echo "OK - Environnement virtuel existe"
fi

echo ""
echo "[2/5] Activation de l'environnement virtuel..."
source venv/bin/activate
if [ $? -ne 0 ]; then
    echo "ERREUR: Impossible d'activer l'environnement virtuel"
    exit 1
fi

echo ""
echo "[3/5] Installation des dependances..."
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "ERREUR: Impossible d'installer les dependances"
    exit 1
fi

echo ""
echo "[4/5] Verification du fichier .env..."
if [ ! -f .env ]; then
    echo "ATTENTION: Fichier .env manquant, copie depuis .env.example..."
    cp .env.example .env
    echo ""
    echo "IMPORTANT: Configurez les variables dans backend/.env avant de continuer!"
    echo "Particulierement:"
    echo "  - DATABASE_URL"
    echo "  - SECRET_KEY"
    echo ""
    read -p "Appuyez sur Entree pour continuer..."
fi

echo ""
echo "[5/5] Demarrage du serveur Django..."
echo ""
echo "========================================"
echo "Backend demarre sur http://localhost:8000"
echo "========================================"
echo ""
echo "Pour arreter le serveur: Ctrl+C"
echo ""

python manage.py runserver
