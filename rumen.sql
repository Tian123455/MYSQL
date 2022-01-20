-- 1、DDL操作之数据库

-- 查看所有数据库
show databases;
-- 创建数据库
create database mydb1;
create database if not exists mybd1;
-- 选择使用哪一个数据库
use mydb1;
-- 删除数据库
drop database mydb1;
drop database if exists mydb1;

-- 修改数据库编码
alter database mydb1 CHARACTER set utf8;


-- 选择表
use mydb1;

create table if not exists student(
sid int,
name varchar(20),
gender varchar(10),
age int,
birth date,
address varchar(20)
score double
);