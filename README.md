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


## Normalizasyon Süreci

### 1NF Ayrıştırma:
Bütün kolonlar atomik olduğundan dolayı 1NF

### 2NF Ayrıştırma:
- FutbolcuIstatistik tablosunda her kolon birincil anahtara bağlı 2NF
- LigDurumu tablosunda her kolon doğrudan takim_id ile bağımlı kısmi bağılılık yok 2NF

### 3NF Ayrıştırma:
- Takimlar tablosu Takimlar ve TakimBilgileri olarak iki ayrı tabloya ayrışır. Transitif bağımlılık ortadan kaldırılır. (isim -> sehir, kurulus_yili)
	- Takimlar (takim_id, teknik_direktor_id),
	- TakimBilgileri (takim_id, isim, sehir, kurulus_yili)
### BCNF Ayrıştırma:
Tüm tabloların her determinantı bir aday anahtarı olduğu için BCNF

Şema bu şekilde 3NF hale getirilir.

### Normalizasyon Sonrası İlişkiler:
- Takimlar 1:N TeknikDirektorler
- Takimlar 1:1 TakimBilgileri
- Takimlar 1:N Maclar
- Takimlar 1:1 LigDurumu
- Takimlar 1:N Futbolcular
- Maclar N:1 Hakemler
- Maclar N:1 Stadyumlar
- Futbolcular N:M FutbolcuIstatistik

## SQL Kodları
<pre>
-- Veritabanı Oluşturulur
CREATE DATABASE SuperligOtomasyonu;
<pre>
<pre>

USE SuperligOtomasyonu;

-- Teknik Direktörler Tablosu Oluşturulur
CREATE TABLE TeknikDirektorler (
    teknik_direktor_id INT IDENTITY(1,1) PRIMARY KEY,
    isim VARCHAR(255) NOT NULL,
    uyruk VARCHAR(50),
    dogum_tarihi DATE
);

-- Takımlar Tablosu Oluşturulur
CREATE TABLE Takimlar (
    takim_id INT IDENTITY(1,1) PRIMARY KEY,
    teknik_direktor_id INT,
    FOREIGN KEY (teknik_direktor_id) REFERENCES TeknikDirektorler(teknik_direktor_id)
);

-- Takım Bilgileri Tablosu Oluşturulur
CREATE TABLE TakimBilgileri (
    takim_id INT IDENTITY(1,1) PRIMARY KEY,
    isim VARCHAR(255) NOT NULL,
    sehir VARCHAR(255),
    kurulus_yili INT,
    FOREIGN KEY (takim_id) REFERENCES Takimlar(takim_id)
);

-- Futbolcular Tablosu Oluşuturulur
CREATE TABLE Futbolcular (
    futbolcu_id INT IDENTITY(1,1) PRIMARY KEY,
    takim_id INT,
    isim VARCHAR(255) NOT NULL,
    dogum_tarihi DATE,
    mevki VARCHAR(50),
    uyruk VARCHAR(50),
    FOREIGN KEY (takim_id) REFERENCES Takimlar(takim_id)
);

-- Hakemler Tablosu Oluşuturulur
CREATE TABLE Hakemler (
    hakem_id INT IDENTITY(1,1) PRIMARY KEY,
    isim VARCHAR(255) NOT NULL,
    uyruk VARCHAR(50),
    yonettigi_maclar INT DEFAULT 0
);

-- Stadyumlar Tablosu Oluşuturulur
CREATE TABLE Stadyumlar (
    stadyum_id INT IDENTITY(1,1) PRIMARY KEY,
    isim VARCHAR(255) NOT NULL,
    sehir VARCHAR(255),
    kapasite INT
);

-- Maçlar Tablosu Oluşuturulur
CREATE TABLE Maclar (
    mac_id INT IDENTITY(1,1) PRIMARY KEY,
    ev_sahibi INT,
    deplasman INT,
    tarih DATETIME,
    stadyum_id INT,
    ev_sahibi_puan INT,
    deplasman_puan INT,
    hakem INT,
    FOREIGN KEY (ev_sahibi) REFERENCES Takimlar(takim_id),
    FOREIGN KEY (deplasman) REFERENCES Takimlar(takim_id),
    FOREIGN KEY (stadyum_id) REFERENCES Stadyumlar(stadyum_id),
    FOREIGN KEY (hakem) REFERENCES Hakemler(hakem_id)
);

-- Futbolcu İstatistikleri Tablosu Oluşuturulur
CREATE TABLE FutbolcuIstatistik (
    futbolcu_id INT,
    mac_id INT,
    goller INT DEFAULT 0,
    asistler INT DEFAULT 0,
    sari_kartlar INT DEFAULT 0,
    kirmizi_kartlar INT DEFAULT 0,
    PRIMARY KEY (futbolcu_id, mac_id),
    FOREIGN KEY (futbolcu_id) REFERENCES Futbolcular(futbolcu_id),
    FOREIGN KEY (mac_id) REFERENCES Maclar(mac_id)
);

-- Ligdeki İlerlemeler Tablosu Oluşuturulur
CREATE TABLE LigDurumu (
    takim_id INT,
    pozisyon INT,
    puanlar INT DEFAULT 0,
    oynandi INT DEFAULT 0,
    kazandi INT DEFAULT 0,
    beraber INT DEFAULT 0,
    maglubiyet INT DEFAULT 0,
    goller INT DEFAULT 0,
    karsi_goller INT DEFAULT 0,
    PRIMARY KEY (takim_id),
    FOREIGN KEY (takim_id) REFERENCES Takimlar(takim_id)
);

<pre>