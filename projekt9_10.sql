CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;

SELECT * FROM "Exports"

CREATE TABLE merged_raster AS
SELECT ST_SetSRID(ST_Union(geom::geometry), 4326) AS geom
FROM "Exports";

SELECT * from merged_raster