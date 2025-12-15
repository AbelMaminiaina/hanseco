#!/bin/bash

echo "=========================================="
echo "CI/CD Secrets Preparation Script"
echo "=========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if keystore exists
KEYSTORE_PATH="hanseco_app/android/app/hanseco-upload-key.jks"
if [ ! -f "$KEYSTORE_PATH" ]; then
    echo -e "${RED}❌ Error: Keystore not found at $KEYSTORE_PATH${NC}"
    echo ""
    echo "Please create your signing key first:"
    echo "cd hanseco_app/android/app"
    echo "keytool -genkey -v -keystore hanseco-upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias hanseco"
    exit 1
fi

echo -e "${GREEN}✅ Found keystore at: $KEYSTORE_PATH${NC}"
echo ""

# Encode keystore to base64
echo "📦 Encoding keystore to base64..."
base64 -w 0 "$KEYSTORE_PATH" > keystore-base64.txt 2>/dev/null || base64 "$KEYSTORE_PATH" > keystore-base64.txt
echo -e "${GREEN}✅ Created: keystore-base64.txt${NC}"
echo ""

# Check for key.properties
KEY_PROPS_PATH="hanseco_app/android/key.properties"
if [ -f "$KEY_PROPS_PATH" ]; then
    echo -e "${GREEN}✅ Found key.properties${NC}"
    echo ""
    echo "Your keystore credentials:"
    cat "$KEY_PROPS_PATH"
    echo ""
else
    echo -e "${YELLOW}⚠️  key.properties not found${NC}"
    echo "You'll need to remember your keystore passwords for GitHub secrets"
    echo ""
fi

# Check for google-services.json
GOOGLE_SERVICES_PATH="hanseco_app/android/app/google-services.json"
if [ -f "$GOOGLE_SERVICES_PATH" ]; then
    echo -e "${GREEN}✅ Found google-services.json${NC}"
    echo ""
    echo "To copy to clipboard:"
    echo "cat $GOOGLE_SERVICES_PATH | clip  # Windows"
    echo "cat $GOOGLE_SERVICES_PATH | pbcopy  # macOS"
    echo "cat $GOOGLE_SERVICES_PATH | xclip -selection clipboard  # Linux"
    echo ""
else
    echo -e "${YELLOW}⚠️  google-services.json not found${NC}"
    echo "Download from Firebase Console and place at: $GOOGLE_SERVICES_PATH"
    echo ""
fi

echo "=========================================="
echo "📋 Next Steps:"
echo "=========================================="
echo ""
echo "1. Go to GitHub repository → Settings → Secrets → Actions"
echo ""
echo "2. Add these secrets:"
echo ""
echo -e "${YELLOW}KEYSTORE_BASE64${NC}"
echo "   Copy content from: keystore-base64.txt"
echo ""
echo -e "${YELLOW}KEYSTORE_PASSWORD${NC}"
if [ -f "$KEY_PROPS_PATH" ]; then
    KEYSTORE_PASS=$(grep "storePassword=" "$KEY_PROPS_PATH" | cut -d'=' -f2)
    echo "   Value: $KEYSTORE_PASS"
else
    echo "   Value: (your keystore password)"
fi
echo ""
echo -e "${YELLOW}KEY_PASSWORD${NC}"
if [ -f "$KEY_PROPS_PATH" ]; then
    KEY_PASS=$(grep "keyPassword=" "$KEY_PROPS_PATH" | cut -d'=' -f2)
    echo "   Value: $KEY_PASS"
else
    echo "   Value: (your key password)"
fi
echo ""
echo -e "${YELLOW}KEY_ALIAS${NC}"
if [ -f "$KEY_PROPS_PATH" ]; then
    KEY_ALIAS=$(grep "keyAlias=" "$KEY_PROPS_PATH" | cut -d'=' -f2)
    echo "   Value: $KEY_ALIAS"
else
    echo "   Value: hanseco"
fi
echo ""
echo -e "${YELLOW}GOOGLE_SERVICES_JSON${NC}"
if [ -f "$GOOGLE_SERVICES_PATH" ]; then
    echo "   Copy entire content of: $GOOGLE_SERVICES_PATH"
else
    echo "   Download from Firebase Console first"
fi
echo ""
echo -e "${YELLOW}PLAY_STORE_SERVICE_ACCOUNT_JSON${NC}"
echo "   Download service account JSON from Google Cloud Console"
echo "   See: CICD_SETUP_GUIDE.md Step 1"
echo ""
echo "=========================================="
echo -e "${GREEN}✅ Preparation Complete!${NC}"
echo "=========================================="
echo ""
echo "Follow the full guide: CICD_SETUP_GUIDE.md"
echo ""
