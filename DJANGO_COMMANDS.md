# Commandes Django - Guide de référence HansEco

Ce document contient toutes les commandes utiles pour gérer le backend Django de HansEco.

## Démarrage et Arrêt du Serveur

### Démarrer le serveur de développement
```bash
cd C:\Users\amami\GitHub\HansEco\backend
python manage.py runserver
```

Le serveur démarre sur **http://localhost:8000** par default.

### Démarrer sur un port personnalisé
```bash
python manage.py runserver 8080
```

### Arrêter le serveur
- Appuyez sur `Ctrl+C` dans le terminal

### Note importante
Le serveur Django se recharge **automatiquement** quand vous modifiez des fichiers Python. Pas besoin de redémarrer manuellement après chaque modification.

## Gestion de la Base de Données

### Créer de nouvelles migrations
Après avoir modifié les models dans `models.py`:
```bash
python manage.py makemigrations
```

### Créer des migrations pour une app spécifique
```bash
python manage.py makemigrations hanseco_auth
python manage.py makemigrations products
python manage.py makemigrations oauth
```

### Appliquer les migrations
```bash
python manage.py migrate
```

### Voir l'état des migrations
```bash
python manage.py showmigrations
```

### Voir le SQL d'une migration
```bash
python manage.py sqlmigrate hanseco_auth 0001
```

### Revenir à une migration précédente
```bash
python manage.py migrate hanseco_auth 0001
```

### Réinitialiser toutes les migrations (ATTENTION: Supprime les données)
```bash
python manage.py migrate --run-syncdb
```

## Gestion des Utilisateurs

### Créer un superutilisateur
```bash
python manage.py createsuperuser
```

### Changer le mot de passe d'un utilisateur
```bash
python manage.py changepassword username
```

## Gestion des Fichiers Statiques

### Collecter tous les fichiers statiques
```bash
python manage.py collectstatic
```

### Collecter sans confirmation
```bash
python manage.py collectstatic --noinput
```

## Shell et Débogage

### Ouvrir le shell Django
```bash
python manage.py shell
```

Exemple d'utilisation dans le shell:
```python
from hanseco_backend.apps.hanseco_auth.models import User
users = User.objects.all()
for user in users:
    print(user.email)
```

### Shell avec IPython (si installé)
```bash
python manage.py shell -i ipython
```

### Ouvrir le shell de base de données
```bash
python manage.py dbshell
```

## Vérifications et Tests

### Vérifier les problèmes du projet
```bash
python manage.py check
```

### Vérifier les problèmes de déploiement
```bash
python manage.py check --deploy
```

### Lancer les tests
```bash
python manage.py test
```

### Lancer les tests pour une app spécifique
```bash
python manage.py test hanseco_backend.apps.hanseco_auth
python manage.py test hanseco_backend.apps.products
```

### Lancer les tests avec verbosité
```bash
python manage.py test --verbosity=2
```

## Gestion des Apps

### Créer une nouvelle app
```bash
python manage.py startapp nom_de_lapp
```

## Administration

### Accéder à l'interface d'administration
URL: **http://localhost:8000/admin/**

Utilisez les identifiants du superutilisateur créé avec `createsuperuser`.

### Vider une table
```bash
python manage.py flush
```
⚠️ **ATTENTION**: Cette commande supprime TOUTES les données de la base de données!

## Données de Test

### Charger des fixtures (données de test)
```bash
python manage.py loaddata fixtures/products.json
```

### Créer des fixtures depuis la base de données
```bash
python manage.py dumpdata products --indent=2 > fixtures/products.json
```

### Créer des fixtures pour toute la base de données
```bash
python manage.py dumpdata --indent=2 > fixtures/all_data.json
```

## Maintenance et Nettoyage

### Supprimer les sessions expirées
```bash
python manage.py clearsessions
```

### Supprimer les fichiers de migration (ATTENTION)
```bash
# Supprimer les fichiers de migration (sauf __init__.py)
# À faire manuellement dans chaque dossier migrations/
```

## Variables d'Environnement

### Afficher la configuration actuelle
```bash
python manage.py diffsettings
```

## Commandes Personnalisées

Vous pouvez créer vos propres commandes dans:
```
backend/hanseco_backend/apps/[app_name]/management/commands/
```

### Exemple: Créer des données de test
```bash
# Si vous créez une commande personnalisée create_test_data.py
python manage.py create_test_data
```

## Logs et Débogage

### Activer le mode DEBUG
Dans `backend/.env`:
```env
DEBUG=True
```

### Désactiver le mode DEBUG (Production)
```env
DEBUG=False
```

### Voir les requêtes SQL dans le terminal
Ajoutez dans `settings.py`:
```python
LOGGING = {
    'version': 1,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'loggers': {
        'django.db.backends': {
            'level': 'DEBUG',
            'handlers': ['console'],
        },
    },
}
```

## Installation et Dépendances

### Installer les dépendances
```bash
pip install -r requirements.txt
```

### Mettre à jour les dépendances
```bash
pip install --upgrade -r requirements.txt
```

### Créer/Mettre à jour requirements.txt
```bash
pip freeze > requirements.txt
```

### Installer une nouvelle dépendance
```bash
pip install nom-du-package
pip freeze > requirements.txt
```

## Production

### Collecter les fichiers statiques pour production
```bash
python manage.py collectstatic --noinput
```

### Vérifier la configuration de production
```bash
python manage.py check --deploy
```

### Désactiver le mode debug
```env
DEBUG=False
ALLOWED_HOSTS=votredomaine.com,www.votredomaine.com
```

## Commandes Rapides

### Réinitialisation complète du projet (ATTENTION: Perte de données)
```bash
# 1. Supprimer la base de données
rm db.sqlite3  # ou supprimer la base PostgreSQL

# 2. Supprimer les migrations
find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
find . -path "*/migrations/*.pyc" -delete

# 3. Créer de nouvelles migrations
python manage.py makemigrations

# 4. Appliquer les migrations
python manage.py migrate

# 5. Créer un superutilisateur
python manage.py createsuperuser
```

### Commandes courantes dans l'ordre
```bash
# Développement quotidien
python manage.py makemigrations
python manage.py migrate
python manage.py runserver

# Après avoir créé un nouveau modèle
python manage.py makemigrations [app_name]
python manage.py migrate
```

## Raccourcis Utiles

Pour créer des raccourcis, ajoutez ces alias dans votre terminal:

### Pour Windows (PowerShell)
Créez un fichier `profile.ps1` dans `Documents\WindowsPowerShell\`:
```powershell
function dj { python manage.py $args }
function djrun { python manage.py runserver }
function djmig { python manage.py migrate }
function djmake { python manage.py makemigrations }
```

Utilisation:
```bash
djrun          # Lance le serveur
djmake         # Crée les migrations
djmig          # Applique les migrations
dj shell       # Ouvre le shell
```

### Pour Git Bash / Linux / Mac
Ajoutez dans `~/.bashrc` ou `~/.bash_profile`:
```bash
alias dj="python manage.py"
alias djrun="python manage.py runserver"
alias djmig="python manage.py migrate"
alias djmake="python manage.py makemigrations"
```

## Endpoints API Actuels

Une fois le serveur démarré, vous pouvez accéder à:

- **API Root**: http://localhost:8000/api/
- **Admin**: http://localhost:8000/admin/
- **Auth Login**: http://localhost:8000/api/auth/login/
- **Auth Register**: http://localhost:8000/api/auth/register/
- **Google OAuth**: http://localhost:8000/api/oauth/google/
- **Facebook OAuth**: http://localhost:8000/api/oauth/facebook/
- **Products**: http://localhost:8000/api/products/

## Ressources

- [Documentation Django](https://docs.djangoproject.com/)
- [Django REST Framework](https://www.django-rest-framework.org/)
- [Django Management Commands](https://docs.djangoproject.com/en/stable/ref/django-admin/)
