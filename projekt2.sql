--Utworzenie bazy danych "ćwiczenie2"

--Dadanie funkcjonalności PostGis do bazy:
CREATE EXTENSION postgis;

--Utworzenie tabel:
create table buildings (
id int primary key,
geom geometry(polygon),
name varchar(50)
);

create table roads (
id int primary key,
geom geometry(linestring),
name varchar(50)
);

create table poi (
id int primary key,
geom geometry(point),
name varchar(50)
);

--Wstawienie danych do tabel:
insert into buildings values
(1, ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))'), 'BuildingA'),
(2, ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))'), 'BuildingB'),
(3, ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))'), 'BuildingC'),
(4, ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))'), 'BuildingD'),
(5, ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))'), 'BuildingF');

insert into roads values
(1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)'), 'RoadX'),
(2, ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)'), 'RoadY');

insert into poi values
(1, ST_GeomFromText('POINT(1 3.5)'), 'G'),
(2, ST_GeomFromText('POINT(5.5 1.5)'), 'H'),
(3, ST_GeomFromText('POINT(9.5 6)'), 'I'),
(4, ST_GeomFromText('POINT(6.5 6)'), 'J'),
(5, ST_GeomFromText('POINT(6 9.5)'), 'K');

--Polecenia na bazie danych:
--Wyznacz całkowitą długość dróg w analizowanym mieście. 
select sum(ST_Length(geom)) as "całkowita długość dróg" from roads;
--Wypisz geometrię (WKT), pole powierzchni oraz obwód poligonu reprezentującego budynek o nazwie BuildingA.  
select ST_AsText(geom) as "wkt", ST_Area(geom) as "pole powierzchni", ST_Perimeter(geom) as "obwód" from buildings where name = 'BuildingA';
--Wypisz nazwy i pola powierzchni wszystkich poligonów w warstwie budynki. Wyniki posortuj alfabetycznie.   
select name, ST_Area(geom) as "pole powierzchni" from buildings order by name;
--Wypisz nazwy i obwody 2 budynków o największej powierzchni.   
select name, ST_Area(geom) as "pole powierzchni", ST_Perimeter(geom) as "obwód" from buildings order by ST_Area(geom) desc limit 2;
--Wyznacz najkrótszą odległość między budynkiem BuildingC a punktem K.   
select ST_Distance(b.geom, p.geom) from buildings b join poi p on p.name = 'K' where b.name = 'BuildingC';
--Wypisz pole powierzchni tej części budynku BuildingC, która znajduje się w odległości większej niż 0.5 od budynku BuildingB.  
select ST_Area(ST_Difference(bc.geom, ST_Buffer(bb.geom, 0.5))) as "pole w odległości >0.5" from buildings bc join buildings bb on bb.name = 'BuildingB' where bc.name = 'BuildingC';
--Wybierz te budynki, których centroid (ST_Centroid) znajduje się powyżej drogi o nazwie RoadX. 
select b.name from buildings b cross join roads r where r.name = 'RoadX' and ST_Y(ST_Centroid(b.geom)) > ST_Y(ST_ClosestPoint(r.geom, ST_Centroid(b.geom)));
--Oblicz pole powierzchni tych części budynku BuildingC i poligonu o współrzędnych (4 7, 6 7, 6 8, 4 8, 4 7), które nie są wspólne dla tych dwóch obiektów. 
select ST_Area(ST_SymDifference(b.geom, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) as "części nie wspólne" from buildings b where b.name = 'BuildingC';