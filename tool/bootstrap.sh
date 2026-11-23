#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK bulunamadı. Önce Flutter'ı kurup PATH'e ekleyin." >&2
  exit 1
fi

# Generate native Android/iOS folders while preserving lib/ and pubspec.yaml.
flutter create --platforms=android,ios --org com.csprofesor .
flutter pub get

echo "Hazır. Android: flutter run -d android | iOS: flutter run -d ios"
