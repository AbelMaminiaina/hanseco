# Checklist Complète OAuth Google - HansEco

Utilisez cette checklist pour vous assurer que tout est correctement configuré.

## ✅ Checklist de Configuration

### 1. Google Cloud Console - Projet

- [ ] Projet créé dans Google Cloud Console
- [ ] Projet ID: `989504216135`
- [ ] Nom du projet noté

### 2. Google Cloud Console - APIs

- [ ] **Google People API** activée
  - https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=989504216135
  - Statut: Activée ✅

- [ ] **Google Identity Toolkit API** activée (optionnel mais recommandé)
  - https://console.developers.google.com/apis/api/identitytoolkit.googleapis.com/overview?project=989504216135

### 3. Google Cloud Console - OAuth Credentials

- [ ] OAuth 2.0 Client ID créé
- [ ] Type: **Web application**
- [ ] Client ID: `YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com` ✅
- [ ] Client Secret: `YOUR_GOOGLE_CLIENT_SECRET` ✅

#### Origines JavaScript autorisées

- [ ] `http://localhost:8080`
- [ ] `http://localhost:3000`
- [ ] `http://127.0.0.1:8080`
- [ ] `http://127.0.0.1:3000`

#### URI de redirection autorisés

- [ ] `http://localhost:8080`
- [ ] `http://localhost:8080/`
- [ ] `http://localhost:3000`
- [ ] `http://localhost:3000/`
- [ ] `http://127.0.0.1:8080`
- [ ] `http://127.0.0.1:8080/`
- [ ] `http://127.0.0.1:3000`
- [ ] `http://127.0.0.1:3000/`

### 4. Frontend Flutter - Configuration

- [ ] Client ID dans `hanseco_app/.env`:
  ```env
  GOOGLE_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com
  ```

- [ ] Meta tag dans `hanseco_app/web/index.html`:
  ```html
  <meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com">
  ```

- [ ] Script Google Sign-In dans `hanseco_app/web/index.html`:
  ```html
  <script src="https://accounts.google.com/gsi/client" async defer></script>
  ```

### 5. Backend Django - Configuration

- [ ] Client ID dans `backend/.env`:
  ```env
  GOOGLE_OAUTH_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com
  ```

- [ ] Client Secret dans `backend/.env`:
  ```env
  GOOGLE_OAUTH_CLIENT_SECRET=YOUR_GOOGLE_CLIENT_SECRET
  ```

- [ ] CORS configuré dans `backend/.env`:
  ```env
  CORS_ALLOWED_ORIGINS=http://localhost:8080,http://localhost:3000
  ```

### 6. Démarrage des Applications

- [ ] Backend Django démarré:
  ```bash
  .\start_backend.bat
  ```
  - Accessible sur: http://localhost:8000

- [ ] Frontend Flutter démarré sur port fixe:
  ```bash
  .\start_flutter_web_8080.bat
  ```
  - Accessible sur: http://localhost:8080

### 7. Test OAuth

- [ ] Page de login affichée
- [ ] Bouton "Sign in with Google" visible
- [ ] Clic sur le bouton ouvre la popup Google
- [ ] Sélection du compte Google
- [ ] ✅ Pas d'erreur "redirect_uri_mismatch"
- [ ] ✅ Pas d'erreur "People API not enabled"
- [ ] ✅ Redirection vers l'application après authentification
- [ ] ✅ Utilisateur connecté avec nom et email affichés

---

## 🐛 Dépannage

### Erreur: "redirect_uri_mismatch"

**Cause**: URI de redirection non autorisé

**Solution**:
1. Vérifiez les URIs de redirection dans Google Cloud Console
2. Assurez-vous que `http://localhost:8080/` est dans la liste
3. Attendez 5 minutes après modification
4. Réessayez

➡️ Voir: `fix_oauth_redirect_uri.md`

### Erreur: "People API has not been used"

**Cause**: Google People API non activée

**Solution**:
1. Activez l'API: https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=989504216135
2. Cliquez sur "ENABLE"
3. Attendez 2-5 minutes
4. Réessayez

➡️ Voir: `ENABLE_GOOGLE_PEOPLE_API.md`

### Erreur: "idpiframe_initialization_failed"

**Cause**: Configuration Client ID incorrecte ou cookies bloqués

**Solution**:
1. Vérifiez que le Client ID est identique dans `.env` et `index.html`
2. Effacez les cookies du navigateur
3. Essayez en navigation privée
4. Vérifiez les origines JavaScript dans Google Cloud Console

### Erreur: "Backend authentication failed"

**Cause**: Backend non démarré ou CORS mal configuré

**Solution**:
1. Vérifiez que le backend tourne: http://localhost:8000/api/
2. Vérifiez `CORS_ALLOWED_ORIGINS` dans `backend/.env`
3. Regardez les logs Django pour les erreurs

---

## 📝 Scripts Utiles

| Script | Description |
|--------|-------------|
| `verify_oauth_setup.bat` | Vérifie toute la configuration OAuth |
| `check_oauth_config.bat` | Contrôle détaillé de la config |
| `start_flutter_web_8080.bat` | Démarre Flutter sur port 8080 |
| `start_backend.bat` | Démarre le backend Django |
| `start_all.bat` | Démarre backend + frontend |

---

## ✨ Configuration Complète

Si tous les éléments de cette checklist sont cochés ✅, votre OAuth Google devrait fonctionner parfaitement !

**Test Final**:
1. Lancez `.\start_all.bat`
2. Allez sur http://localhost:8080
3. Cliquez sur "Sign in with Google"
4. Connectez-vous avec votre compte Google
5. Vous devriez être redirigé vers l'app avec votre profil affiché

---

## 📞 Support

En cas de problème, vérifiez dans cet ordre:

1. ✅ Google People API activée
2. ✅ URIs de redirection configurés
3. ✅ Port 8080 utilisé (pas un port aléatoire)
4. ✅ Backend Django démarré
5. ✅ Cookies autorisés dans le navigateur

Pour plus de détails:
- `OAUTH_SETUP_GUIDE.md` - Guide complet
- `fix_oauth_redirect_uri.md` - Erreurs redirect_uri
- `ENABLE_GOOGLE_PEOPLE_API.md` - Activation People API
