/*
-- 在 create table 语句中，通过 PRIMARY KEY 关键字来指定主键。
--在定义字段的同时指定主键，语法格式如下：
create table 表名(
   ...
   <字段名> <数据类型> primary key 
   ...
)
*/
use mydb1;
create table emp1(
    eid int primary key,-- 唯一标识
    name VARCHAR(20),
    deptId int,
    salary double
);
/*
--在定义字段之后再指定主键，语法格式如下：
create table 表名(
   ...
   [constraint <约束名>] primary key [字段名]
);
*/
create table emp2(
    eid INT,
    name VARCHAR(20),
    deptId INT,
    salary double,
    /*constraint  pk1 */primary key(eid)
 );

-- 主键作用

insert into emp2(eid,name,deptid,salary)values (1001,'张三',10,5000);
insert into emp2(eid,name,deptid,salary)values (1002,'李四',20,6000);
insert into emp2(eid,name,deptid,salary)values (1003,'王五',30,7000);

-- 联合主键（每一列都不能为空）
-- 所谓的联合主键，就是这个主键是由一张表中多个字段组成的
--    primary key （字段1，字段2，…,字段n)
create table emp3( 
  name varchar(20), 
  deptId int, 
  salary double, 
  constraint  pk2 primary key(name,deptId) 
);
insert into emp3 values ('张三',10,5000);
insert into emp3 values ('李四',10,5000);


-- 通过修改表结构添加主键

/*create table 表名(
   ...
);
alter table <表名> add primary key（字段列表);
*/
-- 添加单列主键
create table emp4(
  eid int, 
  name varchar(20), 
  deptId int, 
  salary double 
);
alter table emp4 add primary key(eid);

-- 添加联合主键
create table emp5(
  eid int, 
  name varchar(20), 
  deptId int, 
  salary double 
);
alter table emp5 add primary key(name,deptid);

-- 删除主键约束
-- alter table <数据表名> drop primary key;
-- 删除单列主键 
alter table emp1 drop primary key;
 
-- 删除联合主键 
alter table emp5 drop primary key;
