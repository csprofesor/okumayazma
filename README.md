# Minik Okur — İlk Okuma Yazma

1. sınıf öğrencileri için Türkçe ses esaslı ilk okuma yazma sürecini destekleyen Flutter uygulaması.

## Mevcut ilk sürüm
- Beş ses grubunu Türkiye Yüzyılı Maarif Modeli'ndeki sırayla sunar.
- Harf ekranlarında büyük/küçük harf, seslendirme ve örnek kelimeler bulunur.
- Cihazın Türkçe metin-seslendirme motorunu kullanır; uygulamaya üçüncü taraf ses kaydı eklenmez.
- Dinle ve harfi bul oyunu, parmakla yazma alanı, kelime okuma ve veli bilgilendirme ekranı içerir.
- İlerleme SharedPreferences ile cihazda tutulur; hesap ve sunucu gerektirmez.

## Müfredat
1. a, n, e, t, i, l
2. o, k, u, r, ı, m
3. ü, s, ö, y, d, z
4. ç, b, g, c, ş
5. p, h, v, ğ, f, j

Temel akış ses → harf → hece → anlamlı kelime → cümle/metindir. Uygulama öğretmenin ve güncel ders kitabının yerine geçmez.

## Çalıştırma
Flutter 3.24+ ve Dart 3.3+ gerekir.

```bash
flutter pub get
flutter run
```

Android/iOS mağaza paketleri için platform klasörleri, imzalama, uygulama kimliği, mağaza görselleri, gizlilik beyanı ve gerçek cihaz testleri tamamlanmalıdır.

## Telif ve içerik ilkeleri
- Harf kartları, metinler, ekran tasarımı ve etkinlik mantığı bu proje için özgün hazırlanır.
- MEB ders kitaplarının sayfa görselleri, metinleri, etkinlikleri, ses kayıtları veya videoları kopyalanmaz.
- Görsel örneklerde sistem emojileri/ikonları ve proje içinde çizilen özgün arayüz kullanılır.
- Sesler uygulamanın kendi kaydı değildir; cihazın işletim sistemi TTS motoru tarafından anlık üretilir.
- Uygulama adı ve ikonunun mağazaya gönderilmeden önce marka/benzerlik araştırması yapılmalıdır.
- Üçüncü taraf paketlerin lisansları ve mağaza politikaları yayın öncesi kontrol edilmelidir.

## Yayın öncesi yapılacaklar
- [ ] Öğretmen incelemesi ve içerik doğrulaması
- [ ] Ses/harf/kelime eşleşmelerinin pedagojik kontrolü
- [ ] Hece, cümle ve kısa metin modüllerinin tamamlanması
- [ ] Gerçek Android/iPhone cihazlarında TTS, çizim ve erişilebilirlik testi
- [ ] Android/iOS platform projeleri, bundle ID ve imzalama
- [ ] Uygulama ikonu, ekran görüntüleri ve mağaza açıklamaları
- [ ] Gizlilik politikası ve mağaza veri beyanları
- [ ] Çocuklara yönelik uygulama ve reklam/analitik kurallarının kontrolü
