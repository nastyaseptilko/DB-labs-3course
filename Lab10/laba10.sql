--3.	Продемонстрируйте заимствование прав для любой процедуры в базе данных.
USE Shop1;

CREATE LOGIN Nastya WITH PASSWORD = 'password';
CREATE LOGIN Ilya WITH PASSWORD = 'password';
CREATE USER Nastya for LOGIN Nastya;
CREATE USER Ilya for LOGIN Ilya;

EXEC sp_addrolemember 'db_datareader', 'Nastya';
EXEC sp_addrolemember 'db_ddladmin', 'Nastya';
DENY SELECT on Shop1.dbo.Purchases TO Ilya;
GO

CREATE PROCEDURE us_proc_GetPurchases
WITH EXECUTE AS 'Nastya'
AS
SELECT * FROM Shop1.dbo.Purchases;

ALTER AUTHORIZATION ON us_proc_GetPurchases
TO Nastya;

GRANT EXECUTE ON us_proc_GetPurchases to Ilya;

SETUSER 'Nastya';
SETUSER 'Ilya';

SELECT * FROM Shop1.dbo.Purchases;

EXEC us_proc_GetPurchases;
GO
--(4-6).Создать для экземпляра SQL SERVER объект аудита.
--Задать для серверного аудита необходимые спецификации.
--Запустить серверный аудит, продемонстрировать журнал аудита.

USE MASTER;

CREATE SERVER AUDIT ShopAudit
TO FILE
(
 FILEPATH = 'D:\Учёба\3 curs\2 сем\DB\Lab10',
 MAXSIZE = 100 MB
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE);

ALTER SERVER AUDIT ShopAudit WITH ( state = on );

SELECT * FROM fn_get_audit_file(
	'D:\Учёба\3 curs\2 сем\DB\Lab10\ShopAudit_7C16281B-2440-4C6E-8326-85C1B1CF93A3_0_132348042443160000.sqlaudit',
	null,
	null
) ORDER BY event_time DESC, sequence_number;
GO

--(7-9) Создать необходимые объекты аудита.
-- Задать для аудита необходимые спецификации.
-- Запустить аудит БД, продемонстрировать журнал аудита

USE Shop1;
GO

CREATE DATABASE AUDIT SPECIFICATION Specification_ShopAudit
FOR SERVER AUDIT ShopAudit
ADD ( SELECT on object::[dbo].[Purchases] by [public]);

ALTER DATABASE AUDIT SPECIFICATION Specification_ShopAudit WITH (state = on);
GO

--10.	Остановить аудит БД и сервера
USE master;

ALTER SERVER AUDIT ShopAudit WITH ( state = off );
ALTER DATABASE AUDIT SPECIFICATION Specification_ShopAudit WITH (state = off);


--11.	Создать для экземпляра SQL SERVER ассиметричный ключ шифрования.
USE Shop1;
GO

CREATE ASYMMETRIC KEY Shop10akey   
    WITH ALGORITHM = RSA_2048   
    ENCRYPTION BY PASSWORD = 'Shop10';   
GO

--12.	Зашифровать и расшифровать данные при помощи этого ключа.

USE Shop1;

CREATE TABLE CreditCardInformation
(
	PersonID int PRIMARY KEY IDENTITY,
	CreditCardNumber varbinary(max)
);
GO

INSERT INTO CreditCardInformation(CreditCardNumber) VALUES (ENCRYPTBYASYMKEY( AsymKey_ID('Shop10akey') , N'1111-2222-3333-4444'))
GO

SELECT * FROM CreditCardInformation
GO

SELECT PersonID, CONVERT(nvarchar(max),  DecryptByAsymKey( AsymKey_Id('Shop10akey'), CreditCardNumber, N'Shop10')),
	DecryptByAsymKey( AsymKey_Id('Shop10akey'), CreditCardNumber, N'Shop10')
AS DecryptedData
FROM CreditCardInformation;
GO


--13.	Создать для экземпляра SQL SERVER сертификат.

CREATE CERTIFICATE SampleCert
ENCRYPTION BY PASSWORD = N'password'
WITH SUBJECT = N'Creation Target',
Expiry_DATE = N'28-10-2022';


--14.	Зашифровать и расшифровать данные при помощи этого сертификата.

INSERT INTO [dbo].[CreditCardInformation] values(EncryptByCert(Cert_ID('SampleCert'), N'Секретные данные'));
GO

SELECT * FROM [dbo].[CreditCardInformation]
GO

SELECT (Convert(Nvarchar(100), DecryptByCert(Cert_ID('SampleCert'), CreditCardInformation.CreditCardNumber, N'password'))) FROM [dbo].[CreditCardInformation];
GO

--15.	Создать для экземпляра SQL SERVER симметричный ключ шифрования данных.

--drop SYMMETRIC KEY SKey
CREATE SYMMETRIC KEY SKey WITH ALGORITHM = AES_256 ENCRYPTION BY PASSWORD = 'password';

OPEN SYMMETRIC KEY SKey DECRYPTION BY password = 'password';

CREATE SYMMETRIC KEY SData WITH ALGORITHM =  AES_256 ENCRYPTION BY SYMMETRIC KEY SKey;

OPEN SYMMETRIC KEY SData DECRYPTION BY SYMMETRIC KEY SKey;

CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'password';


-- 16.	Зашифровать и расшифровать данные при помощи этого ключа.

INSERT INTO [dbo].[CreditCardInformation] VALUES (ENCRYPTBYKEY( Key_GUID('SData') , N'Secret Data'))
GO

SELECT * FROM [dbo].[CreditCardInformation]
GO

--Расшифрование с помощью симетричного ключа.
SELECT [PersonID], CONVERT(nvarchar(max),  DecryptByKey( [CreditCardNumber])) AS DecryptedData  FROM [dbo].[CreditCardInformation]
GO 

--17.	Продемонстрировать прозрачное шифрование базы данных.

USE master;  
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'password';  
go

CREATE CERTIFICATE MySERVERCert WITH SUBJECT = 'My DEK Certificate';  
go
  
USE Shop1;
GO  

CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_128 ENCRYPTION BY SERVER CERTIFICATE MySERVERCert;  
GO  

ALTER DATABASE Shop1 SET ENCRYPTION ON;  
GO  

--18.	Продемонстрировать применение хэширования.

SELECT HASHBYTES('SHA1', 'Hash example');

--19.	Продемонстрировать применение Электронной подписи(ЭЦП) при помощи сертификата.

SELECT SignByCert(Cert_Id( 'SampleCert' ),'Secrect Info', N'password');


--20.	Сделать резервную копию необходимых ключей и сертификатов.
BACKUP CERTIFICATE SampleCert TO FILE = N'D:\Учёба\3 curs\2 сем\DB\Lab10\BackupSampleCert.cer'
WITH PRIVATE KEY (
	FILE = N'D:\Учёба\3 curs\2 сем\DB\Lab10\BackupSampleCert.pvk',
	ENCRYPTION BY PASSWORD = N'password',
	DECRYPTION BY PASSWORD = N'password'
);





