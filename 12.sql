-- -----------储存函数
create database mydb9_function;
-- 导入测试数据
use mydb9_function;
set global log_bin_trust_function_creators=TRUE; -- 信任子程序的创建者

-- 创建存储函数-没有输输入参数
drop function if exists myfunc1_emp;
 
delimiter $$
create function myfunc1_emp() returns int
begin
  declare cnt int default 0;
    select count(*) into  cnt from emp;
  return cnt;
end $$
delimiter ;
-- 调用存储函数
select myfunc1_emp();

-- 创建存储过程-有输入参数

drop function if exists myfunc2_emp;
delimiter $$
create function myfunc2_emp(in_empno int) returns varchar(50)
begin
    declare out_name varchar(50);
    select ename into out_name from emp where  empno = in_empno;
    return out_name;
end $$
delimiter ;

select myfunc2_emp(1008);


-- -----------------触发器
-- 数据准备
create database if not exists mydb10_trigger;
use mydb10_trigger;

-- 用户表
create table user(
    uid int primary key ,
    username varchar(50) not null,
    password varchar(50) not null
);
-- 用户信息操作日志表
create table user_logs(
    id int primary key auto_increment,
    time timestamp,
    log_text varchar(255)
);
-- 当user表添加一行数据，则user——log添加日志记录
-- 如果触发器存在，则先删除
drop trigger if  exists trigger_test1;

-- 创建触发器trigger_test1
create trigger trigger_test1 after insert 
on user for each row-- 触发时机：当添加user表数据时触发
insert into user_logs values(NULL,now(), '有新用户注册');

-- 添加数据，触发器自动执行并添加日志代码
insert into user values(1,'张三','123456');

-- 当user表数据被修改，则user——log添加日志记录
-- 如果触发器trigger_test2存在，则先删除
drop trigger if exists trigger_test2;

-- 创建触发器trigger_test2
delimiter $$
create trigger trigger_test2 after update
on user for each row-- 触发时机：当修改user表数据时触发 每一行
begin
insert into user_logs values(NULL,now(), '用户信息发生了修改');
end $$
 
delimiter ;

-- 添加数据，触发器自动执行并添加日志代码
update user set password = '888888' where uid = 1;

-- ---NEW和OLD
-- insert类型触发器
-- NEW
drop trigger if exists trigger_test3;

create trigger trigger_test3 after insert 
on user for each row-- 触发时机：当添加user表数据时触发
insert into user_logs values(NULL,now(),concat('有新用户添加，信息为：',NEW.uid,NEW.username,NEW.password));

insert into user values(2,'王五','123456');

-- update类型触发器
-- OLD
drop trigger if exists trigger_test4;
create trigger trigger_test4 after update
on user for each row-- 触发时机：当添加user表数据时触发
insert into user_logs values(NULL,now(),concat('有用户信息修改，信息修改之前为:',OLD.uid,OLD.username,OLD.password));

update user set password ='999999'where uid =2;
-- NEW
drop trigger if exists trigger_test5;
create trigger trigger_test5 after update
on user for each row-- 触发时机：当添加user表数据时触发
insert into user_logs values(NULL,now(),concat_ws(',','有用户信息修改，信息修改之后为:',NEW.uid,NEW.username,NEW.password));

update user set password ='222222'where uid =1;

-- delate类型触发器
-- OLD
drop trigger if exists trigger_test6;
create trigger trigger_test6 after update
on user for each row-- 触发时机：当添加user表数据时触发
insert into user_logs values(NULL,now(),concat_ws(',','有用户被删除，删除用户信息为:',OLD.uid,OLD.username,OLD.password));

delete from user where uid =2;

-- 查看触发器
show triggers;
-- 删除触发器
drop trigger if exists trigger_test1;