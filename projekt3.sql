CREATE EXTENSION postgis;

--1. Zaimportuj następujące pliki shapefile do bazy:- T2018_KAR_BUILDINGS- T2019_KAR_BUILDINGS
  --Pliki te przedstawiają zabudowę miasta Karlsruhe w latach 2018 i 2019.
  --Znajdź budynki, które zostały wybudowane lub wyremontowane na przestrzeni roku (zmiana
  --pomiędzy 2018 a 2019).

select b2019.* from "T2019_KAR_BUILDINGS" b2019 left join "T2018_KAR_BUILDINGS" b2018 on 
b2019.polygon_id = b2018.polygon_id where b2018.polygon_id is null or b2018.height <> b2019.height 
or not ST_Equals(b2019.geom, b2018.geom);

--2. Zaimportuj dane dotyczące POIs (Points of Interest) z obu lat:
  --T2018_KAR_POI_TABLE
  --T2019_KAR_POI_TABLE
  --Znajdź ile nowych POI pojawiło się w promieniu 500 m od wyremontowanych lub
  --wybudowanych budynków, które znalezione zostały w zadaniu 1. Policz je wg ich kategorii.

select p2019.type, count(*) AS "nowe POI" from "T2019_KAR_POI_TABLE" p2019 left join "T2018_KAR_POI_TABLE" p2018 
on p2019.poi_id = p2018.poi_id where p2018.poi_id is null
and exists (select 1 from "T2019_KAR_BUILDINGS" b2019 left join "T2018_KAR_BUILDINGS" b2018
on b2019.polygon_id = b2018.polygon_id where b2018.polygon_id is null or b2018.height <> b2019.height
or not ST_Equals(b2019.geom, b2018.geom) and ST_DWithin(p2019.geom, b2019.geom, 500))
group by p2019.type;

--3. Utwórz nową tabelę o nazwie ‘streets_reprojected’, która zawierać będzie dane z tabeli
  --T2019_KAR_STREETS przetransformowane do układu współrzędnych DHDN.Berlin/Cassini

create table streets_reprojected as select *, ST_Transform(geom, 3068) as "geom 3068" from "T2019_KAR_STREETS";
select * from streets_reprojected;

--4. Stwórz tabelę o nazwie ‘input_points’ i dodaj do niej dwa rekordy o geometrii punktowej.
  --Użyj następujących współrzędnych:
  --X           Y
  --8.36093		49.03174
  --8.39876		49.00644

create table input_points (
id serial primary key,
geom geometry(Point, 4326)
);

insert into input_points (geom) values
(ST_SetSRID(ST_Point(8.36093, 49.03174), 4326)),
(ST_SetSRID(ST_Point(8.39876, 49.00644), 4326));

select * from input_points;

--5. Zaktualizuj dane w tabeli ‘input_points’ tak, aby punkty te były w układzie współrzędnych
  --DHDN.Berlin/Cassini.

alter table input_points alter column geom type geometry(Point, 3068) using ST_Transform(geom, 3068);

select * from input_points;

--6. Znajdź wszystkie skrzyżowania, które znajdują się w odległości 200 m od linii zbudowanej
  --z punktów w tabeli ‘input_points’. Wykorzystaj tabelę T2019_STREET_NODE. Dokonaj
  --reprojekcji geometrii, aby była zgodna z resztą tabel.

--utworzenie linii zbudowanej z punktów w tabeli 'input_points'
with line as (select ST_MakeLine(geom order by id) as geom from input_points)

select n.* from "T2019_KAR_STREET_NODE" n, line where ST_DWithin(ST_Transform(n.geom, 3068), line.geom, 200);

--7. Policz jak wiele sklepów sportowych (‘Sporting Goods Store’ - tabela POIs) znajduje się
  --w odległości 300 m od parków (LAND_USE_A).

select count(distinct p.id) as "sklepy sportowe w pobliżu parków" from "T2019_KAR_POI_TABLE" p join "T2019_KAR_LAND_USE_A" l
on ST_DWithin(p.geom, l.geom, 300) where p.type = 'Sporting Goods Store';

--8. Znajdź punkty przecięcia torów kolejowych (RAILWAYS) z ciekami (WATER_LINES). Zapisz
  --znalezioną geometrię do osobnej tabeli o nazwie ‘T2019_KAR_BRIDGES’

create table "T2019_KAR_BRIDGES" as select ST_Intersection(r.geom, w.geom) as geom from "T2019_KAR_RAILWAYS" r join "T2019_KAR_WATER_LINES" w 
on ST_Intersects(r.geom, w.geom) where GeometryType(ST_Intersection(r.geom, w.geom)) like '%POINT%';

select * from "T2019_KAR_BRIDGES";