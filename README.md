# Minik Okur — İlk Okuma Yazma

> 🌐 **Canlı Deneme Web Sürümü:** [https://csprofesor.github.io/okumayazma/](https://csprofesor.github.io/okumayazma/)

1. sınıf öğrencileri için Türkçe ses esaslı ilk okuma yazma sürecini destekleyen Flutter uygulaması.

## Mevcut prototip
- MEB'in resmî beş ses grubunu korur; uygulama içindeki açılma sırası resmî tema akışına göre düzenlenmiştir.
- Harf kartları, büyük/küçük harf gösterimi, örnek kelimeler ve cihaz TTS seslendirmesi içerir.
- TTS düğmesi harfin adını ve kelimelerin telaffuzunu okur. Harf adı ile sesbirim aynı şey olmadığından ünsüz ses öğretimi için TTS tek başına kullanılmaz.
- Dört öğrenme aşaması sırayla açılır; sonraki aşama önceki aşamadaki harfler tamamlanınca açılır.
- Hece, kelime ve cümle alıştırmaları yalnızca o aşamada öğrenilmiş harflerle sınırlıdır.
- Dinle ve harfi bul oyunu ile harfi içeren kelimeyi görselden seçme oyunu yalnızca açılmış aşamalardaki içerikleri kullanır.
- Küçük/büyük harf seçilebilen parmakla yazma alanı, özgün Material ikonlu kelime kartları ve veli bilgilendirme ekranı içerir.
- Tüm harfler tamamlanınca üç özgün kısa hikâye ve çoktan seçmeli okuduğunu anlama soruları açılır.
- İlerleme SharedPreferences ile cihazda tutulur; hesap ve sunucu gerektirmez.

## Müfredat eşleştirmesi

**Resmî ses grupları:**
1. a, n, e, t, i, l
2. o, k, u, r, ı, m
3. ü, s, ö, y, d, z
4. ç, b, g, c, ş
5. p, h, v, ğ, f, j

**Uygulamadaki tema/öğrenme sırası:**
1. Tema 1: a, n, e, t
2. Tema 2: i, l, o, k, u
3. Tema 3: r, ı, m, ü, s, ö, y, d, z
4. Tema 4: ç, b, g, c, ş, p, h, v, ğ, f, j

Bu eşleştirme MEB'in 1. sınıf Türkçe tema sayfalarında belirtilen harf öğretim sırasına göre düzenlenmiştir. Resmî programda ilk temada a-n-e-t; ikinci temada i-l ve o-k-u; üçüncü temada r-ı-m ve ü-s-ö-y-d-z; dördüncü temada ç-b-g-c-ş ile p-h-v-ğ-f-j harfleri yer alır.

Resmî kaynaklar:
- https://tymm.meb.gov.tr/ilkokul-turkce-dersi/unite/265
- https://tymm.meb.gov.tr/ilkokul-turkce-dersi/unite/269
- https://tymm.meb.gov.tr/ilkokul-turkce-dersi/unite/286
- https://tymm.meb.gov.tr/ilkokul-turkce-dersi/unite/289

Uygulama öğretmenin, resmî programın veya güncel ders kitabının yerine geçmez. Tema süreleri, rakam öğretimi, dinleme-konuşma çıktıları ve ölçme-değerlendirme çalışmaları da sonraki sürümlerde eklenmelidir.

## Kurulum ve Gereksinimler

Projeyi yerel ortamınızda derlemek ve çalıştırmak için aşağıdaki araçların kurulu olması gerekir:

### 1. Flutter ve Dart SDK
- **Flutter SDK Kurulum Kılavuzu:** [docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
  - [Windows Kurulumu](https://docs.flutter.dev/get-started/install/windows)
  - [macOS Kurulumu](https://docs.flutter.dev/get-started/install/macos)
  - [Linux Kurulumu](https://docs.flutter.dev/get-started/install/linux)
  - [ChromeOS Kurulumu](https://docs.flutter.dev/get-started/install/chromeos)
- **Dart SDK:** [dart.dev/get-dart](https://dart.dev/get-dart) *(Flutter SDK ile birlikte otomatik gelir)*

### 2. Geliştirme Ortamı (IDE) ve Eklentiler
- **Visual Studio Code:** [code.visualstudio.com](https://code.visualstudio.com/)
  - [VS Code Flutter Eklentisi](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
  - [VS Code Dart Eklentisi](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
- **Android Studio:** [developer.android.com/studio](https://developer.android.com/studio)
  - [Android Studio Flutter Eklentisi](https://plugins.jetbrains.com/plugin/9212-flutter)

### 3. Hedef Platform Araçları
- **Android:**
  - Android Studio ve Android SDK (Build-Tools, Platform-Tools, SDK Platform 34+)
  - **Java Development Kit (JDK 17 LTS):** [Eclipse Temurin OpenJDK 17](https://adoptium.net/temurin/releases/?version=17)
- **Web:**
  - **Google Chrome:** [google.com/chrome](https://www.google.com/chrome/)
- **iOS / macOS (yalnızca macOS kullanıcıları için):**
  - **Xcode:** [Mac App Store - Xcode](https://apps.apple.com/app/xcode/id497799835)
  - **CocoaPods:** [cocoapods.org](https://cocoapods.org/) (`sudo gem install cocoapods`)
- **Windows Masaüstü:**
  - **Visual Studio Community (C++ masaüstü geliştirme paketi):** [visualstudio.microsoft.com](https://visualstudio.microsoft.com/downloads/)
- **Linux Masaüstü:**
  - Gerekli kütüphaneler: `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`

---

## Kurulum Doğrulama ve Çalıştırma

Kurulumların eksiksiz olduğunu doğrulamak için terminalde şu komutu çalıştırın:
```bash
flutter doctor -v
```

### Projeyi Çalıştırma
Tüm bağımlılıkları yükleyin ve projeyi başlatın:

```bash
# Bağımlılıkları indir
flutter pub get

# Bağlı veya açık emülatörde çalıştır
flutter run
```

Platforma özel çalıştırma komutları:
```bash
# Doğrudan Web (Google Chrome) üzerinde çalıştırma
flutter run -d chrome

# Android emülatör veya fiziksel cihazda çalıştırma
flutter run -d android

# macOS masaüstü uygulamasını çalıştırma
flutter run -d macos

# Windows masaüstü uygulamasını çalıştırma
flutter run -d windows
```

### Test ve Analiz
```bash
# Kod analizi (Linter)
flutter analyze

# Birim ve widget testleri
flutter test

# Web derlemesi alma
flutter build web

# Android APK derlemesi alma
flutter build apk --debug
```

Platform dosyalarını tazelemek veya eksik platform iskelelerini yeniden oluşturmak için:
```bash
bash tool/bootstrap.sh
```

## Telif ve içerik ilkeleri
- Harf kartları, örnek kelimeler, cümleler, ekran tasarımı ve etkinlik mantığı bu proje için özgün hazırlanır.
- MEB ders kitaplarının sayfa görselleri, metinleri, etkinlikleri, ses kayıtları veya videoları kopyalanmaz.
- Müfredatın öğrenme sırası ve kazanımları referans alınır; yayınevi içeriği yeniden yayımlanmaz.
- Görsellerde uygulama içinde kullanılan Flutter Material ikonları ve özgün arayüz bileşenleri tercih edilir.
- Sesler uygulamanın kendi kaydı değildir; cihazın işletim sistemi TTS motoru tarafından anlık üretilir.
- Uygulama adı ve ikonunun mağazaya gönderilmeden önce marka/benzerlik araştırması yapılmalıdır.
- Üçüncü taraf paketlerin lisansları ve mağaza politikaları yayın öncesi kontrol edilmelidir.

## Yayın öncesi yapılacaklar
- [ ] Sınıf öğretmeni ve Türkçe eğitimi uzmanı incelemesi
- [ ] Ses/harf/kelime eşleşmelerinin pedagojik kontrolü
- [x] İlk hece, kelime ve kısa cümle alıştırmalarının eklenmesi
- [ ] Harflerin doğru yazım yönlerini gösteren adım adım animasyonlar
- [ ] Görselden ses bulma ve kelime içindeki sesin konumunu seçme etkinlikleri
- [ ] Rakam öğretimi ve hazırlık çalışmaları
- [x] İlk kısa metinler ve okuduğunu anlama soruları
- [ ] Daha geniş seviyelendirilmiş kısa metin ve dinlediğini anlama modülü
- [ ] Gerçek Android/iPhone cihazlarında TTS, çizim ve erişilebilirlik testi
- [ ] Android/iOS platform projeleri, bundle ID ve imzalama
- [ ] Uygulama ikonu, ekran görüntüleri ve mağaza açıklamaları
- [ ] Gizlilik politikası ve mağaza veri beyanları
- [ ] Çocuklara yönelik uygulama ve reklam/analitik kurallarının kontrolü
