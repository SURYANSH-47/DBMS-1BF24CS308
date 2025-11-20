create database EMPLOYEE;show databases;
use EMPLOYEE;
CREATE TABLE DEPT( deptno INT primary key,dname varchar(20) default NULL,loc varchar(20) default NULL);
CREATE TABLE EMP(empno int primary key,ename varchar(20) DEFAULT NULL,MGR_NO INT DEFAULT NULL,HIREDATE DATE DEFAULT NULL,SAL INT DEFAULT NULL,
DEPTNO INT,foreign key(DEPTNO) REFERENCES DEPT(DEPTNO) ON DELETE CASCADE ON UPDATE CASCADE);
CREATE TABLE INCENTIVES(EMPNO INT,INCENTIVE_DATE DATE,INCENTIVE_AMOUNT decimal(10,2),PRIMARY KEY(EMPNO,INCENTIVE_DATE),FOREIGN KEY(EMPNO) REFERENCES EMP(EMPNO) ON DELETE CASCADE ON UPDATE CASCADE);
CREATE TABLE PROJECT(PNO INT PRIMARY KEY,PNAME VARCHAR(20) NOT NULL,PLOC VARCHAR(20));
CREATE TABLE ASSIGN_TO(EMPNO INT,PNO INT,JOB_ROLE VARCHAR(20),PRIMARY KEY(EMPNO,PNO),foreign key(EMPNO) REFERENCES EMP(EMPNO) ON delete CASCADE ON UPDATE CASCADE,FOREIGN KEY(PNO) REFERENCES
PROJECT(PNO) ON DELETE CASCADE ON UPDATE CASCADE);
SHOW TABLES;
INSERT INTO DEPT(DEPTNO,DNAME,loc) VALUES(10,'ACCOUNTING','MUMBAI'),(20,'RESEARCH','BENGALURU'),(30,'SALES','DELHI'),(40,'OPERATIONS','CHENNAI');
alter table dept rename column loc to Dloc;
select * from dept;
INSERT INTO EMP(EMPNO,ENAME,MGR_NO,HIREDATE,SAL,DEPTNO) VALUES(7369,'Adarsh',7902,'2012-12-17','80000.00','20');
INSERT INTO emp VALUES (7499,'Shruthi',7698,'2013-02-20',16000.00,30);
INSERT INTO emp VALUES (7521,'Anvitha',7698,'2015-02-22','12500.00','30');
INSERT INTO emp VALUES (7566,'Tanvir',7839,'2008-04-02','29750.00','20');
INSERT INTO emp VALUES (7654,'Ramesh',7698,'2014-09-28','12500.00','30');
INSERT INTO emp VALUES (7698,'Kumar',7839,'2015-05-01','28500.00','30');
INSERT INTO emp VALUES (7782,'CLARK',7839,'2017-06-09','24500.00','10');
INSERT INTO emp VALUES (7788,'SCOTT',7566,'2010-12-09','30000.00','20');
INSERT INTO emp VALUES ('7839','KING',NULL,'2009-11-17','500000.00','10');
INSERT INTO emp VALUES ('7844','TURNER',7698,'2010-09-08','15000.00','30');
INSERT INTO emp VALUES ('7876','ADAMS',7788,'2013-01-12','11000.00','20');
INSERT INTO emp VALUES ('7900','JAMES',7698,'2017-12-03','9500.00','30');
INSERT INTO emp VALUES ('7902','FORD','7566','2010-12-03','30000.00','20');

INSERT INTO incentives VALUES(7499,'2019-02-01',5000.00);
INSERT INTO incentives VALUES(7521,'2019-03-01',2500.00);
INSERT INTO incentives VALUES(7566,'2022-02-01',5070.00);
INSERT INTO incentives VALUES(7654,'2020-02-01',2000.00);
INSERT INTO incentives VALUES(7654,'2022-04-01',879.00);
INSERT INTO incentives VALUES(7521,'2019-02-01',8000.00);
INSERT INTO incentives VALUES(7698,'2019-03-01',500.00);
INSERT INTO incentives VALUES(7698,'2020-03-01',9000.00);
INSERT INTO incentives VALUES(7698,'2022-04-01',4500.00);

INSERT INTO project VALUES(101,'AI Project','BENGALURU');
INSERT INTO project VALUES(102,'IOT','HYDERABAD');
INSERT INTO project VALUES(103,'BLOCKCHAIN','BENGALURU');
INSERT INTO project VALUES(104,'DATA SCIENCE','MYSURU');
INSERT INTO project VALUES(105,'AUTONOMUS SYSTEMS','PUNE');

INSERT INTO assign_to VALUES(7499,101,'Software Engineer');
INSERT INTO assign_to VALUES(7521,101,'Software Architect');
INSERT INTO assign_to VALUES(7566,101,'Project Manager');
INSERT INTO assign_to VALUES(7654,102,'Sales');
INSERT INTO assign_to VALUES(7521,102,'Software Engineer');
INSERT INTO assigN_to VALUES(7499,102,'Software Engineer');
INSERT INTO assign_to VALUES(7654,103,'Cyber Security');
INSERT INTO assign_to VALUES(7698,104,'Software Engineer');
INSERT INTO assign_to VALUES(7900,105,'Software Engineer');
INSERT INTO assign_to VALUES(7839,104,'General Manager');
SELECT * FROM DEPT;SELECT * FROM ASSIGN_TO;SELECT * FROM EMP;SELECT * FROM PROJECT;SELECT * FROM INCENTIVES; 

-- 4
select empno from emp where empno not in(select empno from incentives);


select avg(sal) from emp where mgr_no in (select mgr_no from emp);
select * from emp m where m.empno in(select distinct mgr_no from emp) and m.sal>(select avg(e.sal) from emp e where e.mgr_no=m.empno);
select * from emp e,emp m where e.empno=m.mgr_no and m.sal>(select avg(e.sal) from emp); /*wrong*/
select * from emp e,incentives i where e.empno=i.empno and 2=(select count(*) from incentives j where i.incentive_amount<=j.incentive_amount);

-- 3
select empno from assign_to where pno in(select pno from project where ploc in("Bengaluru","Hyderabad","Mysuru"));

-- 5
select e.empno,e.ename,e.deptno,a.job_role from emp e,assign_to a where e.empno=a.empno 
and (e.deptno,a.pno)in(select deptno,pno from dept d,project p where ploc=dloc);
select e.empno,e.ename,d.dname,a.job_role,p.ploc,d.dloc from emp e,project p,assign_to a,dept d where 
e.empno=a.empno and d.dloc=p.ploc and p.pno=a.pno and e.deptno=d.deptno;
select incentive_amount from incentives where year(incentive_date)='2019' and month(incentive_date)='02';

/*week 6*/
-- 4
select * from emp e,incentives i where (e.empno,i.incentive_amount) in(select empno,max(incentive_amount) from incentives 
where incentive_amount<(select max(incentive_amount) from incentives where year(incentive_date)='2019' and month(incentive_date)='02') 
and year(incentive_date)='2019' and month(incentive_date)='02' group by empno);

select * from emp e where e.empno in(select distinct mgr_no from emp) and e.deptno in(select deptno from emp m where e.deptno=m.deptno);

-- 5
select * from emp e where e.deptno=(select e1.deptno from emp e1 where e1.empno=e.mgr_no);

-- 6
select distinct e.ename from emp e,incentives i where(select max(sal+incentive_amount) from emp,incentives)>=any(select sal from emp e1 where e.deptno=e1.deptno);

-- 2
SELECT * FROM EMP M WHERE M.EMPNO IN (SELECT DISTINCT MGR_NO FROM EMP) AND M.SAL>(SELECT AVG(E.SAL) FROM EMP E WHERE E.MGR_NO=M.EMPNO);

-- 1
select M.ENAME,COUNT(*) FROM EMP AS E,EMP AS M WHERE
E.MGR_NO=M.EMPNO GROUP BY M.ENAME
HAVING COUNT(*)=(SELECT MAX(MYCOUNT) FROM (select COUNT(*) MYCOUNT FROM EMP GROUP BY MGR_NO) AS T);

