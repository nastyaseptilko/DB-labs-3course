use Shop1;

CREATE TABLE [dbo].[shop](
	[ogr_fid] [int] IDENTITY(1,1) NOT NULL,
	[ogr_geometry] [geography] NULL,
	[shop] [numeric](13, 11) NULL,
 CONSTRAINT [PK_august] PRIMARY KEY CLUSTERED 
(
	[ogr_fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
DECLARE @g geography;  --������ � ������� ��������� ��� ����������� �����
DECLARE @h geography;
 
SELECT @g = ogr_geometry from shop where ogr_fid = 1;  --� ���������� ������������ (������� ������� ���������)
SELECT @h = ogr_geometry from shop where ogr_fid = 2;  

SELECT @g.STIntersection(@h).ToString();--3 �������

--4
SET @g = geography::STGeomFromText('POINT(-122.360 47.656)', 4326);  
SET @h = geography::STGeomFromText('POINT(-122.34900 47.65100)', 4326);  
SELECT @g.STDistance(@h);

--��������� �������
--���������� �������������� ������, �������������� ������������ ���� �����, ���������� ������� �� ���������� geography ������ ��� ����� ���������� ��������.
DECLARE @g geography;  
SET @g = geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656)', 4326);  
SELECT @g.STBuffer(1).ToString();




INSERT INTO shop values (geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656 )', 4326), 17.7); --������������������ ����� � �������� , ����������� ��.
select * from shop;

CREATE SPATIAL INDEX shop_geography ON shop(ogr_geometry);


--test
DECLARE @GeometryToConvert GEOMETRY
SET     @GeometryToConvert = 
    GEOMETRY::STGeomFromText('LINESTRING (-71.880713132200128 43.149953199689264, -71.88050339886712 43.149719933022993, -71.880331598867372 43.149278533023676, -71.88013753220099 43.147887799692512, -71.879965998867931 43.147531933026357, -71.879658998868422 43.147003933027179, -71.879539598868575 43.146660333027739, -71.879525332201979 43.145994399695439, -71.87959319886852 43.145452399696296, -71.879660598868384 43.14531113302985, -71.879915932201357 43.145025599696908, -71.879923198868028 43.1449217996971, -71.879885998868076 43.144850733030523, -71.879683932201715 43.144662333030851, -71.879601398868488 43.144565333030982, -71.879316798868956 43.144338333031328, -71.879092332202617 43.144019799698469, -71.8789277322029 43.143902533032019, -71.878747932203169 43.143911533031996, -71.878478132203554 43.14405779969843, -71.878328332203807 43.144066133031743, -71.878148732204068 43.144016599698489, -71.8772655988721 43.143174533033118, -71.876876198872708 43.142725133033821, -71.876801532206173 43.142654933033953, -71.876629398873092 43.142600733034044)', 4269)
;
WITH GeometryPoints(N, Point) AS  
( 
   SELECT 1,  @GeometryToConvert.STPointN(1)
   UNION ALL
   SELECT N + 1, @GeometryToConvert.STPointN(N + 1)
   FROM GeometryPoints GP
   WHERE N < @GeometryToConvert.STNumPoints()  
)

SELECT *, Point.STAsText() FROM GeometryPoints  