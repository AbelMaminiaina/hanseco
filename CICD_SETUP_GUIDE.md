# CI/CD Setup Guide - Auto Deploy to Play Store

This guide will help you set up automated deployment to Google Play Store using GitHub Actions (100% FREE).

## 🎯 What This Does

When you push code to GitHub:
1. ✅ Automatically builds your Android app
2. ✅ Runs tests
3. ✅ Creates release APK and AAB files
4. ✅ Deploys to Play Store (internal/beta/production track)

**Cost: $0/month** (uses GitHub Actions free tier)

---

## 📋 Prerequisites Checklist

Before starting, you need:
- [ ] GitHub repository for your project
- [ ] Google Play Console account ($25 one-time)
- [ ] App published on Play Store (at least once manually)
- [ ] Release signing key created (hanseco-upload-key.jks)

---

## Step 1: Create Google Play Service Account

This allows GitHub to upload builds to Play Store automatically.

### 1.1 Enable Google Play Developer API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project (or create a new one)
3. Go to **APIs & Services** > **Library**
4. Search for "Google Play Android Developer API"
5. Click **Enable**

### 1.2 Create Service Account

1. Go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **Service Account**
3. Fill in details:
   - **Service account name**: `github-actions-deploy`
   - **Service account ID**: `github-actions-deploy`
   - **Description**: `Service account for GitHub Actions CI/CD`
4. Click **Create and Continue**
5. Click **Done** (skip optional steps)

### 1.3 Create Service Account Key

1. Click on the service account you just created
2. Go to **Keys** tab
3. Click **Add Key** > **Create new key**
4. Choose **JSON** format
5. Click **Create**
6. **Save this JSON file securely** - you'll need it later

### 1.4 Grant Play Console Access

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Go to **Setup** > **API access**
4. Under **Service accounts**, click **Link service account**
5. Select the service account you created
6. Click **Invite user**
7. Grant permissions:
   - ✅ **Release manager** (or higher)
   - ✅ **View app information**
8. Click **Invite user**

---

## Step 2: Prepare Your Secrets

You need to encode certain files for GitHub.

### 2.1 Encode Keystore to Base64

**Windows PowerShell:**
```powershell
cd hanseco_app/android/app
[Convert]::ToBase64String([IO.File]::ReadAllBytes("hanseco-upload-key.jks")) | Out-File -Encoding ASCII keystore-base64.txt
```

**Git Bash / Linux:**
```bash
cd hanseco_app/android/app
base64 -w 0 hanseco-upload-key.jks > keystore-base64.txt
```

This creates `keystore-base64.txt` - you'll copy this content to GitHub secrets.

### 2.2 Prepare Google Services JSON

Get the content of your `google-services.json`:
```bash
cat hanseco_app/android/app/google-services.json
```

Copy the entire JSON content - you'll paste this into GitHub secrets.

### 2.3 Get Service Account JSON

Open the service account JSON file you downloaded in Step 1.3.
Copy the entire content - you'll paste this into GitHub secrets.

---

## Step 3: Configure GitHub Secrets

GitHub Secrets store sensitive information securely.

### 3.1 Navigate to Secrets

1. Go to your GitHub repository
2. Click **Settings**
3. Click **Secrets and variables** > **Actions**
4. Click **New repository secret**

### 3.2 Add Required Secrets

Add each of the following secrets:

#### Secret 1: KEYSTORE_BASE64
- **Name**: `KEYSTORE_BASE64`
- **Value**: Paste content from `keystore-base64.txt` (from Step 2.1)

#### Secret 2: KEYSTORE_PASSWORD
- **Name**: `KEYSTORE_PASSWORD`
- **Value**: Your keystore password (same as in key.properties)

#### Secret 3: KEY_PASSWORD
- **Name**: `KEY_PASSWORD`
- **Value**: Your key password (same as in key.properties)

#### Secret 4: KEY_ALIAS
- **Name**: `KEY_ALIAS`
- **Value**: `hanseco` (your key alias)

#### Secret 5: GOOGLE_SERVICES_JSON
- **Name**: `GOOGLE_SERVICES_JSON`
- **Value**: Paste entire content of google-services.json (from Step 2.2)

#### Secret 6: PLAY_STORE_SERVICE_ACCOUNT_JSON
- **Name**: `PLAY_STORE_SERVICE_ACCOUNT_JSON`
- **Value**: Paste entire content of service account JSON (from Step 2.3)

### 3.3 Verify Secrets

You should now have **6 secrets** configured:
- ✅ KEYSTORE_BASE64
- ✅ KEYSTORE_PASSWORD
- ✅ KEY_PASSWORD
- ✅ KEY_ALIAS
- ✅ GOOGLE_SERVICES_JSON
- ✅ PLAY_STORE_SERVICE_ACCOUNT_JSON

---

## Step 4: Create Release Notes Directory

Create a directory for release notes that will appear on Play Store:

```bash
mkdir -p hanseco_app/android/release-notes
```

Create release notes file:
```bash
cat > hanseco_app/android/release-notes/whatsnew-en-US << EOF
🎉 New features and improvements
🐛 Bug fixes and performance enhancements
✨ Enhanced user experience
EOF
```

You can create different files for different languages:
- `whatsnew-en-US` - English
- `whatsnew-fr-FR` - French
- `whatsnew-mg-MG` - Malagasy

---

## Step 5: First Manual Release (Required)

**IMPORTANT**: Before CI/CD can deploy, you must manually upload your app to Play Store at least once.

### 5.1 Build Release AAB

```bash
cd hanseco_app
flutter build appbundle --release
```

### 5.2 Upload to Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app (or create new app)
3. Complete all required information:
   - App name, description, category
   - Screenshots, icons
   - Content rating
   - Privacy policy URL
4. Go to **Production** > **Create new release**
5. Upload: `hanseco_app/build/app/outputs/bundle/release/app-release.aab`
6. Fill in release notes
7. Click **Review release** > **Start rollout to Production**

**After this first manual release, CI/CD will handle all future releases!**

---

## Step 6: Test Your CI/CD Pipeline

### 6.1 Commit and Push Workflow

```bash
git add .github/workflows/android-deploy.yml
git add hanseco_app/android/release-notes/
git commit -m "Add CI/CD workflow for Play Store deployment"
git push origin main
```

### 6.2 Monitor the Build

1. Go to your GitHub repository
2. Click **Actions** tab
3. You should see your workflow running
4. Click on it to see detailed logs

### 6.3 Deployment Tracks

The workflow deploys to different tracks based on how it's triggered:

**Automatic (on push to main):**
- Deploys to **internal** track
- Good for testing with internal testers

**Manual dispatch:**
1. Go to **Actions** tab
2. Click **Android - Build & Deploy to Play Store**
3. Click **Run workflow**
4. Choose track:
   - `internal` - Internal testing
   - `alpha` - Closed testing
   - `beta` - Open testing
   - `production` - Production release

---

## 📊 Workflow Triggers

The CI/CD runs automatically when:

1. **Push to `main` branch** → Deploys to internal track
2. **Push to `release` branch** → Deploys to internal track
3. **Pull Request to `main`** → Builds only (no deployment)
4. **Manual trigger** → Choose deployment track

---

## 🔒 Security Best Practices

✅ **DO:**
- Keep secrets in GitHub Secrets (encrypted)
- Use service accounts with minimum required permissions
- Regularly rotate API keys
- Enable 2FA on Google and GitHub accounts

❌ **DON'T:**
- Commit keystore files to git (.gitignore prevents this)
- Commit service account JSON to git
- Share secrets in plain text
- Use personal Google account for service account

---

## 🚀 Daily Usage

Once set up, your workflow is:

1. **Develop your app** locally
2. **Commit changes**: `git commit -m "Add new feature"`
3. **Push to GitHub**: `git push origin main`
4. **Wait ~10 minutes** - CI/CD builds and deploys automatically
5. **Check Play Console** - New version available in internal track
6. **Test with internal testers**
7. **Promote to production** when ready (via Play Console or manual workflow trigger)

---

## 📈 Monitoring Builds

### View Build Status

**GitHub Actions Dashboard:**
- Green check ✅ = Build successful
- Red X ❌ = Build failed
- Yellow dot 🟡 = Build in progress

**Download Build Artifacts:**
1. Go to **Actions** > Select workflow run
2. Scroll to **Artifacts** section
3. Download APK or AAB files

### Play Console Status

Check deployment in Play Console:
1. Go to your app
2. **Release** > **Testing** > **Internal testing**
3. See new version deployed

---

## 🐛 Troubleshooting

### Build Fails - "Keystore not found"
**Solution**: Check that `KEYSTORE_BASE64` secret is correctly set

### Build Fails - "Google Services missing"
**Solution**: Check that `GOOGLE_SERVICES_JSON` secret is correctly set

### Deployment Fails - "Service account unauthorized"
**Solution**:
- Verify service account has "Release manager" role in Play Console
- Check `PLAY_STORE_SERVICE_ACCOUNT_JSON` secret is correct

### Build Fails - "Signing failed"
**Solution**: Verify keystore passwords are correct in secrets

### First deployment fails
**Solution**: You must manually upload your app to Play Store at least once before CI/CD can deploy

---

## 💡 Advanced Configuration

### Deploy to Beta on Tag

Add to workflow triggers:
```yaml
on:
  push:
    tags:
      - 'v*.*.*'
```

Then change track to `beta` for tag deployments.

### Slack Notifications

Add Slack webhook to notify team:
```yaml
- name: Notify Slack
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Automated Version Bumping

Use semantic versioning with automated version bumping on each release.

---

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
- [Google Play Developer API](https://developers.google.com/android-publisher)
- [Play Console Help](https://support.google.com/googleplay/android-developer)

---

## ✅ Quick Checklist

Before going live, verify:
- [ ] All 6 GitHub secrets configured
- [ ] Service account has Play Console access
- [ ] First manual release completed
- [ ] Release notes directory created
- [ ] Workflow file committed to repository
- [ ] Test build succeeded in GitHub Actions
- [ ] App visible in Play Console internal track

---

**Need help?** Check the troubleshooting section or contact the development team.

**Total Cost: $25** (Play Console one-time fee)
**Monthly Cost: $0** (GitHub Actions free tier)
