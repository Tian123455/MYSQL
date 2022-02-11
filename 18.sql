-- *********优化

-- 查看SQL执行频率

-- 查看当前会话SQL执行类型的统计信息
show session status like 'Com_______';

-- 查看全局会话SQL执行类型的统计信息
show global status like 'Com_______';

-- 查看针对INNODB引擎的统计信息
show status like 'Innodb_rows_%';

-- 定位低效率执行SQL 
-- 查看慢日志配置信息 
show variables like '%slow_query_log%';

-- 开启慢日志查询 
set global slow_query_log = 1;

-- 查看慢日志记录SQL的最低阈值时间 
show variables like '%long_query_time%';
-- 默认如果SQL的执行时间>=10s，则算慢查询，则会将该操作记录到慢日志中
select sleep(10);

-- 修改慢日志记录SQL的最低阈值时间 
set global long_query_time =5;


-- 通过show processlist查看当前客户端连接服务器的线程执行状态信息
show processlist;

select sleep(30);

--        Explain
-- 查询执行计划
create database mydb13_optimize;
use mydb13_optimize;

-- 1.查询执行语句
explain select * from user where uid =1;



--  Explain之ID
-- 1、id 相同表示加载表的顺序是从上到下
explain select * from user u, user_role ur, role r where u.uid = ur.uid and ur.rid = r.rid ;

-- 2、id 不同id值越大，优先级越高，越先被执行
explain select * from role where rid = (select rid from user_role where uid = (select uid from user where uname = '张飞'));

-- 3、id 有相同，也有不同，同时存在。id相同的可以认为是一组，从上往下顺序执行；在所有的组中，id的值越大，优先级越高，越先执行。
explain select * from role r , (select * from user_role ur where ur.uid = (select uid from user where uname = '张飞')) t where r.rid = t.rid ; 


-- Explain 之 select type
-- SIMPLE:，没有子查询和union
explain select * from user;
explain select * from user u,user_role ur where u.uid = ur.uid;

-- PRIMARY：主查询，也就是子查询中最外层查询
explain select * from role where rid = (select rid from user_role where uid = (select uid from user where uname = '张飞'));

-- SUBQUERY:在select和where中包含子查询
explain select * from role where rid = (select rid from user_role where uid = (select uid from user where uname = '张飞'));

-- DERIVED:在from中包含子查询，被标记为衍生表
select * from (select * from user limit 2)t;

-- UNION
-- union result
explain select * from user where uid =1 union select * from user where uid =3;


-- Explain 之 type
explain select * from user;

-- NULL:不访问任何表，任何索引，直接返回结果
explain select now();
-- SYSTEM查询系统表，表示直接从内存读取数据，不会从磁盘读取，但是5.7及以上版本不再显示system，直接显示all
explain select * from mysql.tables_priv;


-- const 
explain select * from user where uid =2;
explain select * from user where uname ='张三';

create unique index index_uname on user(uname);-- 唯一索引
drop index index_uname on user;

create index index_uname on user(uname); -- 普通索引


-- eq_ref：左表有主键，而且左表的每一行和右表中的每一行刚好匹配
create table user2(
id int,
name varchar(20)
);
insert into user2 values(1,'张三'),(2,'李四'),(3,'王五');
create table user2_ex(
id int,
age int
);
insert into user2_ex values(1,20),(2,21),(3,22);

explain select * from user2 a,user2_ex b where a.id = b.id;

-- 给user2表添加主键索引
alter table user2 add primary key(id);
explain select * from user2 a,user2_ex b where a.id = b.id;


-- ref：左表有普通索引，和右表配置时可能会匹配多行
-- 删除user2表的主键索引
alter table user2 drop primary key;
-- 给user2表添加普通索引
create index index_id on user2 (id);
explain select * from user2 a,user2_ex b where a.id = b.id;


-- range:范围查询
explain select * from user2 where id > 2;


-- index:把索引列的全部数据都扫描
explain select id from user2;


-- all
explain select * from user2;


-- explain其他字段指标
explain select * from user where uid = 1;
explain select * from user_role where uid = 1;

show index from user;
explain select * from user order by uname;
explain select uname,count(*) from user group by uname;
explain select uid,count(*) from user group by uname;


-- show profile分析SQL
-- 查看当前MySQL是否支持profile
select @@have_profiling;

-- 如果不支持，则需要开启
set profiling=1; 

-- 执行SQL
show databases;
use mydb13_optimize;
show tables;
select count(*) from user;
select * from user where uid >2;

show profiles;

show profile for query 20;

show profile cpu for query;  

 
-- trace分析优化器执行计划
set optimizer_trace="enabled=on",end_markers_in_json=on; 
set optimizer_trace_max_mem_size=1000000;

select * from user a,user_role b,role c where a.uid = b.uid and b.rid = c.rid;

select * from information_schema.optimizer_trace\G;


-- 使用索引优化
create table tb_seller (
    `sellerid` varchar (100),
    `name`varchar (100),
    `nickname` varchar (50),
    `password` varchar (60),
    `status` varchar (1),
    `address` varchar (100),
    `createtime` datetime,
    primary key(`sellerid`)
); 
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('alibaba','阿里巴巴','阿里小店','e10adc3949ba59abbe56e057f20f883e','1','北京市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('baidu','百度科技有限公司','百度小店','e10adc3949ba59abbe56e057f20f883e','1','北京市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('huawei','华为科技有限公司','华为小店','e10adc3949ba59abbe56e057f20f883e','0','北京市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('itcast','传智播客教育科技有限公司','传智播客','e10adc3949ba59abbe56e057f20f883e','1','北京市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('itheima','黑马程序员','黑马程序员','e10adc3949ba59abbe56e057f20f883e','0','北京市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('luoji','罗技科技有限公司','罗技小店','e10adc3949ba59abbe56e057f20f883e','1','北京市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('oppo','OPPO科技有限公司','OPPO官方旗舰店','e10adc3949ba59abbe56e057f20f883e','0','北京市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('ourpalm','掌趣科技股份有限公司','掌趣小店','e10adc3949ba59abbe56e057f20f883e','1','北京市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('qiandu','千度科技','千度小店','e10adc3949ba59abbe56e057f20f883e','2','北京市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('sina','新浪科技有限公司','新浪官方旗舰店','e10adc3949ba59abbe56e057f20f883e','1','北京市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('xiaomi','小米科技','小米官方旗舰店','e10adc3949ba59abbe56e057f20f883e','1','西安市','2088-01-01 12:00:00');
insert into `tb_seller` (`sellerid`, `name`, `nickname`, `password`, `status`, `address`, `createtime`) values('yijia','宜家家居','宜家家居旗舰店','e10adc3949ba59abbe56e057f20f883e','1','北京市','2088-01-01 12:00:00');

-- 创建组合索引 
create index idx_seller_name_sta_addr on tb_seller(name,status,address);


-- 避免索引失效-全值匹配，和字段匹配成功即可，和字段无关
explain select * from tb_seller where name='小米科技' and status='1' and address='北京市';

-- 最左前缀法则
 -- 如果索引了多列，要遵守最左前缀法则。指的是查询从索引的最左前列开始，并且不跳过索引中的列。
explain select * from tb_seller where name='小米科技'; 

explain select * from tb_seller where name='小米科技' and status='1'; 
explain select * from tb_seller where  status='1' and name='小米科技'; 
-- 违法最左前缀法则 ， 索引失效：
explain select * from tb_seller where status='1'; 

-- 如果符合最左法则，但是出现跳跃某一列，只有最左列索引生效：
explain select * from tb_seller where name='小米科技'  and address='北京市'; 

-- 范围查询右边的列，不能使用索引 。 
explain select * from tb_seller where name='小米科技' and status >'1' and address='北京市'; 

-- 不要在索引列上进行运算操作， 索引将失效。 
explain select * from tb_seller where substring(name,3,2)='科技'; 

-- 字符串不加单引号，造成索引失效。 
explain select * from tb_seller where name='小米科技' and status = 1 ;

-- 1、范围查询右边的列，不能使用索引 。
-- 根据前面的两个字段name ， status 查询是走索引的， 但是最后一个条件address 没有用到索引。
explain select * from tb_seller where name='小米科技' and status >'1' and address='北京市';

-- 2、不要在索引列上进行运算操作， 索引将失效。
explain select * from tb_seller where substring(name,3,2)='科技'

-- 3、字符串不加单引号，造成索引失效。 
explain select * from tb_seller where name='小米科技' and status = 1 ;

-- 4、尽量使用覆盖索引，避免select *
-- 需要从原表及磁盘上读取数据
explain select * from tb_seller where name='小米科技'  and address='北京市';  

-- 从索引树中就可以查询到所有数据
explain select name from tb_seller where name='小米科技'  and address='北京市';  
explain select name,status,address from tb_seller where name='小米科技'  and address='北京市';  
-- 如果查询列，超出索引列，也会降低性能。
explain select name,status,address,password from tb_seller where name='小米科技'  and address='北京市';  

-- 尽量使用覆盖索引，避免select *
-- 需要从原表及磁盘上读取数据
explain select * from tb_seller where name='小米科技'  and address='北京市'; 

-- 从索引树中就可以查询到所有数据
explain select name from tb_seller where name='小米科技'  and address='北京市';  
explain select name,status,address from tb_seller where name='小米科技'  and address='北京市';  
-- 如果查询列，超出索引列，也会降低性能。
explain select name,status,address,password from tb_seller where name='小米科技'  and address='北京市'; 

-- 用or分割开的条件， 那么涉及的索引都不会被用到。
explain select * from tb_seller where name='黑马程序员' or createtime = '2088-01-01 12:00:00'; 
explain select * from tb_seller where name='黑马程序员' or address = '西安市';  
explain select * from tb_seller where name='黑马程序员' or status = '1';   

-- 以%开头的Like模糊查询，索引失效。
explain select * from tb_seller where name like '科技%'; 
explain select * from tb_seller where name like '%科技'; 
explain select * from tb_seller where name like '%科技%';
-- 弥补不足,不用*，使用索引列
explain select name from tb_seller where name like '%科技%';


--  1、如果MySQL评估使用索引比全表更慢，则不使用索引。
  -- 这种情况是由数据本身的特点来决定的
create index index_address on tb_seller(address);

explain select * from tb_seller where address = '北京市';
explain select * from tb_seller where address = '西安市'; 


--  2、is  NULL ， is NOT NULL  有时有效，有时索引失效。
create index index_address on tb_seller(nickname);
explain select * from tb_seller where nickname is NULL;  
explain select * from tb_seller where nickname is not NULL; 

-- 3、in 走索引，not in 索引失效
-- 普通索引
explain select * from tb_seller where nickname in('阿里小店','百度小店');
explain select * from tb_seller where nickname not in('阿里小店','百度小店');

-- 主键索引
explain select * from tb_seller where sellerid in('alibaba','baidu');
explain select * from tb_seller where sellerid not in('alibaba','baidu');

-- 4、单列索引和复合索引，尽量使用复合索引
-- 如果一张表有多个单列索引，即使where中都使用了这些索引，则只有一个最优索引生效
drop index idx_seller_name_sta_addr on tb_seller;

show index from tb_seller;

create index index_name on tb_seller(name);
create index index_status on tb_seller(status);
create index index_address on tb_seller(address);

explain select * from tb_seller where name ='小米科技' and status ='1' and address ='西安市';


-- SQL优化
-- 大批量插入数据
create table tb_user (
  id int(11) not null auto_increment,
  username varchar(45) not null,
  password varchar(96) not null,
  name varchar(45) not null,
  birthday datetime default null,
  sex char(1) default null,
  email varchar(45) default null,
  phone varchar(45) default null,
  qq varchar(32) default null,
  status varchar(32) not null comment '用户状态',
  create_time datetime not null,
  update_time datetime default null,
  primary key (id),
  unique key unique_user_username (username)
);
-- 主键顺序插入
-- 1、首先，检查一个全局系统变量 'local_infile' 的状态， 如果得到如下显示 Value=OFF，则说明这是不可用的
show global variables like 'local_infile';

-- 2、修改local_infile值为on，开启local_infile
set global local_infile=1;

-- 3、加载数据 
load data local infile 'D:\\sql_data\\sql1.log' into table tb_user fields terminated by ',' lines terminated by '\n';

-- 关闭唯一性校验
set unique_checks=0;

truncate table tb_user;
load data local infile 'D:\\sql_data\\sql1.log' into table tb_user fields terminated by ',' lines terminated by '\n';

set unique_checks=1;


-- 优化insert语句
-- 原始方式为：
insert into tb_test values(1,'Tom');
insert into tb_test values(2,'Cat');
insert into tb_test values(3,'Jerry');

-- 优化后的方案为 ： 
insert into tb_test values(1,'Tom'),(2,'Cat')，(3,'Jerry');

-- 在事务中进行数据插入。
begin;
insert into tb_test values(1,'Tom');
insert into tb_test values(2,'Cat');
insert into tb_test values(3,'Jerry');
commit;

-- 数据有序插入
insert into tb_test values(4,'Tim');
insert into tb_test values(1,'Tom');
insert into tb_test values(3,'Jerry');
insert into tb_test values(5,'Rose');
insert into tb_test values(2,'Cat');

-- 优化后
insert into tb_test values(1,'Tom');
insert into tb_test values(2,'Cat');
insert into tb_test values(3,'Jerry');
insert into tb_test values(4,'Tim');
insert into tb_test values(5,'Rose');


-- 优化order by语句
create table`emp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `age` int(3) NOT NULL,
  `salary` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

insert into `emp` (`id`, `name`, `age`, `salary`) values('1','Tom','25','2300');
insert into `emp` (`id`, `name`, `age`, `salary`) values('2','Jerry','30','3500');
insert into `emp` (`id`, `name`, `age`, `salary`) values('3','Luci','25','2800');
insert into `emp` (`id`, `name`, `age`, `salary`) values('4','Jay','36','3500');
insert into `emp` (`id`, `name`, `age`, `salary`) values('5','Tom2','21','2200');
insert into `emp` (`id`, `name`, `age`, `salary`) values('6','Jerry2','31','3300');
insert into `emp` (`id`, `name`, `age`, `salary`) values('7','Luci2','26','2700');
insert into `emp` (`id`, `name`, `age`, `salary`) values('8','Jay2','33','3500');
insert into `emp` (`id`, `name`, `age`, `salary`) values('9','Tom3','23','2400');
insert into `emp` (`id`, `name`, `age`, `salary`) values('10','Jerry3','32','3100');
insert into `emp` (`id`, `name`, `age`, `salary`) values('11','Luci3','26','2900');
insert into `emp` (`id`, `name`, `age`, `salary`) values('12','Jay3','37','4500');

-- 创建组合索引
create index idx_emp_age_salary on emp(age,salary);

-- 排序，order by
explain select * from emp order by age;
explain select * from emp order by age,salary;

explain select id from emp order by age;
explain select id,age from emp order by age;
explain select id,age,salary,name from emp order by age;-- 前面不能出现非索引序列

explain select id,age from emp order by age,salary;

-- order by 后边的多个排序字段要求尽量排序方式相同
explain select id,age from emp order by age asc,salary desc;
explain select id,age from emp order by age desc,salary desc;
-- order by后边的多个排序字段顺序尽量和组合索引字段顺序一致
explain select id,age from emp order by salary,age ;

show variables like 'max_length_for_sort_data';
show variables like 'sort_buffer_size';


-- 子查询
explain select * from user where uid in (select uid from user_role ); 

explain select * from user u join user_role ur on u.uid = ur.uid;


-- limit查询
select count(*) from tb_user;

select * from tb_user limit 0,10;

select * from tb_user limit 9000000,10;

select * from tb_user a,(select id from tb_user  order by id limit 900000,10) b where a.id =b.id;

select * from tb_user where id > 900000 limit 10;
