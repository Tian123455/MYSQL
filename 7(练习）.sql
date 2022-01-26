create database test1;
use test1;
create table dept(
deptno int primary key,
dname varchar(20),
loc varchar(13)
);
insert into dept values (10,'accounting','new york');
insert into dept values (20,'research','dallas');
insert into dept values (30,'sales','chicago');
insert into dept values (40,'operations','boston');
create table emp(
empno int primary key,
ename varchar(20),
job varchar(20),
mgr int ,-- 员工直属领导编号
hiredate date,-- 入职时间
sal double,-- 工资
comm double,-- 奖金
deptno int
);
alter into emp add constraint foreign key emp(deptno) references dept(deptno);

insert into emp values(7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20);
insert into emp values(7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600,300,30);
insert into emp values(7521,'WARD','SALESMAN',7698,'1981-02-22',1250,500,30);
insert into emp values(7566,'JONES','MANAGER',7839,'1981-04-02',2975,NULL,20);
insert into emp values(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30);
insert into emp VALUES(7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,NULL,30);
insert into emp VALUES(7782,'CLARK','MANAGER',7839,'1981-06-09',2450,NULL,10);
insert into emp VALUES(7788,'SCOTT','ANALYST',7566,'1987-04-19',3000,NULL,20);
insert into emp VALUES(7839,'KING','PRESIDENT',NULL,'1981-11-17',5000,NULL,10);
insert into emp VALUES(7844,'TURNER','SALESMAN',7698,'1981-09-08',1500,0,30);
insert into emp VALUES(7876,'ADAMS','CLERK',7788,'1987-05-23',1100,NULL,20);
insert into emp VALUES(7900,'JAMES','CLERK',7698,'1981-12-03',950,NULL,30);
insert into emp VALUES(7902,'FORD','ANALYST',7566,'1981-12-03',3000,NULL,20);
insert into emp values(7934,'MILLER','CLERK',7782,'1982-01-23',1300,NULL,10);

create table salgrade(
grade int,
losal double,
hisal double
);
insert into salgrade values (1,700,1200);
insert into salgrade values (2,1201,1400);
insert into salgrade values (3,1401,2000);
insert into salgrade values (4,2001,3000);
insert into salgrade values (5,3001,9999);

-- 返回拥有员工的部门名，部门号
select distinct d.dname,d.deptno from dept d join emp e on d.deptno=e.deptno;
-- 工资水平多于SMITH的员工信息
select * from emp where sal>(select sal from emp where ename='SMITH');
-- 返回员工和所属经理的姓名
select a.ename,b.ename from emp a, emp b where a.empno=b.mgr;
-- 返回雇员的雇佣日期早于其经理雇佣日期的员工及经理姓名
select a.ename,a.hiredate,b.ename,b.hiredate from emp a join emp b on a.mgr=b.empno and a.hiredate < b.hiredate;
-- 返回员工姓名及其所在的部门名称
select a.ename,b.dname from emp a join dept b on a.deptno = b.deptno;
-- 返回从事CLERK工作的员工姓名和所在部门名称
select a.ename,b.dname from emp a join dept b on a.deptno = b.deptno and a.job= 'CLERK';
-- 返回部门号及其基本部门的最低工资
select deptno,min(sal) from emp group by deptno;
-- 返回销售部（sales）所有员工的姓名
select b.ename,a.dname,b.job from dept a,emp b where a.deptno=b.deptno and a.dname='sales';
-- 返回工资水平多于平均工资的员工
select * from emp where sal >(select avg(sal) from emp);
-- 返回与SCOTT从事相同工作的员工
select * from emp where job =(select job from emp where ename ='SCOTT') and ename !='SCOTT';
-- 返回工资高于30部门所有员工工资水平的员工信息
select * from emp where sal >all(select sal from emp where deptno =30);
-- 返回员工工作及其从事此工作的最低工资
select job,min(sal) from emp group by job;
-- 计算出员工的年薪，并且以年薪排序
select ename,(sal*12 + ifnull(comm,0)) as year_sal from emp order by (sal*12 + ifnull(comm,0)) desc;
-- 返回工资处于第四级别的员工的姓名
select * from emp where sal between (select losal from salgrade where grade =4) and (select hisal from salgrade where grade =4);
-- 返回工资为第二级别的职员名字，部门所在地
select 
* 
from dept a
join emp b on a.deptno=b.deptno
join salgrade c on grade =2 and b.sal >= c.losal and b.sal <=c.hisal;
-- --------------------------------------------------
select 
* 
from dept a, emp b,salgrade c 
where a.deptno=b.deptno and grade =2 and b.sal >= c.losal and b.sal <=c.hisal;

