--use this https://docs.oracle.com/cd/E25259_01/appdev.31/e24285/migration.htm#RPTUG41484
--1. https://sourceforge.net/projects/jtds/?source=typ_redirect

--2.
alter session set "_ORACLE_SCRIPT"=true;
create user Migrant identified by Migrant default tablespace Users temporary tablespace temp;


grant all privileges to Migrant WITH ADMIN OPTION;
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE PUBLIC SYNONYM TO 
  Migrant WITH ADMIN OPTION;
  
  
create user WHiring identified by WHiring default tablespace Users temporary tablespace temp;
grant all privileges to WHiring WITH ADMIN OPTION;


--3. connect to that user

--4. Start migration