-- *********************索引
create database mydb5;
use mydb5;

-- ---------单列索引-普通索引------
-- 创建索引
-- 1.创建表时直接指定
  create table student(
 sid int primary key,
 card_id varchar(20),
 name varchar(20),
 gender varchar(20),
 age int,
 phone_num varchar(20),
 score  double,
 index index_name(name) -- 给name列创建索引
 );

-- 2.直接创建
create index index_gender on student(gender);

-- 3.修改表结构
alter table student add index index_age(age);

-- 查看索引
-- 1.查看数据库所有索引
select * from mysql.`innodb_index_stats`a where a.`database_name`='mydb5';
-- 2.查看表中所有索引
select * from mysql.`innodb_index_stats`a where a.`database_name`='mydb5' and a.table_name like '%student';
-- 3.查看表中所有索引
show index from student;

-- 删除索引
drop index index_gender on student;

alter table student drop index index_age; 


-- ---单列索引-唯一索引-----
-- 创建索引
-- 1.创建表时直接指定
  create table student2(
 sid int primary key,
 card_id varchar(20),
 name varchar(20),
 gender varchar(20),
 age int,
 phone_num varchar(20),
 score  double,
 unique index_card_id(card_id) -- 给name列创建索引
 );
-- 2.直接创建
  create table student3(
 sid int primary key,
 card_id varchar(20),
 name varchar(20),
 gender varchar(20),
 age int,
 phone_num varchar(20),
 score  double
 ); 
create unique index index_card_id on student3(card_id);
-- 3.修改表结构
alter table student2 add unique index_phone_num(phone_num);

-- 删除索引
drop index index_card_id on student2;

alter table student2 drop index index_phone_num;

-- ---单列索引-主键索引----
show index from student2;


-- 组合索引/复合索引
-- 创建索引-- 普通索引
create index index_phone_num on student(phone_num,name);

drop index index_phone_num on student; 
-- 唯一索引
create  unique index index_phone_name on student(phone_num,name); 


-- ---全文索引-----
-- 创建索引
-- 1.创建表的时候添加全文索引-效率低
create table t_article (
     id int primary key auto_increment ,
     title varchar(255) ,
     content varchar(1000) ,
     writing_date date  , 
    fulltext (content) -- 创建全文检索
);
insert into t_article values(null,"Yesterday Once More","When I was young I listen to the radio",'2021-10-01');
insert into t_article values(null,"Right Here Waiting","Oceans apart, day after day,and I slowly go insane",'2021-10-02'); 
insert into t_article values(null,"My Heart Will Go On","every night in my dreams,i see you, i feel you",'2021-10-03');
insert into t_article values(null,"Everything I Do","eLook into my eyes,You will see what you mean to me",'2021-10-04');
insert into t_article values(null,"Called To Say I Love You","say love you no new year's day, to celebrate",'2021-10-05');
insert into t_article values(null,"Nothing's Gonna Change My Love For You","if i had to live my life without you near me",'2021-10-06');
insert into t_article values(null,"Everybody","We're gonna bring the flavor show U how.",'2021-10-07');

-- 2.修改表结构添加全文索引
alter table t_article add fulltext index_content(content);

-- 3.直接添加全文索引
drop index index_content on  t_article;

create fulltext index index_content on t_article(content);

-- 使用索引-至少三个单词数
select * from t_article where match(content) against('you'); 

-- ---空间索引-----
create table shop_info (
  id int primary key auto_increment comment 'id',
  shop_name varchar(64) not null comment '门店名称',
  geom_point geometry not null comment '经纬度',
  spatial key geom_index(geom_point)
);
