CREATE TABLE Musteri(
id int identity(1,1) primary key,
ad nvarchar(50) NOT NULL,
soyad nvarchar(50) NOT NULL,
email nvarchar(100) NOT NULL unique,
sehir nvarchar(50) NULL,
kayit_tarihi DATE DEFAULT CAST(GETDATE() AS DATE)
);
CREATE TABLE Kategori(
id int PRIMARY KEY identity(1,1),
ad nvarchar(50) unique not null
);
CREATE TABLE Satici(
id INT PRIMARY KEY identity(1,1),
ad nvarchar(50) not null,
adres nvarchar(200) null);


CREATE TABLE Urun(
id int identity(1,1) primary key,
ad nvarchar(50) NOT NULL,
fiyat DECIMAL(10,2) NOT NULL,
stok INT DEFAULT 0 CHECK(stok>0),
kategori_id INT  ,
satici_id INT,
FOREIGN KEY (kategori_id) REFERENCES Kategori(id),
FOREIGN KEY (satici_id) REFERENCES Satici(id)
);

CREATE TABLE Siparis(
id INT PRIMARY KEY identity(1,1),
musteri_id INT,
tarih DATE DEFAULT CAST(GETDATE() AS DATE),
toplam_tutar DECIMAL(10,2) NOT NULL DEFAULT 0,
odeme_turu NVARCHAR(50),
FOREIGN KEY (musteri_id) REFERENCES Musteri(id)
);

CREATE TABLE Siparis_Detay(
id INT PRIMARY KEY identity(1,1),
siparis_id INT,
urun_id INT,
adet INT CHECK(adet>0),
fiyat DECIMAL(10,2),
FOREIGN KEY (siparis_id) REFERENCES Siparis(id),
FOREIGN KEY (urun_id) REFERENCES Urun(id)
);


INSERT INTO Kategori(ad)
VALUES 
('Elektronik'),
('Giyim'),
('Kitap'),
('Ev & Yaşam');

INSERT INTO Satici
VALUES 
('Teknomarket','Ankara'),
('ModaDünyası','İzmir'),
('KitapEvreni','İstanbul');

INSERT INTO Urun (ad, fiyat, stok, kategori_id, satici_id)
VALUES
('Kulaklık', 450.00, 25, 1, 1),
('Bluetooth Hoparlör', 850.00, 10, 1, 1),
('Tişört', 120.00, 50, 2, 2),
('Roman - Suç ve Ceza', 90.00, 30, 3, 3),
('Kupa Bardak', 50.00, 40, 4, 3);

INSERT INTO Musteri (ad, soyad, email, sehir)
VALUES
('Emir', 'Yeşildağ', 'emir@gmail.com', 'İstanbul'),
('Zeynep', 'Kara', 'zeynep@gmail.com', 'Ankara'),
('Ahmet', 'Demir', 'ahmet@gmail.com', 'İzmir');

-- 🛒 Emir Yeşildağ (id=1) → 2 kulaklık (id=1) + 1 kupa bardak (id=5) siparişi veriyor.

INSERT INTO Siparis(musteri_id,toplam_tutar,odeme_turu)
VALUES (1,950.00,'Kredi Kartı');

INSERT INTO Siparis_Detay(siparis_id,urun_id,adet,fiyat)
VALUES
(1,1,2,450.00),
(1,5,1,50.00);


-- Stok Guncellemesi
UPDATE Urun
SET stok=stok-2
WHERE id = 1 ; -- kulaklık

UPDATE Urun
SET stok=stok-1
WHERE id = 5; -- kupa bardak

select * from Siparis;

SELECT 
    s.id AS SiparisID,
    m.ad + ' ' + m.soyad AS Musteri,
    u.ad AS Urun,
    sd.adet,
    sd.fiyat,
    (sd.adet * sd.fiyat) AS Toplam
FROM Siparis_Detay sd
JOIN Siparis s ON sd.siparis_id = s.id
JOIN Musteri m ON s.musteri_id = m.id
JOIN Urun u ON sd.urun_id = u.id
WHERE s.id = 1;

select * from Musteri

INSERT INTO Siparis(musteri_id,toplam_tutar,odeme_turu)
VALUES (1,180.00,'Nakit');

INSERT INTO Siparis_Detay(siparis_id,urun_id,adet,fiyat)
VALUES
(1,4,2,90.00);
UPDATE Urun
SET stok=stok-2
WHERE id = 4 ;

INSERT INTO Siparis(musteri_id,toplam_tutar,odeme_turu)
VALUES (5,360.00,'Nakit');

INSERT INTO Siparis_Detay(siparis_id,urun_id,adet,fiyat)
VALUES
(1,4,10,90.00);
UPDATE Urun
SET stok=stok-10
WHERE id = 4 ;

INSERT INTO Siparis(musteri_id,toplam_tutar,odeme_turu)
VALUES (6,120.00,'Nakit');

INSERT INTO Siparis_Detay(siparis_id,urun_id,adet,fiyat)
VALUES
(1,3,1,120.00);
UPDATE Urun
SET stok=stok-1
WHERE id = 3 ;

INSERT INTO Siparis(musteri_id,toplam_tutar,odeme_turu)
VALUES (12,600.00,'Nakit');

INSERT INTO Siparis_Detay(siparis_id,urun_id,adet,fiyat)
VALUES
(1,3,5,120.00);
UPDATE Urun
SET stok=stok-5
WHERE id = 3 ;

INSERT INTO Siparis(musteri_id,toplam_tutar,odeme_turu)
VALUES (14,850.00,'Nakit');

INSERT INTO Siparis_Detay(siparis_id,urun_id,adet,fiyat)
VALUES
(1,3,1,850.00);
UPDATE Urun
SET stok=stok-1
WHERE id = 2 ;

SELECT TOP 5
    m.id AS MusteriID,
    m.ad + ' ' + m.soyad AS MusteriAdi,
    COUNT(s.id) AS SiparisSayisi
FROM Siparis s
JOIN Musteri m ON s.musteri_id = m.id
GROUP BY m.id, m.ad, m.soyad
ORDER BY COUNT(s.id) DESC;


SELECT 
    u.ad AS UrunAdi,
    SUM(sd.adet) AS ToplamSatisAdedi
FROM Siparis_Detay sd
JOIN Urun u ON sd.urun_id = u.id
GROUP BY u.ad
ORDER BY SUM(sd.adet) DESC;

SELECT 
    s.id AS SaticiID,
    s.ad AS SaticiAdi,
    SUM(sd.adet * sd.fiyat) AS ToplamCiro
FROM Siparis_Detay sd
JOIN Urun u ON sd.urun_id = u.id
JOIN Satici s ON u.satici_id = s.id
GROUP BY s.id, s.ad
ORDER BY SUM(sd.adet * sd.fiyat) DESC;

SELECT 
    sehir,
    COUNT(id) AS MusteriSayisi
FROM Musteri
GROUP BY sehir
ORDER BY COUNT(id) DESC;

SELECT 
    k.ad AS KategoriAdi,
    SUM(sd.adet * sd.fiyat) AS ToplamSatisTutarı
FROM Siparis_Detay sd
JOIN Urun u ON sd.urun_id = u.id
JOIN Kategori k ON u.kategori_id = k.id
GROUP BY k.ad
ORDER BY SUM(sd.adet * sd.fiyat) DESC;

SELECT 
    FORMAT(tarih, 'yyyy-MM') AS Ay,
    COUNT(id) AS SiparisSayisi
FROM Siparis
GROUP BY FORMAT(tarih, 'yyyy-MM')
ORDER BY Ay;


SELECT 
    s.id AS SiparisID,
    m.ad + ' ' + m.soyad AS MusteriAdi,
    u.ad AS UrunAdi,
    sa.ad AS SaticiAdi,
    sd.adet,
    sd.fiyat,
    (sd.adet * sd.fiyat) AS ToplamTutar,
    s.tarih
FROM Siparis_Detay sd
JOIN Siparis s ON sd.siparis_id = s.id
JOIN Musteri m ON s.musteri_id = m.id
JOIN Urun u ON sd.urun_id = u.id
JOIN Satici sa ON u.satici_id = sa.id
ORDER BY s.id;

SELECT 
    u.id,
    u.ad AS UrunAdi
FROM Urun u
LEFT JOIN Siparis_Detay sd ON u.id = sd.urun_id
WHERE sd.id IS NULL;

SELECT 
    m.id,
    m.ad + ' ' + m.soyad AS MusteriAdi,
    m.email,
    m.sehir
FROM Musteri m
LEFT JOIN Siparis s ON m.id = s.musteri_id
WHERE s.id IS NULL;




