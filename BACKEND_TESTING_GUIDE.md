# Guide de Test du Backend HansEco

Ce guide explique comment tester tous les endpoints du backend Django.

## 📋 Table des Matières

1. [Configuration Initiale](#configuration-initiale)
2. [Tests avec cURL](#tests-avec-curl)
3. [Tests avec Postman](#tests-avec-postman)
4. [Tests avec Django REST Framework](#tests-avec-django-rest-framework)
5. [Tests Unitaires avec Pytest](#tests-unitaires-avec-pytest)
6. [Tests des Endpoints OAuth2](#tests-des-endpoints-oauth2)

---

## 🔧 Configuration Initiale

### 1. Installer les dépendances

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
```

### 2. Configurer la base de données

```bash
# Créer le fichier .env
cp .env.example .env

# Éditer .env avec vos configurations
# Pour les tests, vous pouvez utiliser SQLite au lieu de PostgreSQL
```

**Modifier temporairement pour SQLite (tests):**

```python
# backend/hanseco_backend/core/settings/development.py
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
```

### 3. Appliquer les migrations

```bash
python manage.py makemigrations
python manage.py migrate
```

### 4. Créer un superutilisateur

```bash
python manage.py createsuperuser

# Suivez les instructions:
# Username: admin
# Email: admin@hanseco.com
# Password: admin123 (pour les tests)
```

### 5. Lancer le serveur

```bash
python manage.py runserver

# Le serveur démarre sur http://127.0.0.1:8000/
```

---

## 🌐 Tests avec cURL

### Test 1: Vérifier que le serveur fonctionne

```bash
curl http://localhost:8000/admin/
```

**Résultat attendu:** HTML de la page admin Django

### Test 2: Inscription d'un utilisateur

```bash
curl -X POST http://localhost:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test123456",
    "first_name": "John",
    "last_name": "Doe"
  }'
```

**Résultat attendu:**
```json
{
  "user": {
    "id": 1,
    "email": "test@example.com",
    "first_name": "John",
    "last_name": "Doe"
  },
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbG...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbG..."
}
```

### Test 3: Connexion avec email/password

```bash
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test123456"
  }'
```

**Résultat attendu:** Même structure que l'inscription

### Test 4: Obtenir le profil utilisateur (avec token)

```bash
# Remplacez YOUR_ACCESS_TOKEN par le token reçu
curl http://localhost:8000/api/auth/me/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Résultat attendu:**
```json
{
  "id": 1,
  "email": "test@example.com",
  "first_name": "John",
  "last_name": "Doe"
}
```

### Test 5: Rafraîchir le token

```bash
curl -X POST http://localhost:8000/api/oauth/token/refresh/ \
  -H "Content-Type: application/json" \
  -d '{
    "refresh": "YOUR_REFRESH_TOKEN"
  }'
```

**Résultat attendu:**
```json
{
  "access": "NEW_ACCESS_TOKEN"
}
```

### Test 6: Lister les produits

```bash
curl http://localhost:8000/api/products/
```

### Test 7: Obtenir un produit spécifique

```bash
curl http://localhost:8000/api/products/product-slug/
```

---

## 📮 Tests avec Postman

### Configuration Postman

1. **Télécharger Postman**: https://www.postman.com/downloads/
2. **Créer une nouvelle collection**: "HansEco API Tests"

### Collection Postman - Variables d'environnement

Créez un environnement "HansEco Local":

```
BASE_URL: http://localhost:8000
ACCESS_TOKEN: (sera rempli automatiquement)
REFRESH_TOKEN: (sera rempli automatiquement)
```

### Endpoints à tester

#### 1. **POST** Register
- URL: `{{BASE_URL}}/api/auth/register/`
- Body (JSON):
```json
{
  "email": "postman@test.com",
  "password": "Postman123",
  "first_name": "Postman",
  "last_name": "Test"
}
```
- Tests (onglet Tests):
```javascript
pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
});

pm.test("Response has access token", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.access_token).to.exist;
    pm.environment.set("ACCESS_TOKEN", jsonData.access_token);
    pm.environment.set("REFRESH_TOKEN", jsonData.refresh_token);
});
```

#### 2. **POST** Login
- URL: `{{BASE_URL}}/api/auth/login/`
- Body (JSON):
```json
{
  "email": "postman@test.com",
  "password": "Postman123"
}
```
- Tests:
```javascript
pm.test("Login successful", function () {
    pm.response.to.have.status(200);
    var jsonData = pm.response.json();
    pm.environment.set("ACCESS_TOKEN", jsonData.access_token);
    pm.environment.set("REFRESH_TOKEN", jsonData.refresh_token);
});
```

#### 3. **GET** User Profile
- URL: `{{BASE_URL}}/api/auth/me/`
- Headers:
  - `Authorization`: `Bearer {{ACCESS_TOKEN}}`
- Tests:
```javascript
pm.test("User profile retrieved", function () {
    pm.response.to.have.status(200);
    var jsonData = pm.response.json();
    pm.expect(jsonData.email).to.eql("postman@test.com");
});
```

#### 4. **POST** Refresh Token
- URL: `{{BASE_URL}}/api/oauth/token/refresh/`
- Body (JSON):
```json
{
  "refresh": "{{REFRESH_TOKEN}}"
}
```
- Tests:
```javascript
pm.test("Token refreshed", function () {
    pm.response.to.have.status(200);
    var jsonData = pm.response.json();
    pm.environment.set("ACCESS_TOKEN", jsonData.access);
});
```

#### 5. **GET** Products List
- URL: `{{BASE_URL}}/api/products/`
- Tests:
```javascript
pm.test("Products retrieved", function () {
    pm.response.to.have.status(200);
    var jsonData = pm.response.json();
    pm.expect(jsonData.results).to.be.an('array');
});
```

---

## 🧪 Tests avec Django REST Framework (Browsable API)

### Accéder à l'API navigable

1. **Ouvrir dans le navigateur**: http://localhost:8000/api/

2. **Endpoints disponibles:**
   - http://localhost:8000/api/auth/register/
   - http://localhost:8000/api/auth/login/
   - http://localhost:8000/api/auth/me/
   - http://localhost:8000/api/oauth/google/
   - http://localhost:8000/api/oauth/facebook/
   - http://localhost:8000/api/products/
   - http://localhost:8000/api/cart/
   - http://localhost:8000/api/orders/

3. **Tester avec l'interface:**
   - Cliquez sur un endpoint
   - Remplissez le formulaire en bas de page
   - Cliquez sur "POST" ou "GET"

---

## 🔬 Tests Unitaires avec Pytest

### 1. Créer le fichier de tests

Créez `backend/hanseco_backend/apps/oauth/tests.py`:

```python
import pytest
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient
from rest_framework import status
from unittest.mock import patch, MagicMock

User = get_user_model()


@pytest.fixture
def api_client():
    return APIClient()


@pytest.fixture
def user_data():
    return {
        'email': 'test@example.com',
        'password': 'TestPassword123',
        'first_name': 'Test',
        'last_name': 'User'
    }


@pytest.fixture
def create_user(user_data):
    user = User.objects.create_user(
        username=user_data['email'].split('@')[0],
        email=user_data['email'],
        password=user_data['password'],
        first_name=user_data['first_name'],
        last_name=user_data['last_name']
    )
    return user


@pytest.mark.django_db
class TestAuthentication:

    def test_user_registration(self, api_client, user_data):
        """Test user registration endpoint"""
        response = api_client.post('/api/auth/register/', user_data)

        assert response.status_code == status.HTTP_201_CREATED
        assert 'access_token' in response.data
        assert 'refresh_token' in response.data
        assert response.data['user']['email'] == user_data['email']

    def test_user_login(self, api_client, create_user, user_data):
        """Test user login endpoint"""
        login_data = {
            'email': user_data['email'],
            'password': user_data['password']
        }
        response = api_client.post('/api/auth/login/', login_data)

        assert response.status_code == status.HTTP_200_OK
        assert 'access_token' in response.data
        assert 'refresh_token' in response.data

    def test_get_user_profile(self, api_client, create_user):
        """Test getting user profile with JWT token"""
        # Login first to get token
        login_data = {
            'email': create_user.email,
            'password': 'TestPassword123'
        }
        login_response = api_client.post('/api/auth/login/', login_data)
        token = login_response.data['access_token']

        # Get profile with token
        api_client.credentials(HTTP_AUTHORIZATION=f'Bearer {token}')
        response = api_client.get('/api/auth/me/')

        assert response.status_code == status.HTTP_200_OK
        assert response.data['email'] == create_user.email

    def test_token_refresh(self, api_client, create_user, user_data):
        """Test JWT token refresh"""
        # Login to get refresh token
        login_data = {
            'email': user_data['email'],
            'password': user_data['password']
        }
        login_response = api_client.post('/api/auth/login/', login_data)
        refresh_token = login_response.data['refresh_token']

        # Refresh the token
        response = api_client.post(
            '/api/oauth/token/refresh/',
            {'refresh': refresh_token}
        )

        assert response.status_code == status.HTTP_200_OK
        assert 'access' in response.data


@pytest.mark.django_db
class TestOAuthGoogle:

    @patch('hanseco_backend.apps.oauth.views.id_token')
    def test_google_oauth_new_user(self, mock_id_token, api_client):
        """Test Google OAuth for new user"""
        # Mock Google token verification
        mock_id_token.verify_oauth2_token.return_value = {
            'email': 'google@test.com',
            'given_name': 'Google',
            'family_name': 'User'
        }

        response = api_client.post(
            '/api/oauth/google/',
            {'auth_token': 'fake_google_token'}
        )

        assert response.status_code == status.HTTP_200_OK
        assert 'access_token' in response.data
        assert response.data['is_new_user'] == True
        assert response.data['user']['email'] == 'google@test.com'

    @patch('hanseco_backend.apps.oauth.views.id_token')
    def test_google_oauth_existing_user(self, mock_id_token, api_client):
        """Test Google OAuth for existing user"""
        # Create existing user
        User.objects.create_user(
            username='google',
            email='google@test.com',
            first_name='Google',
            last_name='User'
        )

        # Mock Google token verification
        mock_id_token.verify_oauth2_token.return_value = {
            'email': 'google@test.com',
            'given_name': 'Google',
            'family_name': 'User'
        }

        response = api_client.post(
            '/api/oauth/google/',
            {'auth_token': 'fake_google_token'}
        )

        assert response.status_code == status.HTTP_200_OK
        assert response.data['is_new_user'] == False


@pytest.mark.django_db
class TestOAuthFacebook:

    @patch('hanseco_backend.apps.oauth.views.requests')
    def test_facebook_oauth_new_user(self, mock_requests, api_client):
        """Test Facebook OAuth for new user"""
        # Mock Facebook Graph API response
        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_response.json.return_value = {
            'id': '123456',
            'email': 'facebook@test.com',
            'first_name': 'Facebook',
            'last_name': 'User'
        }
        mock_requests.get.return_value = mock_response

        response = api_client.post(
            '/api/oauth/facebook/',
            {'auth_token': 'fake_facebook_token'}
        )

        assert response.status_code == status.HTTP_200_OK
        assert 'access_token' in response.data
        assert response.data['is_new_user'] == True
        assert response.data['user']['email'] == 'facebook@test.com'
```

### 2. Lancer les tests

```bash
# Installer pytest-django si ce n'est pas fait
pip install pytest-django

# Créer pytest.ini à la racine du projet backend
cat > pytest.ini << EOF
[pytest]
DJANGO_SETTINGS_MODULE = hanseco_backend.core.settings.development
python_files = tests.py test_*.py *_tests.py
EOF

# Lancer tous les tests
pytest

# Lancer avec verbose
pytest -v

# Lancer avec couverture
pytest --cov=hanseco_backend

# Lancer un test spécifique
pytest hanseco_backend/apps/oauth/tests.py::TestAuthentication::test_user_registration
```

---

## 🔍 Tests des Endpoints OAuth2

### Test Google OAuth2 (avec un vrai token)

Pour tester avec un vrai token Google, vous devez:

1. **Obtenir un ID Token Google**

Utilisez ce code JavaScript dans la console du navigateur sur une page avec Google Sign-In:

```javascript
gapi.auth2.getAuthInstance().currentUser.get().getAuthResponse().id_token
```

2. **Tester avec cURL**

```bash
curl -X POST http://localhost:8000/api/oauth/google/ \
  -H "Content-Type: application/json" \
  -d '{
    "auth_token": "PASTE_YOUR_GOOGLE_ID_TOKEN_HERE"
  }'
```

### Test Facebook OAuth2 (avec un vrai token)

1. **Obtenir un Access Token Facebook**

Utilisez [Facebook Access Token Tool](https://developers.facebook.com/tools/accesstoken/)

2. **Tester avec cURL**

```bash
curl -X POST http://localhost:8000/api/oauth/facebook/ \
  -H "Content-Type: application/json" \
  -d '{
    "auth_token": "PASTE_YOUR_FACEBOOK_ACCESS_TOKEN_HERE"
  }'
```

---

## 📊 Script de Test Complet

Créez `backend/test_api.py`:

```python
#!/usr/bin/env python
"""
Script de test complet de l'API HansEco
Usage: python test_api.py
"""

import requests
import json

BASE_URL = "http://localhost:8000"

def print_response(response):
    """Pretty print response"""
    print(f"Status: {response.status_code}")
    try:
        print(json.dumps(response.json(), indent=2))
    except:
        print(response.text)
    print("-" * 50)

def test_register():
    """Test user registration"""
    print("\n🧪 Test 1: User Registration")
    url = f"{BASE_URL}/api/auth/register/"
    data = {
        "email": "script@test.com",
        "password": "ScriptTest123",
        "first_name": "Script",
        "last_name": "Test"
    }
    response = requests.post(url, json=data)
    print_response(response)
    return response.json() if response.status_code in [200, 201] else None

def test_login():
    """Test user login"""
    print("\n🧪 Test 2: User Login")
    url = f"{BASE_URL}/api/auth/login/"
    data = {
        "email": "script@test.com",
        "password": "ScriptTest123"
    }
    response = requests.post(url, json=data)
    print_response(response)
    return response.json() if response.status_code == 200 else None

def test_profile(access_token):
    """Test getting user profile"""
    print("\n🧪 Test 3: Get User Profile")
    url = f"{BASE_URL}/api/auth/me/"
    headers = {"Authorization": f"Bearer {access_token}"}
    response = requests.get(url, headers=headers)
    print_response(response)

def test_refresh_token(refresh_token):
    """Test token refresh"""
    print("\n🧪 Test 4: Refresh Token")
    url = f"{BASE_URL}/api/oauth/token/refresh/"
    data = {"refresh": refresh_token}
    response = requests.post(url, json=data)
    print_response(response)
    return response.json() if response.status_code == 200 else None

def test_products():
    """Test getting products"""
    print("\n🧪 Test 5: Get Products")
    url = f"{BASE_URL}/api/products/"
    response = requests.get(url)
    print_response(response)

def main():
    print("="*50)
    print("🚀 HansEco API Test Suite")
    print("="*50)

    # Test 1: Register
    register_data = test_register()

    # Test 2: Login
    login_data = test_login()

    if login_data and 'access_token' in login_data:
        # Test 3: Profile
        test_profile(login_data['access_token'])

        # Test 4: Refresh Token
        if 'refresh_token' in login_data:
            new_tokens = test_refresh_token(login_data['refresh_token'])
            if new_tokens and 'access' in new_tokens:
                print(f"\n✅ New access token: {new_tokens['access'][:50]}...")

    # Test 5: Products
    test_products()

    print("\n" + "="*50)
    print("✅ Tests terminés!")
    print("="*50)

if __name__ == "__main__":
    main()
```

**Lancer le script:**

```bash
python test_api.py
```

---

## 📝 Checklist de Tests

### Tests Essentiels

- [ ] Le serveur démarre sans erreur
- [ ] L'admin Django est accessible
- [ ] Inscription d'un nouvel utilisateur
- [ ] Connexion avec email/password
- [ ] Récupération du profil utilisateur
- [ ] Rafraîchissement du token JWT
- [ ] Listing des produits
- [ ] Détail d'un produit
- [ ] Google OAuth2 (avec mock ou vrai token)
- [ ] Facebook OAuth2 (avec mock ou vrai token)

### Tests Avancés

- [ ] Token expiré retourne 401
- [ ] Refresh token invalide retourne erreur
- [ ] Double inscription avec même email échoue
- [ ] Login avec mauvais password échoue
- [ ] Endpoints protégés sans token retournent 401
- [ ] Validation des champs (email, password, etc.)
- [ ] CORS headers présents
- [ ] Pagination fonctionne
- [ ] Filtres de produits fonctionnent

---

## 🐛 Dépannage

### Erreur: Connection refused

**Problème:** Le serveur n'est pas démarré

**Solution:**
```bash
python manage.py runserver
```

### Erreur: No such table

**Problème:** Migrations non appliquées

**Solution:**
```bash
python manage.py migrate
```

### Erreur 401 Unauthorized

**Problème:** Token manquant ou invalide

**Solution:**
- Vérifiez que le header `Authorization: Bearer TOKEN` est présent
- Vérifiez que le token n'est pas expiré
- Rafraîchissez le token si nécessaire

### Erreur CORS

**Problème:** Frontend ne peut pas accéder à l'API

**Solution:**
Vérifiez `CORS_ALLOWED_ORIGINS` dans `.env`:
```env
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080,http://127.0.0.1:8080
```

---

## 📚 Ressources

- [Django REST Framework Testing](https://www.django-rest-framework.org/api-guide/testing/)
- [Pytest Documentation](https://docs.pytest.org/)
- [Postman Learning Center](https://learning.postman.com/)
- [cURL Documentation](https://curl.se/docs/)

---

**Bonne chance avec vos tests! 🚀**
