# Résolution Erreur 400: redirect_uri_mismatch

## Problème

```
Accès bloqué : la demande de cette appli n'est pas valide
Erreur 400 : redirect_uri_mismatch
```

Cette erreur signifie que l'URI de redirection utilisé par votre application Flutter n'est pas autorisé dans Google Cloud Console.

## Solution

### Étape 1: Identifier l'URI de redirection utilisé

L'erreur Google vous montre normalement l'URI qui a été rejeté. Il ressemble généralement à:
- `http://localhost:XXXXX` (où XXXXX est un port aléatoire)
- Ou il peut contenir un chemin comme `http://localhost:XXXXX/auth/callback`

**NOTEZ CET URI EXACT** affiché dans l'erreur.

### Étape 2: Configurer Google Cloud Console

1. **Allez sur Google Cloud Console**:
   ```
   https://console.cloud.google.com/apis/credentials
   ```

2. **Sélectionnez votre projet** (celui qui contient votre OAuth Client ID)

3. **Trouvez votre OAuth 2.0 Client ID**:
   - Cherchez le Client ID qui commence par: `989504216135-...`
   - Cliquez sur l'icône ✏️ (crayon) pour l'éditer

4. **Section "Origines JavaScript autorisées"** - Ajoutez:
   ```
   http://localhost
   http://localhost:3000
   http://localhost:8080
   http://localhost:50000
   http://localhost:55000
   http://localhost:60000
   http://localhost:65535
   http://127.0.0.1
   http://127.0.0.1:3000
   http://127.0.0.1:8080
   ```

   **Important**: Flutter Web utilise des ports aléatoires entre 50000-65535. Ajoutez plusieurs ports ou le port exact que vous voyez dans l'erreur.

5. **Section "URI de redirection autorisés"** - Ajoutez:
   ```
   http://localhost
   http://localhost/
   http://localhost:3000
   http://localhost:3000/
   http://localhost:8080
   http://localhost:8080/
   http://127.0.0.1
   http://127.0.0.1/
   http://127.0.0.1:3000
   http://127.0.0.1:3000/
   http://127.0.0.1:8080
   http://127.0.0.1:8080/
   ```

   **Si l'erreur vous montre un URI spécifique**, ajoutez-le EXACTEMENT comme affiché.

6. **Cliquez sur "Enregistrer"** en bas de la page

### Étape 3: Attendre la propagation

⏱️ **IMPORTANT**: Les changements peuvent prendre **5-10 minutes** pour se propager dans les serveurs Google.

Attendez quelques minutes avant de réessayer.

### Étape 4: Réessayer la connexion

1. Fermez complètement votre navigateur (toutes les fenêtres)
2. Relancez l'application Flutter:
   ```bash
   .\start_flutter_app.bat
   ```
3. Essayez à nouveau de vous connecter avec Google

---

## Solution Alternative: Forcer un Port Spécifique

Au lieu d'utiliser un port aléatoire, vous pouvez forcer Flutter à utiliser un port fixe:

### Option 1: Utiliser le port 8080

```bash
cd hanseco_app
flutter run -d chrome --web-port=8080
```

Puis dans Google Cloud Console, assurez-vous que ces URIs sont configurés:
```
http://localhost:8080
http://localhost:8080/
```

### Option 2: Utiliser le port 3000

```bash
cd hanseco_app
flutter run -d chrome --web-port=3000
```

Puis configurez:
```
http://localhost:3000
http://localhost:3000/
```

### Créer un script avec port fixe

J'ai créé un script qui utilise le port 8080 par défaut.

---

## Vérification Complète

### Configuration Minimale Requise

Pour que OAuth Google fonctionne, vous DEVEZ avoir dans Google Cloud Console:

#### Origines JavaScript autorisées (minimum):
```
http://localhost:8080
http://127.0.0.1:8080
```

#### URI de redirection autorisés (minimum):
```
http://localhost:8080
http://localhost:8080/
http://127.0.0.1:8080
http://127.0.0.1:8080/
```

---

## Pourquoi cette erreur se produit?

### Avec Flutter Web:
- Flutter Web démarre sur un port **aléatoire** (50000-65535) par défaut
- Google OAuth nécessite que TOUS les URIs de redirection soient pré-autorisés
- Si le port n'est pas dans la liste, Google rejette la demande

### Solutions:
1. **Ajouter tous les ports possibles** (fastidieux)
2. **Utiliser un port fixe** avec `--web-port=8080` (recommandé)
3. **Utiliser un domaine** en production

---

## Checklist de Dépannage

- [ ] Client ID est correct dans `hanseco_app/.env` et `web/index.html`
- [ ] Client ID est le même que celui configuré dans Google Cloud Console
- [ ] Les origines JavaScript incluent `http://localhost:8080`
- [ ] Les URI de redirection incluent `http://localhost:8080` ET `http://localhost:8080/`
- [ ] Vous avez attendu 5-10 minutes après avoir sauvegardé les changements
- [ ] Vous avez fermé et rouvert le navigateur
- [ ] Vous utilisez le bon projet dans Google Cloud Console

---

## Si le problème persiste

### 1. Vérifiez l'erreur détaillée

L'erreur Google affiche normalement:
```
The redirect URI in the request: http://localhost:XXXXX
does not match the ones authorized for the OAuth client.
```

Copiez l'URI EXACT et ajoutez-le dans Google Cloud Console.

### 2. Vérifiez le bon projet

Assurez-vous que vous éditez le bon OAuth Client ID (celui qui correspond à `989504216135-...`)

### 3. Vérifiez les cookies

- Effacez les cookies du navigateur
- Essayez en navigation privée
- Essayez un autre navigateur

### 4. Vérifiez que l'API est activée

Dans Google Cloud Console:
1. Allez à **APIs & Services** > **Library**
2. Recherchez "Google Identity"
3. Assurez-vous qu'elle est activée

---

## Script de Démarrage avec Port Fixe

Utilisez le nouveau script créé:
```bash
.\start_flutter_web_8080.bat
```

Ce script démarre toujours sur le port 8080, ce qui évite les problèmes de port aléatoire.
