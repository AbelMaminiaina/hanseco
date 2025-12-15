#!/usr/bin/env python
"""Script pour créer un superutilisateur Django"""
import os
import django
from dotenv import load_dotenv

# Charger les variables d'environnement
load_dotenv()

# Configuration Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'hanseco_backend.core.settings.development')
django.setup()

from django.contrib.auth import get_user_model

User = get_user_model()

# Paramètres du superutilisateur
username = 'admin'
email = 'admin@hanseco.com'
password = 'admin123'
first_name = 'Admin'
last_name = 'HansEco'

# Vérifier si l'utilisateur existe déjà
if User.objects.filter(username=username).exists():
    print(f"✅ Le superutilisateur {username} existe déjà!")
    user = User.objects.get(username=username)
    print(f"   - Username: {user.username}")
    print(f"   - Email: {user.email}")
    print(f"   - Nom: {user.first_name} {user.last_name}")
    print(f"   - Superuser: {user.is_superuser}")
else:
    # Créer le superutilisateur
    user = User.objects.create_superuser(
        username=username,
        email=email,
        password=password,
        first_name=first_name,
        last_name=last_name
    )
    print(f"✅ Superutilisateur créé avec succès!")
    print(f"   - Email: {email}")
    print(f"   - Password: {password}")
    print(f"   - Nom: {first_name} {last_name}")
    print()
    print("🔐 Vous pouvez maintenant vous connecter à:")
    print("   - Admin Django: http://localhost:8000/admin")
    print("   - Application Flutter: http://localhost:8080")
