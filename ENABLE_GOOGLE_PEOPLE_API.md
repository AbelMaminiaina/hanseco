# Activer Google People API

## Erreur Rencontrée

```
People API has not been used in project 989504216135 before or it is disabled.
```

## Solution Rapide

### Option 1: Lien Direct (Recommandé)

Cliquez sur ce lien pour activer directement l'API:

```
https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=989504216135
```

Puis cliquez sur le bouton **"ACTIVER"** ou **"ENABLE"**.

### Option 2: Manuellement

1. **Allez sur Google Cloud Console**:
   ```
   https://console.cloud.google.com/
   ```

2. **Sélectionnez votre projet** (989504216135)

3. **Allez dans APIs & Services > Library**:
   ```
   https://console.cloud.google.com/apis/library
   ```

4. **Recherchez "People API"** dans la barre de recherche

5. **Cliquez sur "Google People API"**

6. **Cliquez sur "ACTIVER" / "ENABLE"**

---

## Pourquoi cette API est nécessaire?

La **Google People API** permet à votre application de:
- Récupérer les informations du profil utilisateur (nom, email, photo)
- Obtenir les informations de base après l'authentification OAuth

Sans cette API, OAuth peut authentifier l'utilisateur mais ne peut pas récupérer ses informations.

---

## Autres APIs à activer pour HansEco

Pour une expérience complète, activez aussi ces APIs:

### APIs Recommandées

1. **Google People API** ✅ (obligatoire pour OAuth)
   - https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=989504216135

2. **Google+ API** (optionnel, pour profils enrichis)
   - https://console.developers.google.com/apis/api/plus.googleapis.com/overview?project=989504216135

3. **Google Identity Toolkit API** (recommandé)
   - https://console.developers.google.com/apis/api/identitytoolkit.googleapis.com/overview?project=989504216135

---

## Vérification

Après activation, vous pouvez vérifier que l'API est activée:

1. Allez sur: https://console.cloud.google.com/apis/dashboard?project=989504216135
2. Vous devriez voir "People API" dans la liste des APIs activées

---

## Délai de Propagation

⏱️ **Important**: Après activation, attendez **2-5 minutes** pour que les changements se propagent dans les systèmes Google.

Si vous réessayez immédiatement, vous pourriez encore voir l'erreur. Attendez quelques minutes.

---

## Test

Après activation et attente:

1. Rechargez votre application HansEco
2. Cliquez sur "Sign in with Google"
3. Complétez l'authentification
4. Vous devriez maintenant être connecté avec succès !

---

## Résolution des Problèmes

### L'erreur persiste après 10 minutes

- Vérifiez que vous avez activé l'API dans le bon projet (989504216135)
- Vérifiez que l'API est bien marquée comme "Activée" dans le dashboard
- Essayez de déconnecter/reconnecter votre compte Google dans le navigateur
- Essayez en navigation privée

### Erreur "Quota exceeded"

- L'API People a des quotas gratuits généreux
- Pour une application en développement, vous ne devriez pas atteindre les limites
- Vérifiez les quotas: https://console.cloud.google.com/apis/api/people.googleapis.com/quotas?project=989504216135

---

## Ressources

- [Documentation Google People API](https://developers.google.com/people)
- [Console Google Cloud](https://console.cloud.google.com/)
- [Quotas et limites](https://developers.google.com/people/v1/how-tos/quotas)
