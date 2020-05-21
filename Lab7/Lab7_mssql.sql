go
use master
create database Lab7
use Lab7

----------------------------------------------------------------------------------------------
create table VACANCY
(
	Id int identity(1,1) constraint VACANCY_ID_PK PRIMARY KEY,
	Company nvarchar(50),
	Position nvarchar(50),
	Level nvarchar(15),
    	Exp int check(Exp >= 0 and Exp <= 116),
	MinSalary int,
	MaxSalary int,
	Status nchar(8) check(Status = 'Enable' or Status = 'Disable')
)
  INSERT INTO VACANCY(Company, Position, Level, MinSalary, MaxSalary,Status) VALUES
('BSTU', 'Student', '3', 0, 20,'Enable')

create table WORKER
(
	Id int identity(1,1) constraint WORKER_ID_PK PRIMARY KEY,
	FName nvarchar(50),
	SName nvarchar(50),
	Position nvarchar(50),
	Level nvarchar(15),
	Sex nchar(1) check(Sex = 'M' or Sex = 'F'), 
    Age int check(Age >= 14 and Age <= 120),
    Exp int check(Exp >= 0 and Exp <= 116),
	Salary int,
    Job int constraint JOB_ID_FK foreign key references VACANCY(Id)
)
  INSERT INTO WORKER(FName, SName, Position, Level, Sex,Age) VALUES
('Septilko', 'Nastya', 'Student', 3, 'F',20)

create table CANDIDATE
(
	Id int identity(1,1) constraint CANDIDATE_ID_PK PRIMARY KEY,
	FName nvarchar(50),
	SName nvarchar(50),
	Position nvarchar(50),
	Level nvarchar(15),
	Sex nchar(1) check(Sex = 'M' or Sex = 'F'), 
    Age int check(Age >= 14 and Age <= 120),
    Exp int check(Exp >= 0 and Exp <= 116),
	Salary int,
	Job int constraint VACANCY_ID_FK foreign key references VACANCY(Id)
)
  INSERT INTO CANDIDATE(FName, SName, Position, Level, Sex,Age) VALUES
('Ivanov', 'Ilya', 'Student', 3, 'M',19)
-----------------------------------------------------------------------------------------------

--TASK1
create table Report (
id INTEGER primary key identity(1,1),
xml_column XML
);

INSERT INTO Report (xml_column)
       VALUES('<catalog>
                        <name>Иван</name>
                        <lastname>Иванов</lastname>
                </catalog>')



--TASK2	
go
create procedure generateXML
as
declare @x XML
set @x = (Select vac.Id [Id], Company [Company], can.Position [Position],
				FName[FName], SName[LName], Age, Sex, Salary,GETDATE() [Date] 
from VACANCY vac join CANDIDATE can on vac.Id = can.Job
FOR XML AUTO);
SELECT @x
go

execute generateXML;



--TASK3
go
create procedure InsertReport
as
begin
  INSERT INTO Report (xml_column)
       VALUES('<catalog>
                        <name>Dasha</name>
                        <lastname>Li</lastname>
                </catalog>')
end
execute InsertReport
select * from Report;




--task4
create primary xml index My_XML_Index on Report(xml_column)

create xml index Second_XML_Index on Report(xml_column)
using xml index My_XML_Index for path



--task5
go
create procedure SelectData
as
select xml_column.query('/row') as[xml_column] from Report for xml auto, type;
go
execute SelectData
 
---------------
go
create procedure SelectNameData
as
SELECT xml_column.query('/catalog/name') FROM Report
go
execute SelectNameData

--query – делает выборку в самом xml документе,
-- который хранится в нашей таблице, и принимает он один параметр — это строка запроса к xml документу, т.е. что именно Вы хотите получить из xml.

--value
  DECLARE @xml xml;
   SET @xml=(SELECT ID, xml_column
             FROM Report
             WHERE id=2
             FOR XML RAW, TYPE);
   SELECT @xml;
   SELECT @xml.value('/row[1]/@ID[1]','int') as id,
          @xml.value('/row[1]/@test[1]','char(50)') AS text

--------------------------------------------
select xml_column.value('(/row/@Date)[1]', 'nvarchar(max)') as[xml_column] from Report for xml auto, type;

select r.Id, m.c.value('@Date', 'nvarchar(max)') as [date] from Report as r outer apply r.xml_column.nodes('/row') as m(c)

select xml_column.query('/row') as [xml_column] from Report for xml auto, type;

