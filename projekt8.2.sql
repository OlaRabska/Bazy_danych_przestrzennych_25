CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;

--2. Załaduj dane do tabeli o nazwie uk_250k.

--"C:\Program Files\PostgreSQL\18\bin\raster2pgsql.exe" -s 27700 -d -I -C -M "E:\studia\Semestr 5\Bazy danych przestrzennych\Cwiczenia 8\ras250_gb\data\*.tif" public.uk_250k | "C:\Program Files\PostgreSQL\18\bin\psql.exe" -d cwiczenie8.2 -h localhost -U postgres -p 5432


--3. Połącz dane (wszystkie kafle) w mozaikę, a następnie wyeksportuj jako GeoTIFF.

--Polączenie wszystkich kafli na raz nie było w stanie się wykonać, 
--dlatego proces został podzielony na mniejsze kawałki.

CREATE TABLE mosaic_part1 AS
SELECT ST_Union(rast) AS rast
FROM uk_250k
WHERE rid BETWEEN 1 AND 10;

CREATE TABLE mosaic_part2 AS
SELECT ST_Union(rast) AS rast
FROM uk_250k
WHERE rid BETWEEN 11 AND 20;

CREATE TABLE mosaic_part3 AS
SELECT ST_Union(rast) AS rast
FROM uk_250k
WHERE rid BETWEEN 21 AND 30;

CREATE TABLE mosaic_part4 AS
SELECT ST_Union(rast) AS rast
FROM uk_250k
WHERE rid BETWEEN 31 AND 40;

CREATE TABLE mosaic_part5 AS
SELECT ST_Union(rast) AS rast
FROM uk_250k
WHERE rid BETWEEN 41 AND 50;

CREATE TABLE mosaic_part6 AS
SELECT ST_Union(rast) AS rast
FROM uk_250k
WHERE rid BETWEEN 51 AND 56;


-- mosaic_part1
ALTER TABLE public.mosaic_part1 ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_part1_rast_gist ON public.mosaic_part1 USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_part1'::name,'rast'::name);

-- mosaic_part2
ALTER TABLE public.mosaic_part2 ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_part2_rast_gist ON public.mosaic_part2 USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_part2'::name,'rast'::name);

-- mosaic_part3
ALTER TABLE public.mosaic_part3 ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_part3_rast_gist ON public.mosaic_part3 USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_part3'::name,'rast'::name);

-- mosaic_part4
ALTER TABLE public.mosaic_part4 ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_part4_rast_gist ON public.mosaic_part4 USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_part4'::name,'rast'::name);

-- mosaic_part5
ALTER TABLE public.mosaic_part5 ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_part5_rast_gist ON public.mosaic_part5 USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_part5'::name,'rast'::name);

-- mosaic_part6
ALTER TABLE public.mosaic_part6 ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_part6_rast_gist ON public.mosaic_part6 USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_part6'::name,'rast'::name);

CREATE TABLE mosaic_partA AS
SELECT ST_Union(rast) AS rast
FROM (
    SELECT rast FROM mosaic_part1
    UNION ALL
    SELECT rast FROM mosaic_part2
) AS mosaicA;

CREATE TABLE mosaic_partB AS
SELECT ST_Union(rast) AS rast
FROM (
    SELECT rast FROM mosaic_part3
    UNION ALL
    SELECT rast FROM mosaic_part4
) AS mosaicB;

CREATE TABLE mosaic_partC AS
SELECT ST_Union(rast) AS rast
FROM (
    SELECT rast FROM mosaic_part5
    UNION ALL
    SELECT rast FROM mosaic_part6
) AS mosaicC;

-- mosaic_partA
ALTER TABLE public.mosaic_partA ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_partA_rast_gist ON public.mosaic_partA USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_parta'::name,'rast'::name);

-- mosaic_partB
ALTER TABLE public.mosaic_partB ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_partB_rast_gist ON public.mosaic_partB USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_partb'::name,'rast'::name);

-- mosaic_partC
ALTER TABLE public.mosaic_partC ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_partC_rast_gist ON public.mosaic_partC USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_partc'::name,'rast'::name);

-- finalna mozaika - PostGIS nie jest w stanie scalić tak dużego rastra 
--w pamięci. Finalna mozaika scalona poprzez qgis.
	--CREATE TABLE uk_250k_mosaic AS
	--SELECT ST_Union(rast) AS rast
	--FROM (
  		--SELECT rast FROM mosaic_partA
    	--UNION ALL
    	--SELECT rast FROM mosaic_partB
    	--UNION ALL
    	--SELECT rast FROM mosaic_partC
	--) AS mosaic;

	--ALTER TABLE public.uk_250k_mosaic ADD COLUMN rid SERIAL PRIMARY KEY;
	--CREATE INDEX idx_uk_250k_mosaic_rast_gist ON public.uk_250k_mosaic USING gist (ST_ConvexHull(rast));
	--SELECT AddRasterConstraints('public'::name,'uk_250k_mosaic'::name,'rast'::name);

--eksport do GeoTIFF poprzez qgis


--5. Załaduj do bazy danych tabelę reprezentującą granice parków narodowych.
zaladowane poprzez qgis + db manager

--6. Utwórz nową tabelę o nazwie uk_lake_district, do której zaimportujesz mapy rastrowe
--z punktu 1., które zostaną przycięte do granic parku narodowego Lake District.
park narodowy Lake District - id = 1

-- Przycinanie każdej części do Lake District
CREATE TABLE mosaic_partA_clip AS
SELECT ST_Clip(rast, p.geom) AS rast
FROM mosaic_partA AS m
JOIN national_parks AS p
  ON p.id = 1;

CREATE TABLE mosaic_partB_clip AS
SELECT ST_Clip(rast, p.geom) AS rast
FROM mosaic_partB AS m
JOIN national_parks AS p
  ON p.id = 1;

CREATE TABLE mosaic_partC_clip AS
SELECT ST_Clip(rast, p.geom) AS rast
FROM mosaic_partC AS m
JOIN national_parks AS p
  ON p.id = 1;

CREATE TABLE uk_lake_district AS
SELECT ST_Union(rast) AS rast
FROM (
    SELECT rast FROM mosaic_partA_clip
    UNION ALL
    SELECT rast FROM mosaic_partB_clip
    UNION ALL
    SELECT rast FROM mosaic_partC_clip
) AS tmp;

-- mosaic_partA_clip
ALTER TABLE public.mosaic_partA_clip ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_partA_clip_rast_gist ON public.mosaic_partA_clip USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_parta_clip'::name,'rast'::name);

-- mosaic_partB_clip
ALTER TABLE public.mosaic_partB_clip ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_partB_clip_rast_gist ON public.mosaic_partB_clip USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_partb_clip'::name,'rast'::name);

-- mosaic_partC_clip
ALTER TABLE public.mosaic_partC_clip ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_mosaic_partC_clip_rast_gist ON public.mosaic_partC_clip USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'mosaic_partc_clip'::name,'rast'::name);

ALTER TABLE public.uk_lake_district ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_uk_lake_district_rast_gist ON public.uk_lake_district USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'uk_lake_district'::name,'rast'::name);


--7. Wyeksportuj wyniki do pliku GeoTIFF.

--eksport do GeoTIFF poprzez qgis


--9. Załaduj dane z Sentinela-2 do bazy danych.
--park narodowy Lake District leży w obrędbie dwóch zobrazowań

B03
--"C:\Program Files\PostgreSQL\18\bin\raster2pgsql.exe" -s 32630 -I -C -M "C:\Users\Aleksandra\Downloads\S2C_MSIL1C_20250712T112141_N0511_R037_T30UWF_20250712T133114.SAFE\GRANULE\L1C_T30UWF_A004440_20250712T112136\IMG_DATA\T30UWF_20250712T112141_B03.jp2" public.s2_b03.1 | "C:\Program Files\PostgreSQL\18\bin\psql.exe" -d cwiczenie8.2 -h localhost -U postgres -p 5432
B08
--"C:\Program Files\PostgreSQL\18\bin\raster2pgsql.exe" -s 32630 -I -C -M "C:\Users\Aleksandra\Downloads\S2C_MSIL1C_20250712T112141_N0511_R037_T30UWF_20250712T133114.SAFE\GRANULE\L1C_T30UWF_A004440_20250712T112136\IMG_DATA\T30UWF_20250712T112141_B08.jp2" public.s2_b08.1 | "C:\Program Files\PostgreSQL\18\bin\psql.exe" -d cwiczenie8.2 -h localhost -U postgres -p 5432

B03
--"C:\Program Files\PostgreSQL\18\bin\raster2pgsql.exe" -s 32630 -I -C -M "C:\Users\Aleksandra\Downloads\S2C_MSIL1C_20250712T112141_N0511_R037_T30UVF_20250712T133114.SAFE\GRANULE\L1C_T30UVF_A004440_20250712T112136\IMG_DATA\T30UVF_20250712T112141_B03.jp2" public.s2_b03.2 | "C:\Program Files\PostgreSQL\18\bin\psql.exe" -d cwiczenie8.2 -h localhost -U postgres -p 5432
B08
--"C:\Program Files\PostgreSQL\18\bin\raster2pgsql.exe" -s 32630 -I -C -M "C:\Users\Aleksandra\Downloads\S2C_MSIL1C_20250712T112141_N0511_R037_T30UVF_20250712T133114.SAFE\GRANULE\L1C_T30UVF_A004440_20250712T112136\IMG_DATA\T30UVF_20250712T112141_B08.jp2" public.s2_b08.2 | "C:\Program Files\PostgreSQL\18\bin\psql.exe" -d cwiczenie8.2 -h localhost -U postgres -p 5432


--scalenie 2 kanałów B03 i B08 w jeden
CREATE TABLE s2_b03_mosaic AS
SELECT ST_Union(rast) AS rast
FROM (
    SELECT rast FROM "s2_b03.1"
    UNION ALL
    SELECT rast FROM "s2_b03.2"
) AS b03;

CREATE TABLE s2_b08_mosaic AS
SELECT ST_Union(rast) AS rast
FROM (
    SELECT rast FROM "s2_b08.1"
    UNION ALL
    SELECT rast FROM "s2_b08.2"
) AS b08;

-- s2_b03_mosaic
ALTER TABLE public.s2_b03_mosaic ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_s2_b03_mosaic_rast_gist ON public.s2_b03_mosaic USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name, 's2_b03_mosaic'::name, 'rast'::name);


-- s2_b08_mosaic
ALTER TABLE public.s2_b08_mosaic ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_s2_b08_mosaic_rast_gist ON public.s2_b08_mosaic USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name, 's2_b08_mosaic'::name, 'rast'::name);


--10. Policz indeks NDWI oraz przytnij wyniki do granic Lake District.

--KOLEJNOŚĆ: NDWI, przycięcie do granic nie było w stanie się wykonać ze względu na problemy z pamięcią. 
--Dlatego została zastosowana odwrotna kolejność.

--przekształcenie warstw na układ 27700
CREATE TABLE s2_b03_mosaic_27700 AS
SELECT
    ST_Transform(rast, 27700) AS rast
FROM s2_b03_mosaic;

ALTER TABLE public.s2_b03_mosaic_27700 ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_s2_b03_mosaic_27700_rast_gist
    ON public.s2_b03_mosaic_27700 USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'s2_b03_mosaic_27700'::name,'rast'::name);

CREATE TABLE s2_b08_mosaic_27700 AS
SELECT
    ST_Transform(rast, 27700) AS rast
FROM s2_b08_mosaic;

ALTER TABLE public.s2_b08_mosaic_27700 ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_s2_b08_mosaic_27700_rast_gist
    ON public.s2_b08_mosaic_27700 USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'s2_b08_mosaic_27700'::name,'rast'::name);

--przycięcie pasm B03 i B08 do granic parku
CREATE TABLE s2_b03_clip AS
SELECT
    ST_Clip(m.rast, p.geom) AS rast
FROM s2_b03_mosaic_27700 m
JOIN national_parks p ON p.id = 1;

CREATE TABLE s2_b08_clip AS
SELECT ST_Clip(m.rast, p.geom) AS rast
FROM s2_b08_mosaic_27700 m
JOIN national_parks p ON p.id = 1;

ALTER TABLE public.s2_b03_clip ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_s2_b03_clip_rast_gist
    ON public.s2_b03_clip USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'s2_b03_clip'::name,'rast'::name);

ALTER TABLE public.s2_b08_clip ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_s2_b08_clip_rast_gist
    ON public.s2_b08_clip USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'s2_b08_clip'::name,'rast'::name);

--obliczenie NDWI dla obszaru przyciętego
CREATE TABLE ndwi AS
SELECT
    ST_MapAlgebra(
        b03.rast,
        b08.rast,
        '([rast1] - [rast2])::float / NULLIF(([rast1] + [rast2])::float, 0)',
        '32BF'
    ) AS rast
FROM s2_b03_clip b03
JOIN s2_b08_clip b08
    ON ST_Intersects(b03.rast, b08.rast);

ALTER TABLE public.ndwi ADD COLUMN rid SERIAL PRIMARY KEY;
CREATE INDEX idx_ndwi_rast_gist ON public.ndwi USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('public'::name,'ndwi'::name,'rast'::name);

--11. Wyeksportuj obliczony i przycięty wskaźnik NDWI do GeoTIFF

--eksport do GeoTIFF poprzez qgis