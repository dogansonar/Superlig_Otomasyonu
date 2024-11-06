# Süperlig Otomasyonu

## Proje Ekibindeki Kişiler:
- 205260050-Metehan TURGUT  
- 205260006-Doğan SONAR
- 215260062-Serhan Burak YAŞAR     

## Dönem Projesi Gereksinimleri

Proje Süperligde bulunan takımların karşılaşmalarını, kupalarını stadlarını görebileceğimiz ve değiştirebileceğimiz şekilde tasarlanmıştır. Şu anda herhangi bir yekilendirilme ve yetkiye göre düzenleme yoktur. Yetkilendirme ve düzenleme işlemleri için gereken tasarımlar ve tablolar prosedürler oluşturulurken yeninden üzerinde durulacak dinamiklerdir:

### Fiyatlandırma:
Kulüp başkanları, takımlarındaki oyuncuların ve teknik direktörlerin fiyatlarını değiştirebilir. oyuncu ekleyebilir ve teknik direktörleri değiştirebilirler. Bu değiştirme işlemi sırasında federasyon tarafından üretilecek olan kabul kodunu kullanmaları zorunludur.

### Karşılaşma:
Federasyon karşılaşma ekleyip silebilir ve karşılaşma sonucunu belirleyebilir. Takımların uygun ortak saatlerine göre maç saatlerini değiştirebilir. Gereken durumlarda oyuncu ve teknik direktörler üzerinde değişim yapabilirler. Veritabanı sisteminin adminleridir.

### Kupa:
Kupalar, Her dönem sonu Liderlik tablosuna göre birinci sıradaki takıma otomatik olarak atanır.

### Liderlik Tablosu:
Liderlik Tablosu karşılaşma sonuçlarına göre Kazanan takıma 3, kaybeden takıma 0, berabere kalan her bir takıma 1 puanı otomatik olarak atar.

## Varlıklar ve Nitelikleri
- Futbolcular (id, ad, soyad, takim_id, fiyat),
- Takimlar (id, isim, teknik_direktor_id),
- TeknikDirektorler (id, isim, soyisim, fiyat),
- Kupalar (id, isim, takim_id, alinma_tarihi),
- Stadlar (id, isim, takim_id, kapasite),
- Karsilasmalar (id, stad_id, deplasman, kazanan)
- LiderlikTablosu (sira, takim_id, puan)

## İlişkiler:
- Takimlar 1:N Kupalar
- Takimlar 1:1 TeknikDirektorler
- Takimlar 1:N Futbolcular
- Takimlar 1:1 LiderlikTablosu 
- Takimlar 1:1 Stadlar
- Takimlar N:1 Karsilasmalar 
- Stadlar N:1 Karsilasmalar

## E-R Diagramı:
![diagram](https://github.com/user-attachments/assets/c1e9979d-f0fa-4a24-ba2f-f63a8de475f6)

