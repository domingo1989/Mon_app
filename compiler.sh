#!/bin/bash

# 💡 Configuration
ZIP_PATH="/storage/emulated/0/Download/mon_app.zip"
PROJET_DIR="mon_app"
GITHUB_REPO="https://github.com/domingo1989/mon_apoli_flutter.git"

echo "📦 Décompression du projet Flutter..."
unzip -o "$ZIP_PATH" -d "$PROJET_DIR"

cd "$PROJET_DIR" || { echo "❌ Dossier $PROJET_DIR introuvable"; exit 1; }

echo "🔧 Initialisation Git..."
git init

# 👤 Configurer l'identité Git
git config user.name "Francis Domingo"
git config user.email "domingofrancis176@gmail.com"

# 🚀 Premier commit
git add .
git commit -m "Premier commit Flutter"
git branch -M main
git remote add origin "$GITHUB_REPO"

echo "⚙️ Ajout du workflow GitHub Actions..."
mkdir -p .github/workflows

cat > .github/workflows/flutter.yml << 'EOF'
name: Build APK

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    name: Build Flutter APK
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.13.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk
EOF

git add .github
git commit -m "Ajout du workflow GitHub Actions"

echo "📤 Envoi vers GitHub..."
git push -u origin main

echo "✅ Terminé ! Va sur https://github.com/domingo1989/mon_apoli_flutter/actions pour lancer le build et récupérer l'APK."
