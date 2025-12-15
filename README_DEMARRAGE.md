# Guide de Démarrage - HansEco

Ce guide vous explique comment démarrer le backend Django et le frontend Flutter de l'application HansEco.

## Prérequis

- **Python 3.10+** - [Télécharger Python](https://www.python.org/downloads/)
- **Flutter 3.0+** - [Installer Flutter](https://flutter.dev/docs/get-started/install)
- **PostgreSQL** (optionnel, SQLite par défaut) - [Télécharger PostgreSQL](https://www.postgresql.org/download/)
- **Git Bash/MSYS** (pour Windows) - Déjà installé si vous utilisez Git

## Démarrage Rapide

### Option 1: Démarrer Backend + Frontend ensemble

```bash
.\start_all.bat
```

Ce script démarre automatiquement:
- Le backend Django sur `http://localhost:8000`
- Le frontend Flutter sur Chrome

### Option 2: Démarrer séparément

#### Démarrer uniquement le Backend

```bash
# Première fois (configuration complète)
.\setup_backend.bat

# Démarrages suivants
.\start_backend.bat

# OU version rapide (si déjà configuré)
.\start_backend_simple.bat
```

Le backend sera accessible sur `http://localhost:8000`

#### Démarrer uniquement le Frontend

```bash
.\start_flutter_app.bat
```

Le frontend s'ouvrira automatiquement dans Chrome.

---

## Configuration Détaillée

### 1. Configuration du Backend Django

#### Première installation

Exécutez le script de configuration:

```bash
.\setup_backend.bat
```

Ce script va:
1. Créer un environnement virtuel Python
2. Installer toutes les dépendances
3. Créer le fichier `.env` depuis `.env.example`
4. Proposer d'exécuter les migrations
5. Proposer de créer un superutilisateur

#### Configuration manuelle

Si vous préférez configurer manuellement:

```bash
cd backend

# Créer l'environnement virtuel
python -m venv venv

# Activer l'environnement virtuel
# Windows CMD:
venv\Scripts\activate.bat
# Windows PowerShell:
venv\Scripts\Activate.ps1
# Linux/Mac:
source venv/bin/activate

# Installer les dépendances
pip install -r requirements.txt

# Copier le fichier .env
copy .env.example .env  # Windows
cp .env.example .env    # Linux/Mac

# Configurer la base de données
python manage.py migrate

# Créer un superutilisateur
python manage.py createsuperuser

# Démarrer le serveur
python manage.py runserver
```

#### Variables d'environnement importantes

Éditez `backend/.env`:

```env
# Django
DEBUG=True
SECRET_KEY=votre-cle-secrete-unique
ALLOWED_HOSTS=localhost,127.0.0.1

# Base de données (SQLite par défaut)
DATABASE_URL=sqlite:///db.sqlite3
# Ou PostgreSQL:
# DATABASE_URL=postgresql://user:password@localhost:5432/hanseco_db

# OAuth Google (à configurer avec vos credentials)
GOOGLE_OAUTH_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=YOUR_GOOGLE_CLIENT_SECRET

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
```

### 2. Configuration du Frontend Flutter

#### Installation des dépendances

```bash
cd hanseco_app
flutter pub get
```

#### Configuration de l'environnement

Le fichier `hanseco_app/.env` doit être configuré avec:

```env
API_BASE_URL=http://localhost:8000/api
GOOGLE_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com
```

#### Démarrer l'application

```bash
# Chrome (recommandé pour le développement)
flutter run -d chrome

# Edge
flutter run -d edge

# Windows Desktop
flutter run -d windows

# Appareil Android connecté
flutter run

# Voir tous les appareils disponibles
flutter devices
```

---

## Scripts Disponibles

### Backend

| Script | Description |
|--------|-------------|
| `setup_backend.bat` | Configuration initiale complète du backend |
| `start_backend.bat` | Démarre le backend avec toutes les vérifications |
| `start_backend_simple.bat` | Démarrage rapide (environnement déjà configuré) |
| `start_backend.sh` | Version Bash du script de démarrage |

### Frontend

| Script | Description |
|--------|-------------|
| `start_flutter_app.bat` | Démarre le frontend Flutter sur Chrome |
| `start_flutter_app.sh` | Version Bash |
| `start_flutter_app.ps1` | Version PowerShell |
| `start_flutter_dev.bat` | Mode développement (clean + build_runner) |

### Complet

| Script | Description |
|--------|-------------|
| `start_all.bat` | Démarre backend + frontend ensemble |

### OAuth

| Script | Description |
|--------|-------------|
| `verify_oauth_setup.bat` | Vérifie la configuration OAuth |
| `check_oauth_config.bat` | Contrôle détaillé de la config OAuth |
| `fix_oauth_quick.bat` | Configuration rapide d'un nouveau Client ID |

---

## Commandes Utiles

### Backend Django

```bash
cd backend

# Activer l'environnement virtuel
venv\Scripts\activate.bat  # Windows
source venv/bin/activate   # Linux/Mac

# Créer des migrations
python manage.py makemigrations

# Appliquer les migrations
python manage.py migrate

# Créer un superutilisateur
python manage.py createsuperuser

# Lancer les tests
python manage.py test

# Collecter les fichiers statiques
python manage.py collectstatic

# Accéder au shell Django
python manage.py shell
```

### Frontend Flutter

```bash
cd hanseco_app

# Installer les dépendances
flutter pub get

# Générer le code (build_runner)
flutter pub run build_runner build --delete-conflicting-outputs

# Nettoyer le cache
flutter clean

# Analyser le code
flutter analyze

# Lancer les tests
flutter test

# Build pour production
flutter build web         # Web
flutter build windows     # Windows
flutter build apk         # Android
flutter build ios         # iOS
```

---

## URLs Importantes

### Backend

- **API**: http://localhost:8000/api/
- **Admin Django**: http://localhost:8000/admin/
- **Documentation API**: http://localhost:8000/api/docs/ (si configuré)

### Frontend

- **Application Web**: http://localhost:XXXX (port affiché au démarrage)

---

## Dépannage

### Le backend ne démarre pas

**Problème**: `ModuleNotFoundError` ou dépendances manquantes

**Solution**:
```bash
cd backend
venv\Scripts\activate.bat
pip install -r requirements.txt
```

**Problème**: `django.db.utils.OperationalError`

**Solution**: La base de données n'est pas configurée ou migrée
```bash
python manage.py migrate
```

**Problème**: Port 8000 déjà utilisé

**Solution**: Utilisez un autre port
```bash
python manage.py runserver 8001
```

N'oubliez pas de changer `API_BASE_URL` dans `hanseco_app/.env`!

### Le frontend ne démarre pas

**Problème**: `flutter: command not found`

**Solution**: Flutter n'est pas installé ou pas dans le PATH
- Installez Flutter: https://flutter.dev/docs/get-started/install
- Vérifiez: `flutter doctor`

**Problème**: Erreurs de dépendances

**Solution**:
```bash
cd hanseco_app
flutter clean
flutter pub get
```

**Problème**: Erreurs OAuth Google

**Solution**: Consultez `OAUTH_SETUP_GUIDE.md` et vérifiez:
```bash
.\verify_oauth_setup.bat
```

### Erreur CORS

**Problème**: `Access to XMLHttpRequest has been blocked by CORS policy`

**Solution**: Vérifiez `backend/.env`:
```env
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080,http://localhost:VOTRE_PORT
```

Ajoutez le port exact utilisé par Flutter.

---

## Architecture

```
HansEco/
├── backend/              # Backend Django
│   ├── manage.py
│   ├── requirements.txt
│   ├── .env             # Configuration (à créer)
│   └── venv/            # Environnement virtuel (créé automatiquement)
│
├── hanseco_app/         # Frontend Flutter
│   ├── lib/
│   ├── web/
│   ├── pubspec.yaml
│   └── .env            # Configuration
│
├── start_all.bat        # Démarrer tout
├── start_backend.bat    # Démarrer backend
├── start_flutter_app.bat # Démarrer frontend
└── README_DEMARRAGE.md  # Ce fichier
```

---

## Prochaines Étapes

1. ✅ Configurer le backend Django
2. ✅ Configurer le frontend Flutter
3. ✅ Configurer OAuth Google
4. 📝 Créer des produits de test via l'admin Django
5. 📝 Tester l'application complète
6. 📝 Configurer les providers de paiement (MVola, Airtel Money, etc.)

---

## Support

Pour plus d'informations:
- **OAuth Google**: `OAUTH_SETUP_GUIDE.md`
- **Configuration OAuth**: `verify_oauth_setup.bat`
- **Flutter**: https://flutter.dev/docs
- **Django**: https://docs.djangoproject.com/

En cas de problème, vérifiez:
1. Les logs du backend dans le terminal
2. La console du navigateur (F12)
3. Les logs Flutter dans le terminal
