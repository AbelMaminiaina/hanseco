# 🚀 HansEco - CI/CD Auto Deployment to Play Store

## ✅ What's Configured

Your project now has **FREE automated deployment** to Google Play Store!

### What happens when you push code:
1. ✅ Automatically builds Android release
2. ✅ Runs tests
3. ✅ Creates APK and AAB files
4. ✅ Deploys to Play Store
5. ✅ Notifies you of success/failure

**Cost: $0/month** (uses GitHub Actions free tier)

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| **[CICD_QUICK_REFERENCE.md](./CICD_QUICK_REFERENCE.md)** | ⚡ Start here! Quick commands and checklist |
| **[CICD_SETUP_GUIDE.md](./CICD_SETUP_GUIDE.md)** | 📖 Complete step-by-step setup guide |
| **[ANDROID_DEPLOYMENT_GUIDE.md](./ANDROID_DEPLOYMENT_GUIDE.md)** | 📱 Manual Android deployment guide |
| **[FIREBASE_SETUP_GUIDE.md](./FIREBASE_SETUP_GUIDE.md)** | 🔥 Firebase & Google Sign-In setup |

---

## 🎯 Quick Start (3 Steps)

### Step 1: One-Time Setup (30 minutes)

1. **Create signing key** (if not done):
   ```bash
   cd hanseco_app/android/app
   keytool -genkey -v -keystore hanseco-upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias hanseco
   ```

2. **Prepare secrets**:
   ```bash
   ./prepare-cicd-secrets.sh
   ```

3. **Add secrets to GitHub**:
   - Go to: GitHub repo → Settings → Secrets → Actions
   - Add all 6 secrets (see [Quick Reference](./CICD_QUICK_REFERENCE.md#-required-github-secrets))

4. **Set up Play Store API**:
   - Follow: [CICD Setup Guide - Step 1](./CICD_SETUP_GUIDE.md#step-1-create-google-play-service-account)

5. **First manual release**:
   - Upload app to Play Store once manually
   - See: [Setup Guide - Step 5](./CICD_SETUP_GUIDE.md#step-5-first-manual-release-required)

### Step 2: Push Your Code

```bash
git add .
git commit -m "Enable CI/CD deployment"
git push origin main
```

### Step 3: Watch It Deploy! 🎉

- Go to: GitHub → Actions
- See your build and deployment in progress
- Check Play Console for deployed version

---

## 💰 Costs

| Item | Cost | Frequency |
|------|------|-----------|
| **GitHub Actions** | $0 | Free tier (2,000 min/month) |
| **Google Play Console** | $25 | One-time registration |
| **Total Monthly** | **$0** | After initial $25 |

---

## 🔄 Deployment Workflow

```
┌─────────────────┐
│  Code Changes   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  git push main  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│     GitHub Actions (Automatic)      │
│  ✓ Build APK/AAB                   │
│  ✓ Run tests                       │
│  ✓ Sign release                    │
│  ✓ Upload to Play Store           │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────┐
│  Play Store     │
│  Internal Track │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Test & Review  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Promote to     │
│  Production     │
└─────────────────┘
```

---

## 📁 Files Created

```
HansEco/
├── .github/
│   └── workflows/
│       └── android-deploy.yml              # CI/CD workflow
├── hanseco_app/
│   └── android/
│       ├── release-notes/
│       │   ├── whatsnew-en-US             # English release notes
│       │   └── whatsnew-fr-FR             # French release notes
│       ├── app/
│       │   ├── hanseco-upload-key.jks     # Signing key (gitignored)
│       │   └── google-services.json       # Firebase (gitignored)
│       └── key.properties                 # Signing config (gitignored)
├── CICD_SETUP_GUIDE.md                    # Complete setup guide
├── CICD_QUICK_REFERENCE.md                # Quick reference
├── prepare-cicd-secrets.sh                # Helper script
└── README_CICD.md                         # This file
```

---

## 🎯 Deployment Tracks

| Track | Auto Deploy | Manual Deploy | Purpose |
|-------|------------|---------------|---------|
| **Internal** | ✅ On push to main | ✅ | Quick testing |
| **Alpha** | ❌ | ✅ | Closed testing |
| **Beta** | ❌ | ✅ | Open testing |
| **Production** | ❌ | ✅ | Public release |

---

## 🚦 Status Badges

Add to your main README.md:

```markdown
![Android CI/CD](https://github.com/YOUR_USERNAME/HansEco/workflows/Android%20-%20Build%20%26%20Deploy%20to%20Play%20Store/badge.svg)
```

---

## 🐛 Common Issues

| Issue | Solution |
|-------|----------|
| Build fails - "Keystore not found" | Add `KEYSTORE_BASE64` secret |
| Build fails - "Google Services missing" | Add `GOOGLE_SERVICES_JSON` secret |
| Deployment fails - "Unauthorized" | Grant service account "Release manager" role |
| First deployment fails | Upload app manually to Play Store once first |

Full troubleshooting: [Setup Guide - Troubleshooting](./CICD_SETUP_GUIDE.md#-troubleshooting)

---

## ✅ Pre-Deployment Checklist

Before your first automated deployment:

- [ ] Signing key created (`hanseco-upload-key.jks`)
- [ ] All 6 GitHub secrets added
- [ ] Service account created with Play Console access
- [ ] App uploaded to Play Store manually (once)
- [ ] Release notes created
- [ ] Firebase configured (`google-services.json`)
- [ ] Workflow file committed to repository

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/HansEco/issues)
- **Setup Help**: See [CICD_SETUP_GUIDE.md](./CICD_SETUP_GUIDE.md)
- **Quick Commands**: See [CICD_QUICK_REFERENCE.md](./CICD_QUICK_REFERENCE.md)

---

## 🎉 You're All Set!

Once configured, your deployment is as simple as:

```bash
git push origin main
```

That's it! GitHub Actions handles the rest. ✨

---

**Built with ❤️ using FREE GitHub Actions**
