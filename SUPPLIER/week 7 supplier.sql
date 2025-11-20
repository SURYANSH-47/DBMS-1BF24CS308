create database supplier;
use supplier;
create table SUPPLIERS(sid int primary key, sname varchar(20), city varchar(20));
create table PARTS(pid int primary key, pname varchar(20), color varchar(10));
create table CATALOG(sid int, pid int,  foreign key(sid) references SUPPLIERS(sid), foreign key(pid) references PARTS(pid), cost float(6), primary key(sid, pid));
insert into suppliers values(10001, ' Acme Widget','Bangalore');
insert into suppliers values(10002, ' Johns','Kolkata');
insert into suppliers values(10003, ' Vimal','Mumbai');
insert into suppliers values(10004, ' Reliance','Delhi');
insert into suppliers values(10005, ' Mahindra','Mumbai');
insert into PARTS values(20001, 'Book','Red');
insert into PARTS values(20002, 'Pen','Red');
insert into PARTS values(20003, 'Pencil','Green');
insert into PARTS values(20004, 'Mobile','Green');
insert into PARTS values(20005, 'Charger','Black');
insert into CATALOG values(10001, 20001,10);
insert into CATALOG values(10001, 20002,10);
insert into CATALOG values(10001, 20003,30);
insert into CATALOG values(10001, 20004,10);
insert into CATALOG values(10001, 20005,10);
insert into CATALOG values(10002, 20001,10);
insert into CATALOG values(10002, 20002,20);
insert into CATALOG values(10003, 20003,30);
insert into CATALOG values(10004, 20003,40);
select * from suppliers;select * from parts;select * from catalog;

-- PNAME OF PARTS HAVING SOME SUPPLIER
select distinct pname from parts p,catalog c where p.pid=c.pid;

-- SUPPLIERS SUPPLYING EVERY PART
select sname from suppliers s,catalog c where s.sid=c.sid group by sname 
having count(*)=(select count(pid)from parts);

-- SUPPLIES WHO SUPPLY EVERY RED PART
SELECT DISTINCT SNAME FROM SUPPLIERS S,CATALOG C WHERE S.SID=C.SID AND C.PID IN(SELECT PID FROM PARTS WHERE COLOR="RED")GROUP BY SNAME
HAVING COUNT(*)=(SELECT COUNT(*) FROM PARTS WHERE COLOR="RED");

-- SUPPLIER CHARGING MOST FOR A PARTICULAR PART
SELECT PID,SNAME FROM SUPPLIERS S,CATALOG C WHERE S.SID=C.SID AND C.COST=(SELECT MAX(COST) FROM PARTS P,CATALOG W WHERE P.PID=W.PID AND C.PID=P.PID);

-- SIDS FOF SUPPLIOER WHO CHARGE MAX FOR SOME PARTS THAN AVG COST OF THAT PART
SELECT DISTINCT C.SID FROM CATALOG C WHERE C.COST>(SELECT AVG(C1.COST) FROM CATALOG C1 WHERE C1.PID=C.PID);

-- PARTS SUPPLIED BY ACME WIDGET ONLY 
SELECT PNAME,PID FROM PARTS P WHERE PID NOT IN (SELECT PID FROM CATALOG WHERE SID!=(SELECT SID FROM SUPPLIERS WHERE SNAME=" ACME WIDGET"));