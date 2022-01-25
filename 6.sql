-- 多表查询

create database mydb3;
use mydb3;
create table if not exists dept(
detpon varchar(20) primary key,-- 部门号
name varchar(20)-- 部门名字
);

create table if not exists emp(
eid varchar(20) primary key,-- 员工编号
ename varchar(20),-- 员工名字
age int,-- 员工年龄
dept_id varchar(20),-- 员工所属部门
constraint emp_fk foreign key (dept_id) references dept (deptno) 
);


-- 创建部门表
create table if not exists dept2(
  deptno varchar(20) primary key ,  -- 部门号
  name varchar(20) -- 部门名字
);
-- 创建员工表
create table if not exists emp2(
  eid varchar(20) primary key , -- 员工编号
  ename varchar(20), -- 员工名字
  age int,  -- 员工年龄
  dept_id varchar(20)  -- 员工所属部门
);
-- 创建外键约束
alter table emp2 add constraint dept_id_fk foreign key(dept_id) references dept2 (deptno);


-- 添加主表数据,注意必须先给主表添加数据
insert into dept values('1001','研发部');
insert into dept values('1002','销售部');
insert into dept values('1003','财务部');
insert into dept values('1004','人事部');

-- 添加从表数据,注意给从表添加数据时，外键列的值不能随便写，必须依赖主表的主键列
insert into emp values('1','乔峰',20, '1001');
insert into emp values('2','段誉',21, '1001');
insert into emp values('3','虚竹',23, '1001');
insert into emp values('4','阿紫',18, '1002');
insert into emp values('5','扫地僧',35, '1002');
insert into emp values('6','李秋水',33, '1003');
insert into emp values('7','鸠摩智',50, '1003'); 
-- 删除数据
delete from dept where dept = '1001'; -- 不可以删除
delete from dept where dept = '1004'; -- 可以删除
delete from emp where eid = '7'; 

-- 删除外键约束
alter table emp2 drop foreign key dept_id_fk;




-- 多对多
use mydb3;
-- 创建学生表
create table if not exists student(
sid int primary key auto_increment,
name varchar(20),
age int,
gender varchar(20)
);
-- 创建课程表
create table if not exists course(
cid int primary key auto_increment,
cidname varchar(20)
);
-- 创建中间表
create table score(
sid int,
cid int,
score double
);
-- 建立外键约束
alter table score add foreign key (sid) references student(sid);
alter table score add foreign key (cid) references course(cid);
-- 添加数据
insert into student values(1,'小龙女',18,'女'),(2,'阿紫',19,'女'),(3,'周芷若',20,'男');
insert into course values(1,'语文'),(2,'数学'),(3,'英语');
insert into score values (1,1,75),(1,2,83),(2,1,67),(2,3,80),(3,2,90),(3,3,88);
-- 修改或删除时，中间从表可以随便删除和修改，但是两边的主表受从表依赖的数据不能删除或者修改

