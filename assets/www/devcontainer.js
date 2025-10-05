{
  "name": "Cryptex Malawi Flutter Dev",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/java:1": {
      "version": "17"
    }
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "Dart-Code.flutter",
        "Dart-Code.dart-code",
        "Nash.awesome-flutter-snippets",
        "usernamehw.errorlens"
      ],
      "settings": {
        "dart.flutterSdkPath": "/home/codespace/flutter"
      }
    }
  },
  "postCreateCommand": "bash .devcontainer/setup.sh",
  "forwardPorts": [3000, 5000, 8080],
  "remoteUser": "codespace"
}