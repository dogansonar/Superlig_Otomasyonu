CREATE DATABASE SuperligOtomasyonu;
GO
USE SuperligOtomasyonu;

CREATE TABLE TeknikDirektorler (
    teknik_direktor_id INT IDENTITY(1,1) PRIMARY KEY,
    isim VARCHAR(255) NOT NULL,
    uyruk VARCHAR(50),
    dogum_tarihi DATE
);

CREATE TABLE Takimlar (
    takim_id INT IDENTITY(1,1) PRIMARY KEY,
    teknik_direktor_id INT,
    FOREIGN KEY (teknik_direktor_id) REFERENCES TeknikDirektorler(teknik_direktor_id)
);

CREATE TABLE TakimBilgileri (
    takim_id INT IDENTITY(1,1) PRIMARY KEY,
    isim VARCHAR(255) NOT NULL,
    sehir VARCHAR(255),
    kurulus_yili INT,
    FOREIGN KEY (takim_id) REFERENCES Takimlar(takim_id)
);

CREATE TABLE Futbolcular (
    futbolcu_id INT IDENTITY(1,1) PRIMARY KEY,
    takim_id INT,
    isim VARCHAR(255) NOT NULL,
    dogum_tarihi DATE,
    mevki VARCHAR(50),
    uyruk VARCHAR(50),
    FOREIGN KEY (takim_id) REFERENCES Takimlar(takim_id)
);

CREATE TABLE Hakemler (
    hakem_id INT IDENTITY(1,1) PRIMARY KEY,
    isim VARCHAR(255) NOT NULL,
    uyruk VARCHAR(50),
    yonettigi_maclar INT DEFAULT 0
);

CREATE TABLE Stadyumlar (
    stadyum_id INT IDENTITY(1,1) PRIMARY KEY,
    isim VARCHAR(255) NOT NULL,
    sehir VARCHAR(255),
    kapasite INT
);

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
GO
CREATE TRIGGER KontrolEtTeknikDirektor
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
GO
CREATE TRIGGER KontrolEtFutbolcuYasi
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
GO
CREATE TRIGGER KontrolEtDogumTarihi
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
GO
CREATE TRIGGER FutbolcuIstatistikGuncelle
ON Maclar
FOR UPDATE
AS
BEGIN
    DECLARE @mac_id INT;
    DECLARE @ev_sahibi_puan INT;
    DECLARE @deplasman_puan INT;
    
    SELECT @mac_id = mac_id, @ev_sahibi_puan = ev_sahibi_puan, @deplasman_puan = deplasman_puan
    FROM inserted;
    
    UPDATE FutbolcuIstatistik
    SET goller = goller + (SELECT COUNT(*) FROM Futbolcular
                           WHERE takim_id = (SELECT ev_sahibi FROM Maclar WHERE mac_id = @mac_id) 
                           AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND goller > 0)),
        asistler = asistler + (SELECT COUNT(*) FROM Futbolcular
                           WHERE takim_id = (SELECT ev_sahibi FROM Maclar WHERE mac_id = @mac_id) 
                           AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND asistler > 0))
    WHERE mac_id = @mac_id;

    UPDATE FutbolcuIstatistik
    SET goller = goller + (SELECT COUNT(*) FROM Futbolcular
                           WHERE takim_id = (SELECT deplasman FROM Maclar WHERE mac_id = @mac_id) 
                           AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND goller > 0)),
        asistler = asistler + (SELECT COUNT(*) FROM Futbolcular
                           WHERE takim_id = (SELECT deplasman FROM Maclar WHERE mac_id = @mac_id) 
                           AND futbolcu_id IN (SELECT futbolcu_id FROM FutbolcuIstatistik WHERE mac_id = @mac_id AND asistler > 0))
    WHERE mac_id = @mac_id;
    
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

GO
ALTER TABLE TakimBilgileri
ADD CONSTRAINT CHK_KurulusYili CHECK (kurulus_yili > 1800 AND kurulus_yili <= YEAR(GETDATE()));

ALTER TABLE Futbolcular
ADD CONSTRAINT CHK_Mevki CHECK (mevki IN ('Forvet', 'Orta Saha', 'Defans', 'Kaleci'));

ALTER TABLE Hakemler
ADD CONSTRAINT CHK_YonettigiMaclar CHECK (yonettigi_maclar >= 0);

ALTER TABLE Stadyumlar
ADD CONSTRAINT CHK_Kapasite CHECK (kapasite > 0);

ALTER TABLE Maclar
ADD CONSTRAINT CHK_Puanlar CHECK (ev_sahibi_puan >= 0 AND deplasman_puan >= 0);

ALTER TABLE FutbolcuIstatistik
ADD CONSTRAINT CHK_Goller CHECK (goller >= 0 AND asistler >= 0);

ALTER TABLE LigDurumu
ADD CONSTRAINT CHK_LigDurumu CHECK (puanlar >= 0 AND oynandi >= 0 AND kazandi >= 0 AND beraber >= 0 AND maglubiyet >= 0);

GO
CREATE PROCEDURE AddTeknikDirektor
    @isim VARCHAR(255),
    @uyruk VARCHAR(50),
    @dogum_tarihi DATE
AS
BEGIN
    INSERT INTO TeknikDirektorler (isim, uyruk, dogum_tarihi)
    VALUES (@isim, @uyruk, @dogum_tarihi);
END;
GO
CREATE PROCEDURE AddTakim
    @teknik_direktor_id INT,
    @isim VARCHAR(255)
AS
BEGIN
    INSERT INTO Takimlar (teknik_direktor_id)
    VALUES (@teknik_direktor_id);

    INSERT INTO TakimBilgileri (isim)
    VALUES (@isim);
END;
GO
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
GO
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
GO
CREATE PROCEDURE AddHakem
    @isim VARCHAR(255),
    @uyruk VARCHAR(50)
AS
BEGIN
    INSERT INTO Hakemler (isim, uyruk)
    VALUES (@isim, @uyruk);
END;
GO
CREATE PROCEDURE AddStadyum
    @isim VARCHAR(255),
    @sehir VARCHAR(255),
    @kapasite INT
AS
BEGIN
    INSERT INTO Stadyumlar (isim, sehir, kapasite)
    VALUES (@isim, @sehir, @kapasite);
END;
GO
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
GO
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
GO
CREATE PROCEDURE UpdateMacSonucu
    @mac_id INT,
    @ev_sahibi_puan INT,
    @deplasman_puan INT
AS
BEGIN
    UPDATE Maclar
    SET ev_sahibi_puan = @ev_sahibi_puan,
        deplasman_puan = @deplasman_puan
    WHERE mac_id = @mac_id;

    DECLARE @ev_sahibi INT, @deplasman INT;
    SELECT @ev_sahibi = ev_sahibi, @deplasman = deplasman FROM Maclar WHERE mac_id = @mac_id;

    UPDATE LigDurumu
    SET puanlar = puanlar + @ev_sahibi_puan
    WHERE takim_id = @ev_sahibi;

    UPDATE LigDurumu
    SET puanlar = puanlar + @deplasman_puan
    WHERE takim_id = @deplasman;
END;
GO