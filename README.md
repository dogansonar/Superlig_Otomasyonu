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
</pre>

## Tetikleyiciler

### Teknik direktörlerin doğum tarihlerini kontrol eden trigger
<pre>
CREATE TRIGGER CheckDogumTarihi
ON TeknikDirektorler
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @dogum_tarihi DATE;
    SELECT @dogum_tarihi = dogum_tarihi FROM inserted;
    
    IF @dogum_tarihi > GETDATE()
    BEGIN
        RAISERROR('Doğum tarihi gelecekte olamaz.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
</pre>
### Takımların teknik direktörlerinin olup olmadığını kontol eden trigger
<pre>
CREATE TRIGGER CheckTeknikDirektor
ON Takimlar
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @teknik_direktor_id INT;
    SELECT @teknik_direktor_id = teknik_direktor_id FROM inserted;
    
    IF NOT EXISTS (SELECT 1 FROM TeknikDirektorler WHERE teknik_direktor_id = @teknik_direktor_id)
    BEGIN
        RAISERROR('Takım için geçerli bir teknik direktör bulunmuyor.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
</pre>

### Futbolcuların yaşının 16'dan büyük olup olmadığını kontrol eden trigger
<pre>
CREATE TRIGGER CheckFutbolcuYasi
ON Futbolcular
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @dogum_tarihi DATE;
    DECLARE @yas INT;
    SELECT @dogum_tarihi = dogum_tarihi FROM inserted;
    
    SET @yas = DATEDIFF(YEAR, @dogum_tarihi, GETDATE());
    IF @yas < 16
    BEGIN
        RAISERROR('Futbolcu 16 yaşından küçük olamaz.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
</pre>

### Maçlardan sonra çeşitli güncellemeler yapan tetikleyici
<pre>
CREATE TRIGGER UpdateFutbolcuIstatistik
ON Maclar
FOR UPDATE
AS
BEGIN
    DECLARE @mac_id INT;
    DECLARE @ev_sahibi_puan INT;
    DECLARE @deplasman_puan INT;
    
    -- Maç bilgilerini alıyoruz
    SELECT @mac_id = mac_id, @ev_sahibi_puan = ev_sahibi_puan, @deplasman_puan = deplasman_puan
    FROM inserted;
    
    -- Ev sahibi takımının futbolcularının istatistiklerini güncelleme
    UPDATE FutbolcuIstatistik
    SET goller = goller + (SELECT COUNT(*) FROM Futbolcular
                           WHERE takim_id = (SELECT ev_sahibi FROM Maclar WHERE mac_id = @mac_id) 
                           AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND goller > 0)),
        asistler = asistler + (SELECT COUNT(*) FROM Futbolcular
                           WHERE takim_id = (SELECT ev_sahibi FROM Maclar WHERE mac_id = @mac_id) 
                           AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND asistler > 0))
    WHERE mac_id = @mac_id;

    -- Deplasman takımının futbolcularının istatistiklerini güncelleme
    UPDATE FutbolcuIstatistik
    SET goller = goller + (SELECT COUNT(*) FROM Futbolcular
                           WHERE takim_id = (SELECT deplasman FROM Maclar WHERE mac_id = @mac_id) 
                           AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND goller > 0)),
        asistler = asistler + (SELECT COUNT(*) FROM Futbolcular
                           WHERE takim_id = (SELECT deplasman FROM Maclar WHERE mac_id = @mac_id) 
                           AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND asistler > 0))
    WHERE mac_id = @mac_id;
    
    -- Gol sayısı, asist sayısı vb. gibi istatistiklerin güncellenmesi
    -- Sarı kart, kırmızı kart gibi istatistiklerin güncellenmesi için benzer işlemleri yapabilirsiniz.

    -- Örneğin, sarı kartları güncelleme
    UPDATE FutbolcuIstatistik
    SET sari_kartlar = sari_kartlar + (SELECT COUNT(*) FROM Futbolcular
                                       WHERE takim_id = (SELECT ev_sahibi FROM Maclar WHERE mac_id = @mac_id) 
                                       AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND sari_kartlar > 0))
    WHERE mac_id = @mac_id;

    UPDATE FutbolcuIstatistik
    SET sari_kartlar = sari_kartlar + (SELECT COUNT(*) FROM Futbolcular
                                       WHERE takim_id = (SELECT deplasman FROM Maclar WHERE mac_id = @mac_id) 
                                       AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND sari_kartlar > 0))
    WHERE mac_id = @mac_id;

    -- Kırmızı kartları güncelleme
    UPDATE FutbolcuIstatistik
    SET kirmizi_kartlar = kirmizi_kartlar + (SELECT COUNT(*) FROM Futbolcular
                                             WHERE takim_id = (SELECT ev_sahibi FROM Maclar WHERE mac_id = @mac_id) 
                                             AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND kirmizi_kartlar > 0))
    WHERE mac_id = @mac_id;

    UPDATE FutbolcuIstatistik
    SET kirmizi_kartlar = kirmizi_kartlar + (SELECT COUNT(*) FROM Futbolcular
                                             WHERE takim_id = (SELECT deplasman FROM Maclar WHERE mac_id = @mac_id) 
                                             AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND kirmizi_kartlar > 0))
    WHERE mac_id = @mac_id;

END;
</pre>

## Constraints

### Takımların kuruluş yılını kontrol etmek için constraint
<pre>
ALTER TABLE TakimBilgileri
ADD CONSTRAINT CHK_KurulusYili CHECK (kurulus_yili > 1800 AND kurulus_yili <= YEAR(GETDATE()));
</pre>

### Futbolcuların mevkisini kontrol etmek için constraint
<pre>
ALTER TABLE Futbolcular
ADD CONSTRAINT CHK_Mevki CHECK (mevki IN ('Forvet', 'Orta Saha', 'Defans', 'Kaleci'));
</pre>

### Hakemlerin yönettiği maç sayısının negatif olup olmadığını kontrol etmek için constraint
<pre>
ALTER TABLE Hakemler
ADD CONSTRAINT CHK_YonettigiMaclar CHECK (yonettigi_maclar >= 0);
</pre>

### Stadyumların kapasitesini kontrol etmek için constraint
<pre>
ALTER TABLE Stadyumlar
ADD CONSTRAINT CHK_Kapasite CHECK (kapasite > 0);
</pre>

### takımların puanlarının negatif olup olmadığını kontrol etmek için constraint
<pre>
ALTER TABLE Maclar
ADD CONSTRAINT CHK_Puanlar CHECK (ev_sahibi_puan >= 0 AND deplasman_puan >= 0);
</pre>

### Futbolcuların asist ve gol sayısının negatif olup olmadığını kontrol etmek için constraint
<pre>
ALTER TABLE FutbolcuIstatistik
ADD CONSTRAINT CHK_Goller CHECK (goller >= 0 AND asistler >= 0);
</pre>

### Lig Durumunu kontrol etmemiz gerek
<pre>
ALTER TABLE LigDurumu
ADD CONSTRAINT CHK_LigDurumu CHECK (puanlar >= 0 AND oynandi >= 0 AND kazandi >= 0 AND beraber >= 0 AND maglubiyet >= 0);
</pre>

## Prosedürler

### Teknik Direktör Ekleyen Prosedür
<pre>
CREATE PROCEDURE AddTeknikDirektor
    @isim VARCHAR(255),
    @uyruk VARCHAR(50),
    @dogum_tarihi DATE
AS
BEGIN
    INSERT INTO TeknikDirektorler (isim, uyruk, dogum_tarihi)
    VALUES (@isim, @uyruk, @dogum_tarihi);
END;
</pre>

### Takım Ekleyen Prosedür
<pre>
CREATE PROCEDURE AddTakim
    @teknik_direktor_id INT,
    @isim VARCHAR(255)
AS
BEGIN
    INSERT INTO Takimlar (teknik_direktor_id)
    VALUES (@teknik_direktor_id);

    -- Takım ismi ekleme, bu işlem TakimBilgileri tablosunda yapılabilir.
    INSERT INTO TakimBilgileri (isim)
    VALUES (@isim);
END;
</pre>

### Futbolcu Ekleyen Prosedür
<pre>
CREATE PROCEDURE AddFutbolcu
    @takim_id INT,
    @isim VARCHAR(255),
    @dogum_tarihi DATE,
    @mevki VARCHAR(50),
    @uyruk VARCHAR(50)
AS
BEGIN
    INSERT INTO Futbolcular (takim_id, isim, dogum_tarihi, mevki, uyruk)
    VALUES (@takim_id, @isim, @dogum_tarihi, @mevki, @uyruk);
END;
</pre>

### Futbolcu Istatisiği Ekleyen Prosedür 
<pre>
CREATE PROCEDURE AddFutbolcuIstatistik
    @futbolcu_id INT,
    @mac_id INT,
    @goller INT = 0,
    @asistler INT = 0,
    @sari_kartlar INT = 0,
    @kirmizi_kartlar INT = 0
AS
BEGIN
    INSERT INTO FutbolcuIstatistik (futbolcu_id, mac_id, goller, asistler, sari_kartlar, kirmizi_kartlar)
    VALUES (@futbolcu_id, @mac_id, @goller, @asistler, @sari_kartlar, @kirmizi_kartlar);
END;
</pre>

### Hakem Ekleyen Prosedür 
<pre>
CREATE PROCEDURE AddHakem
    @isim VARCHAR(255),
    @uyruk VARCHAR(50)
AS
BEGIN
    INSERT INTO Hakemler (isim, uyruk)
    VALUES (@isim, @uyruk);
END;
</pre>

### Stadyum Ekleyen Prosedür 
<pre>
CREATE PROCEDURE AddStadyum
    @isim VARCHAR(255),
    @sehir VARCHAR(255),
    @kapasite INT
AS
BEGIN
    INSERT INTO Stadyumlar (isim, sehir, kapasite)
    VALUES (@isim, @sehir, @kapasite);
END;
</pre>

### Maç Ekleyen Prosedür 
<pre>
CREATE PROCEDURE AddMac
    @ev_sahibi INT,
    @deplasman INT,
    @tarih DATETIME,
    @stadyum_id INT,
    @ev_sahibi_puan INT,
    @deplasman_puan INT,
    @hakem INT
AS
BEGIN
    INSERT INTO Maclar (ev_sahibi, deplasman, tarih, stadyum_id, ev_sahibi_puan, deplasman_puan, hakem)
    VALUES (@ev_sahibi, @deplasman, @tarih, @stadyum_id, @ev_sahibi_puan, @deplasman_puan, @hakem);
END;
</pre>

### Lig Durumunu Güncelleyen Prosedür
<pre>
CREATE PROCEDURE UpdateLigDurumu
    @takim_id INT,
    @pozisyon INT,
    @puanlar INT,
    @oynandi INT,
    @kazandi INT,
    @beraber INT,
    @maglubiyet INT,
    @goller INT,
    @karsi_goller INT
AS
BEGIN
    UPDATE LigDurumu
    SET pozisyon = @pozisyon,
        puanlar = @puanlar,
        oynandi = @oynandi,
        kazandi = @kazandi,
        beraber = @beraber,
        maglubiyet = @maglubiyet,
        goller = @goller,
        karsi_goller = @karsi_goller
    WHERE takim_id = @takim_id;
END;
</pre>

### Maç Sonucunu Güncelleyen Prosedür
<pre>
CREATE PROCEDURE UpdateMacSonucu
    @mac_id INT,
    @ev_sahibi_puan INT,
    @deplasman_puan INT
AS
BEGIN
    -- Maçın sonucunu günceller
    UPDATE Maclar
    SET ev_sahibi_puan = @ev_sahibi_puan,
        deplasman_puan = @deplasman_puan
    WHERE mac_id = @mac_id;

    -- Lig durumu tablosunu günceller
    DECLARE @ev_sahibi INT, @deplasman INT;
    SELECT @ev_sahibi = ev_sahibi, @deplasman = deplasman FROM Maclar WHERE mac_id = @mac_id;

    -- Ev sahibi takımın lig durumunu güncelleme
    UPDATE LigDurumu
    SET puanlar = puanlar + @ev_sahibi_puan
    WHERE takim_id = @ev_sahibi;

    -- Deplasman takımının lig durumunu güncelleme
    UPDATE LigDurumu
    SET puanlar = puanlar + @deplasman_puan
    WHERE takim_id = @deplasman;
END;
</pre>

## Test Sorguları ile kodların çalışıp çalışmadığını kontrol edebilirsiniz
<pre>
use SuperligOtomasyonu;

EXEC AddTeknikDirektor 'Fatih Terim', 'Türkiye', '1953-09-04';
EXEC AddTeknikDirektor 'Pep Guardiola', 'İspanya', '1971-01-18';
EXEC AddTeknikDirektor 'Jürgen Klopp', 'Almanya', '2025-13-01'; -- Hatalı tarih formatı
EXEC AddTakim 1, 'Galatasaray';
EXEC AddTakim 2, 'Barcelona';
EXEC AddTakim 999, 'Hatalı Takım'; -- Teknik direktör ID bulunmuyor
EXEC AddFutbolcu 1, 'Lionel Messi', '1987-06-24', 'Forvet', 'Arjantin';
EXEC AddFutbolcu 2, 'Gerard Pique', '1987-02-02', 'Defans', 'İspanya';
EXEC AddFutbolcu 999, 'Cristiano Ronaldo', '1985-02-05', 'Forvet', 'Portekiz'; -- Takım ID mevcut değil
EXEC AddHakem 'Cüneyt Çakır', 'Türkiye';
EXEC AddHakem 'Bjorn Kuipers', 'Hollanda';
EXEC AddHakem NULL, 'Türkiye'; -- Hakem ismi NULL olamaz
EXEC AddStadyum 'Camp Nou', 'Barcelona', 99354;
EXEC AddStadyum 'Türk Telekom Arena', 'İstanbul', 52650;
EXEC AddStadyum 'Hatalı Stadyum', 'İstanbul', -5000; -- Kapasite negatif olamaz
EXEC AddMac 1, 2, '2025-01-15 20:00:00', 1, 3, 1, 1; -- Galatasaray ve Barcelona arasında bir maç
EXEC AddMac 999, 2, '2025-01-15 20:00:00', 1, 3, 1, 1; -- Ev sahibi takım mevcut değil
EXEC AddFutbolcuIstatistik 1, 1, 2, 1, 0, 0; -- Messi 2 gol, 1 asist yaptı
EXEC AddFutbolcuIstatistik 2, 1, 0, 0, 1, 0; -- Pique 1 sarı kart aldı
EXEC AddFutbolcuIstatistik 999, 1, 1, 0, 0, 0; -- Futbolcu ID mevcut değil
EXEC UpdateLigDurumu 1, 1, 3, 1, 1, 0, 0, 2, 0; -- Galatasaray 3 puan kazandı
EXEC UpdateLigDurumu 2, 2, 1, 1, 0, 1, 0, 1, 2; -- Barcelona 1 puan kazandı
EXEC UpdateLigDurumu 999, 3, 0, 1, 0, 0, 1, 0, 2; -- Takım ID mevcut değil
<pre>