go
use Shop1;

CREATE TABLE Staff(
  hid hierarchyid NOT NULL,
  userId int NOT NULL,
  userName nvarchar(50) NOT NULL,
CONSTRAINT PK_Staff PRIMARY KEY CLUSTERED 
(
  [hid] ASC
));

--GetRoot() � ���������� id ����� ��������.

insert into Staff values(hierarchyid::GetRoot(), 1, '������'); 
select * from Staff;

--hid.GetAncestor(1) = hierarchyid::GetRoot() � �������� ��� ������, ������� ������� �������� ������;
--hierarchyid::GetRoot().GetDescendant(@id, null) � �������� ������ ��������� hierarchyid �������� ����� ������
go
declare @Id hierarchyid  
select @Id = MAX(hid) from Staff where hid.GetAncestor(1) = hierarchyid::GetRoot() ; 
insert into Staff values(hierarchyid::GetRoot().GetDescendant(@id, null), 2, '������');

go
declare @Id hierarchyid
select @Id = MAX(hid) from Staff where hid.GetAncestor(1) = hierarchyid::GetRoot() ;
insert into Staff values(hierarchyid::GetRoot().GetDescendant(@id, null), 3, '�������');
 
go
declare @phId hierarchyid
select @phId = (SELECT hid FROM Staff WHERE userId = 2);
declare @Id hierarchyid
select @Id = MAX(hid) from Staff where hid.GetAncestor(1) = @phId;
insert into Staff values( @phId.GetDescendant(@id, null), 7, '�����');

go
declare @phId hierarchyid
select @phId = (SELECT hid FROM Staff WHERE userId = 6);
declare @Id hierarchyid
select @Id = MAX(hid) from Staff where hid.GetAncestor(1) = @phId;
insert into Staff values( @phId.GetDescendant(@id, null), 5, '�������');

go
declare @Id hierarchyid
select @Id = MAX(hid) from Staff where hid.GetAncestor(1) = hierarchyid::GetRoot() ;
insert into Staff values(hierarchyid::GetRoot().GetDescendant(@id, null), 6, '���������');


select hid.ToString(), hid.GetLevel(), * from Staff; 

--2-------------GetLevel � ������ ������� hierarchyid;-----------------------------
GO  
CREATE PROCEDURE SelectRoot(@level int)    
AS   
BEGIN  
   select hid.ToString(), * from Staff where hid.GetLevel() = @level;
END;

GO  
exec SelectRoot 1;

--3--------������� ����������� ���� -------------------------------------
GO  
CREATE PROCEDURE AddDocherRoot(@UserId int,@UserName nvarchar(50))   
AS   
BEGIN  
declare @Id hierarchyid
declare @phId hierarchyid
select @phId = (SELECT hid FROM Staff WHERE UserId = @UserId);

select @Id = MAX(hid) from Staff where hid.GetAncestor(1) = @phId

insert into Staff values( @phId.GetDescendant(@id, null),@UserId,@UserName);
END;  


GO  
exec AddDocherRoot 6, '��������';
select * from Staff;

--4----���������� ��� ����������� ����� ------------
--������� ���������, ������� ���������� ��� ����������� ����� 
--(������ �������� � �������� �������� ������������� ����, ������ �������� � �������� ����, � ������� ���������� �����������).
go
CREATE PROCEDURE MovRoot(@old_uzel int, @new_uzel int )
AS  
BEGIN  
DECLARE @nold hierarchyid, @nnew hierarchyid  
SELECT @nold = hid FROM Staff WHERE UserId = @old_uzel ;  
  
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
BEGIN TRANSACTION  
SELECT @nnew = hid FROM Staff WHERE UserId = @new_uzel; 
SELECT @nnew = @nnew.GetDescendant(max(hid), NULL) FROM Staff WHERE hid.GetAncestor(1)=@nnew ; 
UPDATE Staff   
SET hid = hid.GetReparentedValue(@nold, @nnew)   --���� � �������� �� ��������� �������� ������� �� ���� � newRoot � ���� �� oldRoot.
WHERE hid.IsDescendantOf(@nold) = 1 ;   --���������� true, ���� ��� ������� ��������.
 commit;
  END ;  
GO  
----
--exec MovRoot 2,3
exec MovRoot 1,2
select hid.ToString(), hid.GetLevel(), * from Staff