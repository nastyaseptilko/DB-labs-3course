--2.	Создать необходимые учетные записи, роли и пользователей. 
USE WHiring
GO
CREATE LOGIN Lab10   
    WITH PASSWORD = 'Lab10';
GO

USE master
GO
GRANT ALTER ANY DATABASE TO Lab10;
GO

--3.	Создать для экземпляра SQL Server объект аудита.
--4.	Задать для серверного аудита необходимые спецификации. 
USE master;
GO
CREATE SERVER AUDIT Lab10_Audit  
    TO APPLICATION_LOG;
GO  
 
--5.	Запустить серверный аудит, продемонстрировать журнал аудита.
ALTER SERVER AUDIT Lab10_Audit  
WITH (STATE = ON);  
GO 

--6.	Создать необходимые объекты аудита.
--7.	Задать для аудита необходимые спецификации.
--8.	Запустить аудит БД, продемонстрировать журнал аудита
USE WHiring  
GO    
CREATE DATABASE AUDIT SPECIFICATION Audit_VAC_Lab10
FOR SERVER AUDIT Lab10_Audit 
ADD (SELECT, INSERT ON VACANCY BY dbo )   --audit_action_specification
WITH (STATE = ON) ;   
GO

--9.	Остановить аудит БД и сервера.
USE master  
GO    
ALTER SERVER AUDIT Lab10_Audit  
WITH (STATE = OFF);  
GO 
USE master
GO
ALTER DATABASE AUDIT SPECIFICATION Audit_VAC_Lab10
WITH (STATE = OFF);  
GO 

--10.	Создать для экземпляра SQL Server ассиметричный ключ шифрования.
USE master
GO
CREATE ASYMMETRIC KEY Lab10akey   
    WITH ALGORITHM = RSA_2048   
    ENCRYPTION BY PASSWORD = 'Lab10';   
GO  

USE EncryptedDB
GO
CREATE ASYMMETRIC KEY Lab10akey   
    WITH ALGORITHM = RSA_2048   
    ENCRYPTION BY PASSWORD = 'Lab10';   
GO  


--11.	Зашифровать и расшифровать данные при помощи этого ключа.
CREATE DATABASE EncryptedDB;
GO
USE EncryptedDB
GO
CREATE TABLE CreditCardInformation
(
	PersonID int PRIMARY KEY IDENTITY,
	CreditCardNumber varbinary(max)
)
GO
--Шифрование с помощью асииметричного ключа.
INSERT INTO CreditCardInformation(CreditCardNumber)
VALUES (ENCRYPTBYASYMKEY( AsymKey_ID('Lab10akey') , N'fdsghfdswerg'))
GO
SELECT * FROM CreditCardInformation
GO
--Расшифрование с помощью асииметричного ключа.
SELECT PersonID, CONVERT(nvarchar(max),  DecryptByAsymKey( AsymKey_Id('Lab10akey'), CreditCardNumber, N'Lab10'))   
,DecryptByAsymKey( AsymKey_Id('Lab10akey'), CreditCardNumber, N'Lab10')
AS DecryptedData   
FROM CreditCardInformation
GO  

--12.	Создать для экземпляра SQL Server сертификат.
use EncryptedDB
go
create certificate SampleCert
encryption by password = N'Lab10'
with subject = N'Цель создания',
Expiry_DATE = N'28/10/2022';

--13.	Зашифровать и расшифровать данные при помощи этого сертификата.
INSERT INTO CreditCardInformation values(EncryptByCert(Cert_ID('SampleCert'), N'Секретные данные'));
GO
SELECT * FROM CreditCardInformation
GO
SELECT (Convert(Nvarchar(100), DecryptByCert(Cert_ID('SampleCert'), CreditCardInformation.CreditCardNumber, N'Lab10'))) FROM CreditCardInformation;
GO

--14.	Создать для экземпляра SQL Server симметричный ключ шифрования данных.
--для шифрования симм ключа
create Symmetric key SKey
WITH ALGORITHM = AES_256  ENCRYPTION
 by password = 'Lab10';

Open symmetric key SKey
Decryption by password = 'Lab10'
create Symmetric key SData
with Algorithm =  AES_256
encryption by symmetric key SKey;

Open symmetric key SData 
Decryption by symmetric key SKey;

create Master key encryption by password = N'Lab10';
--15.	Зашифровать и расшифровать данные при помощи этого ключа.
--Шифрование с помощью симетричного ключа.
INSERT INTO CreditCardInformation VALUES (ENCRYPTBYKEY( Key_GUID('SData') , N'Secret Data'))
GO
SELECT * FROM CreditCardInformation
GO
--Расшифрование с помощью симетричного ключа.
SELECT [PersonID], CONVERT(nvarchar(max),  DecryptByKey( [CreditCardNumber])) AS DecryptedData  FROM [dbo].[CreditCardInformation]
GO 

--16.	Продемонстрировать прозрачное шифрование базы данных.
USE master;  
GO  
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Lab10';  
go
CREATE CERTIFICATE MyServerCert WITH SUBJECT = 'My DEK Certificate';  
go  


USE s
GO  
CREATE DATABASE ENCRYPTION KEY  
WITH ALGORITHM = AES_128  
ENCRYPTION BY SERVER CERTIFICATE MyServerCert;  
GO  
ALTER DATABASE s  
SET ENCRYPTION ON;  
GO  

--17.	Продемонстрировать применение хэширования.
select HASHBYTES('SHA1', 'Hesh example');

--18.	Продемонстрировать применение ЭЦП при помощи сертификата.
use EncryptedDB
GO
select SignByCert(Cert_Id( 'SampleCert' ),'dadaya', N'Lab10')

--19.	Сделать резервную копию необходимых ключей и сертификатов.
Backup certificate SampleCert
to File = N'D:\Subject\BD3\Lab\Lab10\Cert.cer'
with private key (
File = N'D:\Subject\BD3\Lab\Lab10\Cert.pvk',
Encryption by password = N'Lab10',
Decryption by password = N'Lab10');