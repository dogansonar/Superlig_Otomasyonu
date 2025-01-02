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
