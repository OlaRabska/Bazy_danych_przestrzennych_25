CREATE EXTENSION postgis;

--Utworzenie tabeli obiekty
CREATE TABLE obiekty (
	id SERIAL PRIMARY KEY,
	nazwa text,
	geom geometry
);

--Dodanie do tabeli obiektów 1-6
INSERT INTO obiekty (nazwa, geom) VALUES
('obiekt1', ST_GeomFromEWKT('COMPOUNDCURVE((0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1),
CIRCULARSTRING(3 1, 4 2, 5 1), (5 1, 6 1))'));

INSERT INTO obiekty (nazwa, geom) VALUES
('obiekt2', ST_GeomFromEWKT('MULTICURVE(COMPOUNDCURVE((10 6, 14 6),
CIRCULARSTRING(14 6, 16 4, 14 2), CIRCULARSTRING(14 2, 12 0, 10 2), (10 2, 10 6)),
CIRCULARSTRING(11 2, 13 2, 11 2))'));

INSERT INTO obiekty (nazwa, geom) VALUES
('obiekt3', ST_GeomFromEWKT('LINESTRING(7 15, 10 17, 12 13, 7 15)'));

INSERT INTO obiekty (nazwa, geom) VALUES
('obiekt4', ST_GeomFromEWKT('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)'));

INSERT INTO obiekty (nazwa, geom) VALUES
('obiekt5', ST_GeomFromEWKT('MULTIPOINT Z((30 30 59), (38 32 234))'));

INSERT INTO obiekty (nazwa, geom) VALUES
('obiekt6', ST_Collect(ST_GeomFromEWKT('LINESTRING(1 1, 3.2 2)'), ST_GeomFromEWKT('POINT(4.2 2)')));


--POLECENIA 2-5:

--Wyznacz pole powierzchni bufora o wielkości 5 jednostek, który został utworzony wokół 
--najkrótszej linii łączącej obiekt 3 i 4. 

	-- Najkrótsza linia między obiektem3 i obiektem4
	SELECT ST_AsText(ST_ShortestLine(a.geom, b.geom)) AS najkrotsza_linia
	FROM obiekty a, obiekty b
	WHERE a.nazwa = 'obiekt3' AND b.nazwa = 'obiekt4';

	-- Pole powierzchni bufora (5 jednostek) wokół tej linii
	SELECT ST_Area(ST_Buffer(
    ST_ShortestLine(a.geom, b.geom), 
    5
	)) AS pole_bufora
	FROM obiekty a, obiekty b
	WHERE a.nazwa = 'obiekt3' AND b.nazwa = 'obiekt4';


--Zamień obiekt4 na poligon. Jaki warunek musi być spełniony, aby można było wykonać to 
--zadanie? Zapewnij te warunki. 

	--WARUNEK: Aby linia mogła być zamieniona na poligon musi być zamknięta, 
	--tzn. pierwszy punkt musi być taki sam jak ostatni

	UPDATE obiekty
	SET geom = ST_GeomFromEWKT('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20)')
	WHERE nazwa = 'obiekt4';

	--zamiana na poligon
	UPDATE obiekty
	SET geom = ST_MakePolygon(geom)
	WHERE nazwa = 'obiekt4';


--W tabeli obiekty, jako obiekt7 zapisz obiekt złożony z obiektu 3 i obiektu 4. 

	INSERT INTO obiekty (nazwa, geom)
	SELECT 'obiekt7', ST_Collect(a.geom, b.geom) FROM obiekty a, obiekty b
	WHERE a.nazwa = 'obiekt3' AND b.nazwa = 'obiekt4';

--Wyznacz pole powierzchni wszystkich buforów o wielkości 5 jednostek, które zostały utworzone 
--wokół obiektów nie zawierających łuków. 

	--Sprawdzenie geometrii wszystkich punktów
	SELECT nazwa, ST_GeometryType(geom), ST_HasArc(geom)
	FROM obiekty
	ORDER BY id;

	--Wyznaczenie pola
	SELECT SUM(ST_Area(ST_Buffer(geom, 5))) AS "pole powierzchni buforow"
	FROM obiekty WHERE ST_HasArc(geom) = FALSE;
