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

    -- Takım ismi ekleme, bu işlem TakimBilgileri tablosunda yapılabilir.
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
GO