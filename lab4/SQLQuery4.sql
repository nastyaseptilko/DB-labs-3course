DECLARE @g geography;  
DECLARE @h geography;
 
SELECT @g = ogr_geometry from august where ogr_fid = 1;  
SELECT @h = ogr_geometry from august where ogr_fid = 2;  

SELECT @g.STIntersection(@h).ToString();

--SET @g = geography::STGeomFromText('POINT(-122.360 47.656)', 4326);  
--SET @h = geography::STGeomFromText('POINT(-122.34900 47.65100)', 4326);  
SELECT @g.STDistance(@h);

INSERT INTO august values (geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656 )', 4326), 17.7);
select * from august;

CREATE SPATIAL INDEX august_geography ON august(ogr_geometry);  