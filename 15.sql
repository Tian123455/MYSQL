-- ***********事务
create database if not exists mydb12_transcation;
use mydb12_transcation;
create table account(
id int primary key,
name varchar(20),
money double
);
insert into account values(1,'zhangsan',1000);
insert into account values(2,'lisi',1000);

-- 关闭自动提交
select @@autocommit;
set autocommit = 0;

-- 模拟转账
-- 开启事务
begin;

-- id为1的账户转账200给id为2的账户
update account set money = money - 200 where name = 'zhangsan';
update account set money = money + 200 where name = 'lisi';

-- 提交事务
commit;

-- 回滚事务
rollback;

select * from account;




-- 查看隔离级别 
show variables like '%isolation%';

-- 设置隔离级别
/*
set session transaction isolation level 级别字符串
级别字符串：read uncommitted、read committed、repeatable read、serializable
*/
-- 设置read uncommitted
set session transaction isolation level read uncommitted;
--  会引起脏读，A事务读取到B事务没有提交的数据

-- 设置read committed
set session transaction isolation level read committed;
-- 不可重复读，A事务在没有提交期间，读取到B事务操作数据是不同的

-- 设置repeatable read（MYSQL默认）
set session transaction isolation level repeatable read;
--  可重复读，A事务再提交之前和提交之后看到的数据不一致

-- 设置serializable
set session transaction isolation level serializable;
-- 比较安全，但是效率低，A事务在操作表时，表会被锁起，B事务不能操作


