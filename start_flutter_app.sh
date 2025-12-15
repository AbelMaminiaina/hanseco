#!/bin/bash

echo "================================"
echo "Demarrage de HansEco Flutter App"
echo "================================"
echo ""

cd hanseco_app || exit 1

echo "[1/3] Verification de Flutter..."
if ! flutter --version; then
    echo "ERREUR: Flutter n'est pas installe ou n'est pas dans le PATH"
    echo "Veuillez installer Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo ""
echo "[2/3] Installation des dependances..."
if ! flutter pub get; then
    echo "ERREUR: Impossible d'installer les dependances"
    exit 1
fi

echo ""
echo "[3/3] Demarrage de l'application..."
echo ""
echo "Options disponibles:"
echo "  - Chrome: flutter run -d chrome"
echo "  - Edge: flutter run -d edge"
echo "  - Appareil connecte: flutter run"
echo ""

flutter run -d chrome
