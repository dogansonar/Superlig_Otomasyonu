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