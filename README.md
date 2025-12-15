# HansEco - Application E-Commerce Électronique

Application mobile e-commerce spécialisée en électronique pour Madagascar avec support des paiements locaux (Mvola, Airtel Money, Orange Money) et internationaux (PayPal, Stripe).

## 📱 Architecture du Projet

### Frontend (Flutter)
```
hanseco_app/
├── lib/
│   ├── features/           # Feature-First Architecture
│   │   ├── auth/          # Authentification
│   │   ├── products/      # Catalogue produits
│   │   ├── cart/          # Panier
│   │   ├── payments/      # Paiements
│   │   └── profile/       # Profil utilisateur
│   └── core/              # Composants réutilisables
│       ├── constants/     # Constantes
│       ├── errors/        # Gestion des erreurs
│       ├── network/       # Configuration réseau
│       ├── router/        # Navigation
│       ├── theme/         # Thèmes
│       └── widgets/       # Widgets réutilisables
```

### Backend (Django)
```
backend/
├── hanseco_backend/
│   ├── apps/
│   │   ├── auth/          # Authentification & Utilisateurs
│   │   ├── products/      # Produits & Catégories
│   │   ├── cart/          # Gestion du panier
│   │   ├── orders/        # Commandes
│   │   └── payments/      # Intégrations paiement
│   └── core/
│       └── settings/      # Configuration Django
```

## 🚀 Technologies Utilisées

### Frontend
- **Flutter** 3.x avec Dart null safety
- **Riverpod** pour la gestion d'état
- **go_router** pour la navigation
- **Dio** pour les appels API
- **Hive** pour le stockage local
- **flutter_secure_storage** pour la sécurité

### Backend
- **Django** 5.0
- **Django REST Framework** pour l'API
- **PostgreSQL** comme base de données
- **JWT** pour l'authentification
- **Celery** pour les tâches asynchrones
- **Redis** pour le cache

## 📦 Installation

### Prérequis
- Flutter SDK (>= 3.0.0)
- Python (>= 3.10)
- PostgreSQL (>= 14)
- Redis (optionnel, pour Celery)

### Frontend Flutter

```bash
cd hanseco_app

# Installer Flutter (si pas encore installé)
# Voir: https://flutter.dev/docs/get-started/install

# Créer le fichier .env
cp .env.example .env

# Éditer .env avec vos clés API

# Installer les dépendances
flutter pub get

# Générer les fichiers (models, providers)
flutter pub run build_runner build --delete-conflicting-outputs

# Lancer l'application
flutter run
```

### Backend Django

```bash
cd backend

# Créer un environnement virtuel
python -m venv venv

# Activer l'environnement virtuel
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Installer les dépendances
pip install -r requirements.txt

# Créer le fichier .env
cp .env.example .env

# Éditer .env avec vos configurations

# Créer la base de données PostgreSQL
createdb hanseco_db

# Appliquer les migrations
python manage.py migrate

# Créer un superuser
python manage.py createsuperuser

# Lancer le serveur
python manage.py runserver
```

## 🔧 Configuration des Paiements

### MVola
```env
MVOLA_API_KEY=votre_clé_api
MVOLA_SECRET_KEY=votre_clé_secrète
MVOLA_MERCHANT_ID=votre_merchant_id
```

### Airtel Money
```env
AIRTEL_API_KEY=votre_clé_api
AIRTEL_SECRET_KEY=votre_clé_secrète
AIRTEL_MERCHANT_ID=votre_merchant_id
```

### Orange Money
```env
ORANGE_API_KEY=votre_clé_api
ORANGE_SECRET_KEY=votre_clé_secrète
ORANGE_MERCHANT_ID=votre_merchant_id
```

### PayPal
```env
PAYPAL_CLIENT_ID=votre_client_id
PAYPAL_CLIENT_SECRET=votre_client_secret
PAYPAL_MODE=sandbox  # ou 'live' en production
```

### Stripe
```env
STRIPE_PUBLISHABLE_KEY=votre_clé_publique
STRIPE_SECRET_KEY=votre_clé_secrète
```

## 🏗️ Fonctionnalités Implémentées

### ✅ Complètes
- [x] Architecture Clean (Frontend)
- [x] Feature-First Structure
- [x] Authentification JWT
- [x] Navigation avec go_router
- [x] Thème personnalisé
- [x] Configuration Django REST Framework
- [x] Modèles User, Product, Category

### 🚧 À Compléter

#### Frontend
- [ ] Implémenter la logique complète des providers Riverpod pour Products, Cart
- [ ] Ajouter la pagination pour les listes de produits
- [ ] Implémenter le cache local avec Hive
- [ ] Ajouter l'internationalisation (FR/MG)
- [ ] Tests unitaires et d'intégration
- [ ] Gestion offline-first

#### Backend
- [ ] Compléter les modèles Cart, Order, Payment
- [ ] Implémenter les endpoints de paiement (Mvola, Airtel, Orange, PayPal, Stripe)
- [ ] Ajouter les webhooks pour les confirmations de paiement
- [ ] Implémenter la recherche avancée de produits
- [ ] Ajouter un système de notifications
- [ ] Tests API
- [ ] Documentation API (Swagger/OpenAPI)

## 📝 Endpoints API Principaux

### Authentification
```
POST /api/auth/register/          - Inscription
POST /api/auth/login/             - Connexion
POST /api/auth/refresh/           - Rafraîchir le token
GET  /api/auth/me/                - Profil utilisateur
```

### Produits
```
GET    /api/products/             - Liste des produits
GET    /api/products/<slug>/      - Détail d'un produit
GET    /api/products/categories/  - Liste des catégories
```

### Panier
```
GET    /api/cart/                 - Voir le panier
POST   /api/cart/add/             - Ajouter au panier
PUT    /api/cart/update/          - Mettre à jour le panier
DELETE /api/cart/remove/          - Retirer du panier
```

### Commandes
```
GET    /api/orders/               - Historique des commandes
POST   /api/orders/create/        - Créer une commande
GET    /api/orders/<id>/          - Détail d'une commande
```

### Paiements
```
POST   /api/payments/mvola/       - Paiement MVola
POST   /api/payments/airtel/      - Paiement Airtel Money
POST   /api/payments/orange/      - Paiement Orange Money
POST   /api/payments/paypal/      - Paiement PayPal
POST   /api/payments/stripe/      - Paiement Stripe
POST   /api/payments/webhook/     - Webhook pour confirmations
```

## 🧪 Tests

### Frontend
```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/
```

### Backend
```bash
# Tests
pytest

# Avec couverture
pytest --cov=hanseco_backend
```

## 🚀 Déploiement

### Frontend
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Backend
```bash
# Collecter les fichiers statiques
python manage.py collectstatic

# Avec Gunicorn
gunicorn hanseco_backend.core.wsgi:application --bind 0.0.0.0:8000
```

## 📚 Documentation Technique

### Clean Architecture (Frontend)
Chaque feature suit la Clean Architecture:
- **Domain**: Entités et cas d'utilisation (logique métier pure)
- **Data**: Repositories et sources de données
- **Presentation**: UI et gestion d'état (Riverpod)

### Bonnes Pratiques
- Séparation des responsabilités
- Code modulaire et testable
- Widgets réutilisables (Atomic Design)
- Gestion sécurisée des tokens
- Validation des entrées utilisateur

## 🤝 Contribution

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit (`git commit -m 'Add some AmazingFeature'`)
4. Push (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT.

## 👥 Auteurs

- Votre Nom - [@votre_github](https://github.com/votre_github)

## 🙏 Remerciements

- Flutter Team
- Django & DRF Community
- Communauté des développeurs malgaches
