

use mydb1;
-- 自增长约束
create table t_user1 (
 id int primary key auto_increment,
 name varchar(20)
 );

insert into t_user1 values(NULL,'张三');
insert into t_user1(name) values('李四');

delete from t_user1;-- 删除数据后，自增长还是在最后一个值基础上加1
	insert into t_user1 values(NULL,'张三');
	
truncate t_user1;	-- 删除数据之后，自增长从1开始
	
	insert into t_user1 values(NULL,'张三');
-- 创建表时指定初始值
create table t_user2 (
 id int primary key auto_increment,
 name varchar(20)
 )auto_increment=100;

insert into t_user2 values(NULL,'张三');
insert into t_user2(name) values('李四');

-- 创建表之后指定
create table t_user3 (
 id int primary key auto_increment,
 name varchar(20)
 );
alter table t_user3 auto_increment=200;

insert into t_user3 values(NULL,'张三');
insert into t_user3(name) values('李四');



-- 非空约束
-- 创建表时指定：<字段名><数据类型> not null;
create table t_user4(
id int,
name varchar(20) not null,-- 指定非空约束
address varchar(20)not null -- 指定非空约束
);
insert into t_user4(id) values (1001);

-- 创建表之后指定：alter table 表名 modify 字段 类型 not null;
create table t_user5(
id int,
name varchar(20),-- 指定非空约束
address varchar(20) -- 指定非空约束
);
alter table t_user5 modify name varchar(20) not null;
alter table t_user5 modify address varchar(20) not null;

desc t_user5;-- 查讯表结构

-- 删除非空约束
-- alter table 表名 modify 字段 类型 
alter table t_user5 modify name varchar(20);
alter table t_user5 modify address varchar(20);


-- 唯一约束
-- 创建表时指定<字段名> <数据类型> unique;
create table t_user6(
id int,
name varchar(20) ,
phone_number varchar(20) unique -- 指定唯一约束
);

insert into t_user6 values (1001,'张三',138);
insert into t_user6 values (1002,'张三',NULL);-- 在MYSQL中NULL和任何值都不相同
-- 创建表后指定 alter table 表名 add constraint 约束名 unique(列);
create table t_user7(
id int,
name varchar(20) ,
phone_number varchar(20) 
);
alter table t_user7 add constraint unique_pn unique(phone_number);
insert into t_user7 values (1001,'张三',138);


-- 删除唯一约束
-- alter table <表名> drop index <唯一约束名>;
alter table t_user7 drop index unique_pn;


-- 默认约束
-- 创建表时指定<字段名> <数据类型> default <默认值>;
create table t_user8(
id int,
name varchar(20) ,
address varchar(20) default '北京'-- 指定默认约束
);
insert into t_user8(id,name) values (1001,'张三');
insert into t_user8(id,name,address) values (1002,'李四','上海');
-- 创建表后指定alter table 表名 modify 列名 类型 default 默认值; 
create table t_user9(
id int,
name varchar(20) ,
address varchar(20) 
);
alter table t_user9 modify address varchar(20) default '北京';
insert into t_user9(id,name) values (1001,'张三');
insert into t_user9(id,name,address) values (1002,'李四','上海');

-- 删除默认约束
-- alter table <表名> modify column <字段名> <类型> default null; 
alter table t_user9 modify column address varchar(20) default null;
insert into t_user9(id,name) values (1002,'赵五');

-- 零填充约束
create table t_user10 ( 
  id int zerofill , -- 零填充约束
  name varchar(20)   
);
insert into t_user10 values (123,'赵五');
-- 删除约束
alter table t_user10 modify id int;
