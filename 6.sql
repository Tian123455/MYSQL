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
