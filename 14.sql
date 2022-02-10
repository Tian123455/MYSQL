-- *********储存引擎
-- 查询当前数据库支持的存储引擎：
show engines;
 
-- 查看当前的默认存储引擎：
show variables like '%default_storage_engine%';

-- 查看某个表用了什么引擎(在显示结果里参数engine后面的就表示该表当前用的存储引擎): 
create database mydb11_engines;
use mydb11_engines;

create table stu1(id int,name varchar(20));

show create table stu1; 

-- 创建新表时指定存储引擎：
create table stu2(id int,name varchar(20)) engine=MyISAM;

show create table stu2;
-- 修改数据库引擎
alter table stu2 engine = INNODB;
alter table stu1 engine = MyISAM;






