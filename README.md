# Süperlig Otomasyonu

## Proje Ekibindeki Kişiler:
- 205260050-Metehan TURGUT  
- 205260006-Doğan SONAR
- 215260062-Serhan Burak YAŞAR     

## Dönem Projesi Gereksinimleri

Proje Süperligde bulunan takımların karşılaşmalarını, kupalarını stadlarını görebileceğimiz ve değiştirebileceğimiz şekilde tasarlanmıştır. Şu anda herhangi bir yekilendirilme ve yetkiye göre düzenleme yoktur. Yetkilendirme ve düzenleme işlemleri için gereken tasarımlar ve tablolar prosedürler oluşturulurken yeninden üzerinde durulacak dinamiklerdir:


### Maclar:
Maçlar ayarlanabilecek silinebilecek ve düzenlenebilecek.

### Futbolcu İstatistikleri:
Futbolcular istenilen bilgilere göre sıralanabilecek.

### Lig Durumu:
Takımların maç sonuçlarının dökümü görünebilecek.


## Varlıklar ve Nitelikleri
- Futbolcular (futbolcu_id, isim, dogum_tarihi, mevki, uyruk, takim_id)
- Takimlar (takim_id, isim, teknik_direktor_id, sehir, kurulus_yili)
- TeknikDirektorler (teknik_direktor_id, isim, uyruk, dogum_tarihi)
- Hakemler (hakem_id, isim, uyruk, yonettigi_maclar)
- Stadyumlar (stadyum_id, isim, sehir, kapasite)
- Maclar (mac_id, ev_sahibi, deplasman, tarih, stadyum_id, ev_sahibi_puan, deplasman_puan, hakem)
- FutbolcuIstatistik (futbolcu_id, mac_id, goller, asistler, sari_kartlar, kirmizi_kartlar)
- LigDurumu (takim_id, pozisyon, puanlar, oynandi, kazandi, beraber, maglubiyet, goller, karsi_goller)

## İlişkiler:
- Takimlar 1:N TeknikDirektorler
- Takimlar 1:N Maclar
- Takimlar 1:1 LigDurumu
- Takimlar 1:N Futbolcular
- Maclar N:1 Hakemler
- Maclar N:1 Stadyumlar
- Futbolcular N:M FutbolcuIstatistik

## E-R Diagramı:
![diagram](https://github.com/user-attachments/assets/8f67fd12-4f71-4048-a417-56e386f1cac3)

