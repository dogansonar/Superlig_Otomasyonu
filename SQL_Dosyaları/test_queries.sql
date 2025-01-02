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
