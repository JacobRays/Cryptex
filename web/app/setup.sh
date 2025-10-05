#!/bin/bash

# Install Flutter
cd ~
git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
export PATH="$PATH:$HOME/flutter/bin"

# Setup Flutter
flutter doctor --android-licenses || true
flutter doctor
flutter config --enable-web

# Install Android SDK
sudo apt-get update
sudo apt-get install -y android-sdk

# Create the Flutter project
cd /workspaces/cryptex-malawi
flutter create --org mw.cryptex --project-name cryptex .
flutter pub get

# Install required packages
flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage
flutter pub add provider google_fonts flutter_svg
flutter pub add image_picker pin_code_fields
flutter pub add intl cached_network_image
flutter pub add flutter_rating_bar shimmer
flutter pub add connectivity_plus shared_preferences

echo "Setup complete! Run 'flutter doctor' to verify installation."