
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
