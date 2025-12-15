# Solution Alternative - Problème People API

## Si l'activation de People API ne fonctionne toujours pas

Il y a plusieurs raisons possibles pour lesquelles l'API ne s'active pas:

### Raison 1: Compte Google gratuit avec limitations

Certains comptes Google gratuits ont des restrictions sur l'activation d'APIs.

**Solution**: Vérifiez votre compte Google Cloud:
- Allez sur: https://console.cloud.google.com/billing?project=989504216135
- Vérifiez si vous avez un compte de facturation actif
- Google Cloud offre $300 de crédits gratuits pour les nouveaux utilisateurs

### Raison 2: Délai de propagation très long

Parfois, Google prend plus de 15 minutes pour propager les changements.

**Solution**: Attendez jusqu'à 30 minutes et réessayez.

### Raison 3: Mauvais projet sélectionné

Vous pourriez avoir plusieurs projets Google Cloud.

**Solution**:
1. Allez sur: https://console.cloud.google.com/
2. En haut, cliquez sur le sélecteur de projet
3. Vérifiez que vous êtes sur le projet avec l'ID: **989504216135**
4. Si ce n'est pas le cas, créez les credentials OAuth dans le bon projet

---

## Solution de Contournement: Utiliser un nouveau projet

Si vraiment l'API ne s'active pas, créez un nouveau projet:

### Étape 1: Créer un nouveau projet

1. Allez sur: https://console.cloud.google.com/
2. Cliquez sur le sélecteur de projet en haut
3. Cliquez sur "Nouveau projet"
4. Nom: "HansEco-New"
5. Créez le projet

### Étape 2: Activer les APIs

Dans le nouveau projet:

1. **People API**: https://console.cloud.google.com/apis/library/people.googleapis.com
2. **Google Identity Toolkit**: https://console.cloud.google.com/apis/library/identitytoolkit.googleapis.com

### Étape 3: Créer les credentials OAuth

1. Allez sur: https://console.cloud.google.com/apis/credentials
2. Créez un nouveau OAuth 2.0 Client ID
3. Type: Web application
4. Origines JavaScript:
   - http://localhost:8080
   - http://localhost:3000
5. URI de redirection:
   - http://localhost:8080
   - http://localhost:8080/
   - http://localhost:3000
   - http://localhost:3000/

### Étape 4: Mettre à jour la configuration

Copiez le nouveau Client ID et Secret dans:
- `hanseco_app/.env`
- `hanseco_app/web/index.html`
- `backend/.env`

---

## Vérification Manuelle via API REST

Pour vérifier si l'API est vraiment activée, testez directement:

```bash
# Avec curl (nécessite un access token)
curl "https://people.googleapis.com/v1/people/me?personFields=names,emailAddresses" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

Si vous obtenez une erreur 403 "SERVICE_DISABLED", l'API n'est pas activée.

---

## Contact Google Cloud Support

Si rien ne fonctionne:

1. Allez sur: https://console.cloud.google.com/support
2. Créez un ticket de support
3. Mentionnez que vous ne pouvez pas activer People API
4. Fournissez votre Project ID: 989504216135

Pour les comptes gratuits, le support peut être limité, mais la communauté Google Cloud peut aider.

---

## Solution Temporaire: Test avec un autre compte Google

Pour vérifier si le problème vient de votre compte ou de la configuration:

1. Essayez de vous connecter avec un autre compte Google
2. Si ça fonctionne, le problème vient de votre compte Google spécifique
3. Si ça ne fonctionne pas, le problème est dans la configuration

---

## Logs Backend pour Diagnostic

Vérifiez aussi les logs du backend Django pour voir si l'erreur vient vraiment de People API ou d'autre chose:

```bash
cd backend
venv\Scripts\activate.bat
python manage.py runserver
```

Regardez les logs quand vous tentez de vous connecter.
