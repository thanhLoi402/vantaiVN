create database vantaitocdo;

drop table ADMIN;
  CREATE TABLE ADMIN(
	ID int NOT NULL AUTO_INCREMENT, 
	USER_NAME varchar(200) not null, 
	FULL_NAME varchar(200) not null, 
	PASSWD varchar(128) NOT NULL, 
	STATUS int DEFAULT 0 NOT NULL, 
	RIGHT_ROLE int DEFAULT 0 NOT NULL, 
	GEN_DATE  datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,  
	MOBILE varchar(20), 
	EMAIL varchar(50), 
	IP varchar(100),
    PRIMARY KEY (ID)
);
	
    
drop table ADMIN_LINK;
  CREATE TABLE ADMIN_LINK(
	ID int NOT NULL AUTO_INCREMENT, 
	URI varchar(500) NOT NULL, 
	NAME varchar(200), 
	PARENT_ID int DEFAULT 0 NOT NULL, 
	STATUS int DEFAULT 0 NOT NULL, 
	POSITION int DEFAULT 0 NOT NULL, 
	GEN_DATE datetime DEFAULT current_timestamp NOT NULL, 
	DISPLAY_TOP int NOT NULL, 
	IS_SELECT int, 
	IS_INSERT int, 
	IS_UPDATE int, 
	IS_DELETE int, 
	LINK_LEVEL int,
    PRIMARY KEY (ID)
);




  CREATE TABLE ADMIN_ROLE(
	ID int NOT NULL AUTO_INCREMENT, 
	ADMIN varchar(200) NOT NULL, 
	LINK_ID int NOT NULL, 
	IS_SELECT int, 
	IS_INSERT int, 
	IS_UPDATE int, 
	IS_DELETE int, 
	GEN_DATE datetime DEFAULT current_timestamp NOT NULL, 
	CREATED_BY varchar(200) NOT NULL, 
	LAST_UPDATED datetime,
    PRIMARY KEY (ID)
);


  CREATE TABLE ADMIN_LOG(
	ID int NOT NULL AUTO_INCREMENT, 
	ADMIN varchar(200), 
	DESCRIPTION varchar(500), 
	GEN_DATE datetime DEFAULT current_timestamp NOT NULL, 
	TYPE int,
    PRIMARY KEY (ID)
);



  CREATE TABLE ADMIN_ACCESS_LOG(
	ID int NOT NULL AUTO_INCREMENT, 
	USRNAME varchar(200), 
	IP varchar(100), 
	BROWSER varchar(500), 
	LOGIN_TIME datetime, 
	LOGOUT_TIME datetime, 
	GEN_DATE datetime DEFAULT current_timestamp NOT NULL, 
    PRIMARY KEY (ID)
);


Insert into ADMIN (USER_NAME,FULL_NAME,PASSWD,STATUS,RIGHT_ROLE,GEN_DATE,MOBILE,EMAIL,IP) values ('admin','Administrator','b91a2284fc082c83c668acac761553be',0,1,current_timestamp,'0977932946','loint90it@gmail.com',null);

Insert into ADMIN_LINK (ID,URI,NAME,PARENT_ID,STATUS,POSITION,GEN_DATE,DISPLAY_TOP,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,LINK_LEVEL) values (100,'#','Qu?n lý h? th?ng',0,0,1,current_timestamp,1,0,1,1,1,1);
Insert into ADMIN_LINK (ID,URI,NAME,PARENT_ID,STATUS,POSITION,GEN_DATE,DISPLAY_TOP,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,LINK_LEVEL) values (118,'/admin/admin/link/add.jsp','Add/Edit Site Map',116,0,1,current_timestamp,1,0,0,0,1,3);
Insert into ADMIN_LINK (ID,URI,NAME,PARENT_ID,STATUS,POSITION,GEN_DATE,DISPLAY_TOP,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,LINK_LEVEL) values (122,'/admin/admin/link/role.jsp','Admin Roles',100,0,3,current_timestamp,1,0,0,0,1,2);
Insert into ADMIN_LINK (ID,URI,NAME,PARENT_ID,STATUS,POSITION,GEN_DATE,DISPLAY_TOP,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,LINK_LEVEL) values (114,'/admin/admin/add.jsp','Add-Edit Account',112,0,1,current_timestamp,1,0,0,0,1,3);
Insert into ADMIN_LINK (ID,URI,NAME,PARENT_ID,STATUS,POSITION,GEN_DATE,DISPLAY_TOP,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,LINK_LEVEL) values (116,'/admin/admin/link/index.jsp','S? ?? site',100,0,1,current_timestamp,1,0,1,1,0,2);
Insert into ADMIN_LINK (ID,URI,NAME,PARENT_ID,STATUS,POSITION,GEN_DATE,DISPLAY_TOP,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,LINK_LEVEL) values (112,'/admin/admin/index.jsp','Admin Acc',100,0,2,current_timestamp,0,0,1,1,0,2);
Insert into ADMIN_LINK (ID,URI,NAME,PARENT_ID,STATUS,POSITION,GEN_DATE,DISPLAY_TOP,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,LINK_LEVEL) values (120,'/admin/admin/admin-log.jsp','Log qu?n lý',100,0,5,current_timestamp,1,0,1,1,1,2);
Insert into ADMIN_LINK (ID,URI,NAME,PARENT_ID,STATUS,POSITION,GEN_DATE,DISPLAY_TOP,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,LINK_LEVEL) values (124,'/admin/admin/access-log.jsp','Log truy c?p',100,0,3,current_timestamp,0,0,1,1,1,2);


Insert into ADMIN_ROLE (ADMIN,LINK_ID,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,GEN_DATE,CREATED_BY,LAST_UPDATED) values ('admin',112,0,1,1,0,current_timestamp,'admin',null);
Insert into ADMIN_ROLE (ADMIN,LINK_ID,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,GEN_DATE,CREATED_BY,LAST_UPDATED) values ('admin',114,0,0,0,1,current_timestamp,'admin',null);
Insert into ADMIN_ROLE (ADMIN,LINK_ID,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,GEN_DATE,CREATED_BY,LAST_UPDATED) values ('admin',116,0,1,1,0,current_timestamp,'admin',null);
Insert into ADMIN_ROLE (ADMIN,LINK_ID,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,GEN_DATE,CREATED_BY,LAST_UPDATED) values ('admin',118,0,0,0,1,current_timestamp,'admin',null);
Insert into ADMIN_ROLE (ADMIN,LINK_ID,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,GEN_DATE,CREATED_BY,LAST_UPDATED) values ('admin',120,0,1,1,1,current_timestamp,'admin',null);
Insert into ADMIN_ROLE (ADMIN,LINK_ID,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,GEN_DATE,CREATED_BY,LAST_UPDATED) values ('admin',122,0,0,0,1,current_timestamp,'admin',null);
Insert into ADMIN_ROLE (ADMIN,LINK_ID,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,GEN_DATE,CREATED_BY,LAST_UPDATED) values ('admin',124,0,1,1,1,current_timestamp,'admin',null);
Insert into ADMIN_ROLE (ADMIN,LINK_ID,IS_SELECT,IS_INSERT,IS_UPDATE,IS_DELETE,GEN_DATE,CREATED_BY,LAST_UPDATED) values ('admin',100,0,1,1,1,current_timestamp,'admin',null);

commit;







