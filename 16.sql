-- **********锁机制
-- 表锁
drop database if exists  mydb14_lock;
create database mydb14_lock ;

use mydb14_lock;

create table tb_book (
  id int(11) auto_increment,
  name varchar(50) default null,
  publish_time date default null,
  status char(1) default null,
  primary key (id)
) engine=myisam default charset=utf8 ;
 
insert into tb_book (id, name, publish_time, status) values(null,'java编程思想','2088-08-01','1');
insert into tb_book (id, name, publish_time, status) values(null,'solr编程思想','2088-08-08','0');


create table tb_user (
  id int(11) auto_increment,
  name varchar(50) default null,
  primary key (id)
) engine=myisam default charset=utf8 ;

insert into tb_user (id, name) values(null,'令狐冲');
insert into tb_user (id, name) values(null,'田伯光');


-- 行锁 
drop table if exists test_innodb_lock;
create table test_innodb_lock(
    id int(11),
    name varchar(16),
    sex varchar(1)
)engine = innodb ;

insert into test_innodb_lock values(1,'100','1');
insert into test_innodb_lock values(3,'3','1');
insert into test_innodb_lock values(4,'400','0');
insert into test_innodb_lock values(5,'500','1');
insert into test_innodb_lock values(6,'600','0');
insert into test_innodb_lock values(7,'700','0');
insert into test_innodb_lock values(8,'800','1');
insert into test_innodb_lock values(9,'900','1');
insert into test_innodb_lock values(1,'200','0');

create index idx_test_innodb_lock_id on test_innodb_lock(id);
create index idx_test_innodb_lock_name on test_innodb_lock(name);
