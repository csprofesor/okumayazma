# Minik Okur — İlk Okuma Yazma

1. sınıf öğrencileri için Türkçe ses esaslı ilk okuma yazma sürecini destekleyen Flutter uygulaması.

## Mevcut prototip
- MEB'in resmî beş ses grubunu korur; uygulama içindeki açılma sırası resmî tema akışına göre düzenlenmiştir.
- Harf kartları, büyük/küçük harf gösterimi, örnek kelimeler ve cihaz TTS seslendirmesi içerir.
- TTS düğmesi harfin adını ve kelimelerin telaffuzunu okur. Harf adı ile sesbirim aynı şey olmadığından ünsüz ses öğretimi için TTS tek başına kullanılmaz.
- Dört öğrenme aşaması sırayla açılır; sonraki aşama önceki aşamadaki harfler tamamlanınca açılır.
- Hece, kelime ve cümle alıştırmaları yalnızca o aşamada öğrenilmiş harflerle sınırlıdır.
- Dinle ve harfi bul oyunu ile harfi içeren kelimeyi görselden seçme oyunu yalnızca açılmış aşamalardaki içerikleri kullanır.
- Küçük/büyük harf seçilebilen parmakla yazma alanı, özgün Material ikonlu kelime kartları ve veli bilgilendirme ekranı içerir.
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

## Çalıştırma
Flutter 3.24+ ve Dart 3.3+ gerekir.

```bash
bash tool/bootstrap.sh
flutter run
```

\`bash tool/bootstrap.sh\` komutu Android/iOS yerel proje klasörlerini üretir ve paketleri indirir. Android/iOS mağaza paketleri için imzalama, uygulama kimliği, mağaza görselleri, gizlilik beyanı ve gerçek cihaz testleri ayrıca tamamlanmalıdır.

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
- [ ] Daha geniş seviyelendirilmiş kısa metin ve dinlediğini anlama modülü
- [ ] Gerçek Android/iPhone cihazlarında TTS, çizim ve erişilebilirlik testi
- [ ] Android/iOS platform projeleri, bundle ID ve imzalama
- [ ] Uygulama ikonu, ekran görüntüleri ve mağaza açıklamaları
- [ ] Gizlilik politikası ve mağaza veri beyanları
- [ ] Çocuklara yönelik uygulama ve reklam/analitik kurallarının kontrolü
