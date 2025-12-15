# Configuration PostgreSQL - HansEco

Vous avez configuré PostgreSQL avec Neon ! Voici comment finaliser la configuration.

## ✅ Configuration Actuelle

**Base de données**: PostgreSQL sur Neon
**Connection string**: Configurée dans `backend/.env`
**Provider**: Neon (eastus2.azure)

---

## 🚀 Migration depuis SQLite

### Étape 1: Migrer la base de données

Exécutez le script de migration :

```bash
.\migrate_to_postgresql.bat
```

Ce script va :
1. ✅ Installer les dépendances PostgreSQL
2. ✅ Vérifier la connexion à Neon
3. ✅ Créer les tables dans PostgreSQL
4. ✅ Proposer de créer un superutilisateur

### Étape 2: Créer un superutilisateur

Si vous n'en avez pas créé pendant la migration :

```bash
cd backend
venv\Scripts\activate.bat
python manage.py createsuperuser
```

Exemple :
- Email: `admin@hanseco.com`
- Password: `admin123`

### Étape 3: Démarrer le backend

```bash
.\start_backend.bat
```

Vous devriez voir :
```
✅ Using PostgreSQL from DATABASE_URL
```

---

## 🔍 Vérification

### Tester la connexion PostgreSQL

```bash
cd backend
venv\Scripts\activate.bat
python manage.py shell
```

Dans le shell Python :
```python
from django.db import connection
print("Database:", connection.settings_dict['NAME'])
print("Host:", connection.settings_dict['HOST'])
print("Engine:", connection.settings_dict['ENGINE'])
```

Vous devriez voir :
- Database: `hanseco`
- Host: `ep-bold-dawn-a8c6i3pn-pooler.eastus2.azure.neon.tech`
- Engine: `django.db.backends.postgresql`

### Vérifier les tables créées

```bash
python manage.py dbshell
```

Puis dans le shell PostgreSQL :
```sql
\dt  -- Liste toutes les tables
\q   -- Quitter
```

---

## 📊 Informations Neon

### Limites du plan gratuit

✅ **3 GB** de stockage
✅ **3 GB** de transfert/mois
✅ **Connexions illimitées**
✅ **PostgreSQL 16**
✅ **1 projet actif**

### Dashboard Neon

Accédez à votre dashboard :
```
https://console.neon.tech/
```

Vous pouvez y :
- Voir les métriques de la DB
- Gérer les connexions
- Faire des backups
- Monitorer les performances

---

## 🔄 Basculer entre SQLite et PostgreSQL

### Utiliser PostgreSQL (par défaut maintenant)

Dans `backend/.env`, gardez :
```env
DATABASE_URL=postgresql://neondb_owner:npg_crGAJ52EtTWY@ep-bold-dawn-a8c6i3pn-pooler.eastus2.azure.neon.tech/hanseco?sslmode=require&channel_binding=require
```

### Revenir temporairement à SQLite

Commentez DATABASE_URL dans `.env` :
```env
# DATABASE_URL=postgresql://...
```

Le système utilisera automatiquement SQLite.

---

## 🛠️ Commandes Utiles

### Migrations

```bash
# Créer des migrations
python manage.py makemigrations

# Appliquer les migrations
python manage.py migrate

# Voir les migrations
python manage.py showmigrations
```

### Données

```bash
# Créer un superutilisateur
python manage.py createsuperuser

# Shell Django
python manage.py shell

# Shell PostgreSQL direct
python manage.py dbshell
```

### Backup & Restore

**Backup** (depuis PostgreSQL vers fichier) :
```bash
python manage.py dumpdata > backup.json
```

**Restore** (depuis fichier vers PostgreSQL) :
```bash
python manage.py loaddata backup.json
```

---

## 📦 Migrer les données depuis SQLite

Si vous aviez des données dans SQLite et voulez les transférer :

### Option 1: Django dumpdata/loaddata

**Étape 1**: Avec SQLite actif (commentez DATABASE_URL) :
```bash
python manage.py dumpdata > sqlite_backup.json
```

**Étape 2**: Avec PostgreSQL actif (décommentez DATABASE_URL) :
```bash
python manage.py migrate  # Créer les tables
python manage.py loaddata sqlite_backup.json
```

### Option 2: Créer manuellement

Si vous aviez peu de données, recréez-les :
1. Produits via admin Django
2. Utilisateurs via `createsuperuser`
3. Autres données via l'interface

---

## 🔒 Sécurité

### Variables d'environnement sensibles

Votre `.env` contient des credentials :
- ✅ Ajoutez `.env` au `.gitignore`
- ✅ Ne committez JAMAIS les credentials
- ✅ Utilisez `.env.example` pour la documentation

### Régénérer les credentials Neon

Si vos credentials sont compromis :
1. Allez sur https://console.neon.tech/
2. Sélectionnez votre projet
3. Settings → Reset password
4. Mettez à jour `DATABASE_URL` dans `.env`

---

## 🚀 Prochaines Étapes

1. ✅ Migrer vers PostgreSQL (ce que vous venez de faire)
2. 📝 Créer des données de test
3. 🧪 Tester l'application avec PostgreSQL
4. 🌐 Déployer (Neon est prêt pour la production !)

---

## 🐛 Dépannage

### Erreur: "could not connect to server"

**Cause**: Impossible de se connecter à Neon

**Solutions**:
1. Vérifiez votre connexion internet
2. Vérifiez que DATABASE_URL est correcte
3. Testez la connexion avec `python manage.py check`

### Erreur: "password authentication failed"

**Cause**: Mauvais credentials

**Solutions**:
1. Copiez-collez DATABASE_URL depuis Neon dashboard
2. Vérifiez qu'il n'y a pas d'espaces dans l'.env
3. Redémarrez le backend

### Erreur: "relation does not exist"

**Cause**: Tables pas encore créées

**Solution**:
```bash
python manage.py migrate
```

### Performance lente

**Cause**: Serveur Neon gratuit en pause

**Solution**:
La première requête peut être lente (réveil du serveur). Les suivantes seront rapides.

---

## 📊 Monitoring

### Voir les logs Neon

Sur le dashboard Neon, allez dans "Monitoring" pour voir :
- Connexions actives
- Requêtes lentes
- Utilisation de stockage
- Bande passante

### Logs Django

```bash
# Voir les requêtes SQL
python manage.py runserver --verbosity 2
```

---

## ✅ Checklist Finale

- [ ] DATABASE_URL configurée dans `.env`
- [ ] Migrations exécutées (`migrate_to_postgresql.bat`)
- [ ] Superutilisateur créé
- [ ] Backend démarre avec "✅ Using PostgreSQL"
- [ ] Admin Django accessible (http://localhost:8000/admin)
- [ ] Peut créer/modifier des données
- [ ] Frontend se connecte au backend PostgreSQL

Une fois tout coché, votre app est prête avec PostgreSQL ! 🎉
