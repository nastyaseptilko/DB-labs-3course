create directory bfile_dir as 'C:\Users\Administrator\Desktop\files' 

create table word_table(
  fname varchar2(255),
  ffile bfile 
);
insert into word_table 
  values ( 'doc', BFILENAME( 'bfile_dir', 'd.doc' ) );
select * from word_table

------------------------------------------------------------

CREATE TABLE files_table 
(
  fname varchar2(255) NOT NULL,
  ffile blob NOT NULL
)

INSERT INTO files_table  
  VALUES ('file1', utl_raw.cast_to_raw('C:\Users\Administrator\Desktop\files\p.png'));
select * from files_table
------