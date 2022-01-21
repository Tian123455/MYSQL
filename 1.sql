-- 1.创建表
/*创建员工表employee，字段如下：
  id(员工编号)，name(员工名字),gender(员工性别),salary(员工薪资)
*/
create database if not exists mydb1;
/*use mydb1;*/
create table if not exists mydb1.employee(
id int,
name varchar(20),
gender varchar(20),
salary int 
);

-- 2.插入数据
/*
 1,'张三','男',2000
 2,'李四','男',1000
 3,'王五','女',4000
*/
insert into mydb1.employee (id,name,gender,salary)values(1,'张三','男',2000),
                     (2,'李四','男',1000),
                     (3,'王五','女',4000);

-- 3.修改表数据
-- 3.1将所有员工薪水修改为5000元
update mydb1.employee set salary =5000;

-- 3.2将姓名为‘张三’的员工薪水修改为3000元
update mydb1.employee set salary =3000 where name ='张三';

-- 3.3将姓名为‘李四’的员工薪水修改为4000元，gender改为女
update mydb1.employee set salary =4000,gender ='女' where name ='李四';

-- 3.4将王五的薪水在原有基础上增加1000元
update mydb1.employee set salary =salary+1000 where name ='王五';