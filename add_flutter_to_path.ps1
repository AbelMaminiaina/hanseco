# Script pour ajouter Flutter au PATH Windows
# Exécuter ce script en tant qu'administrateur

Write-Host "=== Configuration de Flutter PATH ===" -ForegroundColor Green
Write-Host ""

# Chercher Flutter sur le système
Write-Host "Recherche de Flutter sur votre système..." -ForegroundColor Yellow

$possiblePaths = @(
    "C:\flutter\bin",
    "C:\src\flutter\bin",
    "$env:USERPROFILE\flutter\bin",
    "$env:LOCALAPPDATA\flutter\bin"
)

$flutterPath = $null

foreach ($path in $possiblePaths) {
    if (Test-Path "$path\flutter.bat") {
        $flutterPath = $path
        Write-Host "✓ Flutter trouvé dans: $path" -ForegroundColor Green
        break
    }
}

if ($null -eq $flutterPath) {
    Write-Host "✗ Flutter n'a pas été trouvé dans les emplacements communs" -ForegroundColor Red
    Write-Host ""
    Write-Host "Emplacements vérifiés:" -ForegroundColor Yellow
    foreach ($path in $possiblePaths) {
        Write-Host "  - $path" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "Veuillez installer Flutter d'abord:" -ForegroundColor Yellow
    Write-Host "  1. Téléchargez Flutter depuis: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor Cyan
    Write-Host "  2. Extrayez dans C:\flutter" -ForegroundColor Cyan
    Write-Host "  3. Relancez ce script" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Appuyez sur Entrée pour quitter"
    exit 1
}

# Vérifier si Flutter est déjà dans le PATH
$currentPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)

if ($currentPath -like "*$flutterPath*") {
    Write-Host "✓ Flutter est déjà dans votre PATH!" -ForegroundColor Green
    Write-Host ""
    Write-Host "PATH actuel inclut: $flutterPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Si 'flutter' ne fonctionne toujours pas:" -ForegroundColor Yellow
    Write-Host "  1. Fermez TOUS vos terminaux PowerShell/CMD" -ForegroundColor Cyan
    Write-Host "  2. Rouvrez un nouveau terminal" -ForegroundColor Cyan
    Write-Host "  3. Tapez: flutter --version" -ForegroundColor Cyan
} else {
    Write-Host "Ajout de Flutter au PATH utilisateur..." -ForegroundColor Yellow

    # Ajouter Flutter au PATH
    $newPath = $currentPath + ";$flutterPath"
    [System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::User)

    Write-Host "✓ Flutter ajouté au PATH avec succès!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Chemin ajouté: $flutterPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "IMPORTANT - Prochaines étapes:" -ForegroundColor Yellow
    Write-Host "  1. Fermez ce terminal PowerShell" -ForegroundColor Cyan
    Write-Host "  2. Ouvrez un NOUVEAU terminal PowerShell" -ForegroundColor Cyan
    Write-Host "  3. Vérifiez avec: flutter --version" -ForegroundColor Cyan
    Write-Host "  4. Puis lancez: flutter doctor" -ForegroundColor Cyan
    Write-Host ""
}

Write-Host "==================================" -ForegroundColor Green
Write-Host ""
Read-Host "Appuyez sur Entrée pour quitter"
