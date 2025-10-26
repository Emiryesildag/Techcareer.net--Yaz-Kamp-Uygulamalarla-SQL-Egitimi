CREATE DATABASE KUTUPHANE;
CREATE TABLE BOOKS(
	book_id INT IDENTITY(1,1) PRIMARY KEY,
	title NVARCHAR(200) NOT NULL,
	author NVARCHAR(100) NOT NULL,
	genre NVARCHAR(50),
	price DECIMAL(6,2) check (price > 0),--DECIMAL(toplam basamak, virgulden sonra basamak)
	stock INT check (stock >= 0),
	published_year INT, --check (published_year BETWEEN 1900 AND 2025), sene aralıgı varsa
	added_at DATE
);
INSERT INTO BOOKS(title, author, genre, price, stock, published_year, added_at)
VALUES 
('Kayıp Zamanın İzinde','M. Proust','roman',129.90,25,1913,'2025-08-20'),
('Simyacı','P. Coelho','roman',89.50,40,1988,'2025-08-21'),
('Sapiens','Y. N. Harari','tarih',159.00,18,2011,'2025-08-25'),
('İnce Memed','Y. Kemal','roman',99.90,12,1955,'2025-08-22'),
('Körlük','J. Saramago','roman',119.00,7,1995,'2025-08-28'),
('Dune','F. Herbert','bilim',149.00,30,1965,'2025-09-01'),
('Hayvan Çiftliği','G. Orwell','roman',79.90,55,1945,'2025-08-23'),
('1984','G. Orwell','roman',99.00,35,1949,'2025-08-24'),
('Nutuk','M. K. Atatürk','tarih',139.00,20,1927,'2025-08-27'),
('Küçük Prens','A. de Saint-Exupéry','çocuk',69.90,80,1943,'2025-08-26'),
('Başlangıç','D. Brown','roman',109.00,22,2017,'2025-09-02'),
('Atomik Alışkanlıklar','J. Clear','kişisel gelişim',129.00,28,2018,'2025-09-03'),
('Zamanın Kısa Tarihi','S. Hawking','bilim',119.50,16,1988,'2025-08-29'),
('Şeker Portakalı','J. M. de Vasconcelos','roman',84.90,45,1968,'2025-08-30'),
('Bir İdam Mahkûmunun Son Günü','V. Hugo','roman',74.90,26,1829,'2025-08-31');

SElECT * FROM  BOOKS;

--1. Tüm kitapların title, author, price alanlarını fiyatı artan şekilde sıralayarak listeleyin
SELECT title, author, price
FROM BOOKS
ORDER BY price ASC; -- ascending : artan, DESC descending: azalan

--2. Türü 'roman' olan kitapları A→Z title sırasıyla gösterin.
SELECT * FROM BOOKS
WHERE genre = 'roman'
ORDER BY title ASC;

--3. Fiyatı 80 ile 120 (dahil) arasındaki kitapları listeleyin (BETWEEN).

SELECT * FROM BOOKS
WHERE price BETWEEN 80 AND 120 

--4. Stok adedi 20’den az olan kitapları bulun (title, stock_qty)

SELECT title,stock 
FROM BOOKS
WHERE stock <20;

--5. title içinde 'zaman' geçen kitapları LIKE ile filtreleyin (büyük/küçük harf durumunu not edin).

SELECT * FROM BOOKS
WHERE title LIKE '%zaman%'; -- (basta karakter olabilir)%zaman%(sonda karakter olabilir) _____ 5 karakterlileri filtreler

--6. genre değeri 'roman' veya 'bilim' olanları IN ile listeleyin.

SELECT * FROM BOOKS
WHERE genre IN ('roman','bilim')-- genre = 'roman' veya genre = 'bilim' olanları cagırır bilim or roman gibi düşün

--7. published_year değeri 2000 ve sonrası olan kitapları, en yeni yıldan eskiye doğru sıralayın.
SELECT * FROM BOOKS
WHERE published_year > 2000
ORDER BY published_year DESC;

-- 8.Son 10 gün içinde eklenen kitapları bulun (added_at tarihine göre).
SELECT * FROM BOOKS
WHERE added_at >= DATEADD (DAY,-10, GETDATE())

-- 9. En pahalı 5 kitabı price azalan sırada listeleyin (LIMIT 5).
SELECT TOP 5 * FROM BOOKS
ORDER BY price DESC

--10. Stok adedi 30 ile 60 arasında olan kitapları price artan şekilde sıralayın.

SELECT * FROM BOOKS
WHERE stock between 30 and 60
ORDER BY price ASC;
