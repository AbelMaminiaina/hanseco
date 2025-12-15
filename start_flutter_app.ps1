#!/usr/bin/env pwsh

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Demarrage de HansEco Flutter App" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

Set-Location hanseco_app

Write-Host "[1/3] Verification de Flutter..." -ForegroundColor Yellow
try {
    flutter --version
} catch {
    Write-Host "ERREUR: Flutter n'est pas installe ou n'est pas dans le PATH" -ForegroundColor Red
    Write-Host "Veuillez installer Flutter: https://flutter.dev/docs/get-started/install" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/3] Installation des dependances..." -ForegroundColor Yellow
$result = flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: Impossible d'installer les dependances" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[3/3] Demarrage de l'application..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Options disponibles:" -ForegroundColor Green
Write-Host "  - Chrome: flutter run -d chrome" -ForegroundColor Gray
Write-Host "  - Edge: flutter run -d edge" -ForegroundColor Gray
Write-Host "  - Appareil connecte: flutter run" -ForegroundColor Gray
Write-Host ""

flutter run -d chrome
