# CI/CD Quick Reference

## 🚀 One-Time Setup (30 minutes)

1. **Create Service Account** → [Guide](./CICD_SETUP_GUIDE.md#step-1-create-google-play-service-account)
2. **Encode Secrets** → Run `prepare-cicd-secrets.sh`
3. **Add to GitHub** → Settings > Secrets > Add 6 secrets
4. **Manual First Release** → Upload AAB to Play Console once
5. **Push to GitHub** → CI/CD handles the rest!

## 📦 Required GitHub Secrets

| Secret Name | Description | Where to Get It |
|------------|-------------|-----------------|
| `KEYSTORE_BASE64` | Base64 encoded keystore | Run script, copy from `keystore-base64.txt` |
| `KEYSTORE_PASSWORD` | Keystore password | From your `key.properties` file |
| `KEY_PASSWORD` | Key password | From your `key.properties` file |
| `KEY_ALIAS` | Key alias | Usually: `hanseco` |
| `GOOGLE_SERVICES_JSON` | Firebase config | Copy entire `google-services.json` |
| `PLAY_STORE_SERVICE_ACCOUNT_JSON` | API access | Download from Google Cloud Console |

## ⚡ Quick Commands

### Prepare Secrets for GitHub
```bash
# Run this script to generate base64 files
./prepare-cicd-secrets.sh
```

### Manual Deployment
```bash
# Build release
cd hanseco_app
flutter build appbundle --release

# APK location
# build/app/outputs/bundle/release/app-release.aab
```

### Test CI/CD Locally (before pushing)
```bash
# Analyze code
cd hanseco_app
flutter analyze

# Run tests
flutter test

# Build release
flutter build appbundle --release
```

## 🎯 Deployment Workflow

### Auto Deploy (Push to main)
```bash
git add .
git commit -m "Add new feature"
git push origin main
```
→ Automatically deploys to **internal** track

### Manual Deploy (Choose track)
1. Go to GitHub → **Actions**
2. Select **Android - Build & Deploy to Play Store**
3. Click **Run workflow**
4. Choose track: internal / alpha / beta / production
5. Click **Run workflow**

## 📊 Deployment Tracks

| Track | Purpose | Who Can Access |
|-------|---------|----------------|
| **Internal** | Quick testing | Internal testers only (add in Play Console) |
| **Alpha** | Closed testing | Specific testers you invite |
| **Beta** | Open testing | Anyone with the link |
| **Production** | Public release | Everyone on Play Store |

## 🔄 Typical Development Flow

```
1. Code locally
   ↓
2. git push origin main
   ↓
3. GitHub Actions builds (10 min)
   ↓
4. Auto deploy to internal track
   ↓
5. Test with internal testers
   ↓
6. Manually promote to beta/production in Play Console
```

## 📁 Important Files

```
.github/workflows/
  └── android-deploy.yml          # CI/CD workflow

hanseco_app/android/
  ├── app/
  │   ├── hanseco-upload-key.jks  # Signing key (NOT in git)
  │   └── google-services.json    # Firebase config (NOT in git)
  ├── key.properties              # Signing credentials (NOT in git)
  └── release-notes/
      ├── whatsnew-en-US          # English release notes
      └── whatsnew-fr-FR          # French release notes
```

## 🐛 Quick Troubleshooting

### Build Fails
1. Check **Actions** tab for detailed error
2. Common issues:
   - Missing secrets → Add in Settings > Secrets
   - Wrong passwords → Double-check keystore/key passwords
   - Missing google-services.json → Add secret

### Deployment Fails
1. **"Service account not authorized"**
   - Grant "Release manager" role in Play Console

2. **"App not found"**
   - Upload app manually to Play Console first

3. **"Invalid keystore"**
   - Re-generate KEYSTORE_BASE64 secret

## 💡 Pro Tips

✅ **DO:**
- Test locally before pushing (`flutter build appbundle --release`)
- Use meaningful commit messages
- Update release notes before deploying
- Test on internal track before production

❌ **DON'T:**
- Commit secrets to git (.gitignore protects you)
- Deploy directly to production (test first)
- Skip testing
- Forget to update version number in pubspec.yaml

## 📞 Need Help?

- **Full Guide**: [CICD_SETUP_GUIDE.md](./CICD_SETUP_GUIDE.md)
- **Android Deployment**: [ANDROID_DEPLOYMENT_GUIDE.md](./ANDROID_DEPLOYMENT_GUIDE.md)
- **Firebase Setup**: [FIREBASE_SETUP_GUIDE.md](./FIREBASE_SETUP_GUIDE.md)

## ✅ Pre-Flight Checklist

Before first deployment:
- [ ] Service account created with API access
- [ ] 6 secrets added to GitHub
- [ ] First manual release completed on Play Console
- [ ] Release notes created
- [ ] Workflow file committed
- [ ] Test push triggers build successfully

---

**Cost: $0/month** (FREE GitHub Actions tier)
