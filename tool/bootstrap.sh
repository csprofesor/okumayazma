#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK bulunamadı. Önce Flutter'ı kurup PATH'e ekleyin." >&2
  exit 1
fi

# Platform klasörlerini eksikse tamamla ve paketleri indir.
flutter create --platforms=android,ios,web,macos,linux,windows --org com.csprofesor .
flutter pub get

echo "Hazır. Çalıştırma seçenekleri:"
echo "  Web:     flutter run -d chrome"
echo "  macOS:   flutter run -d macos"
echo "  Android: flutter run -d android"
echo "  iOS:     flutter run -d ios"
