create database mydb7_procedure;

use mydb7_procedure;

delimiter $$
create procedure proc01()
begin 
select empno,ename from emp;
end $$
delimiter ;
-- 调用储存过程
call proc01;

-- -----------变量定义
delimiter $$
create procedure proc02()
begin
 declare var_name01 varchar(20) default 'aaa';-- 声明变量
 set var_name01 ='zhangsan';-- 给变量赋值
 select var_name01;-- 输出变量的值
end $$
delimiter;

call proc02;


delimiter $$
create procedure proc03()
begin
declare my_ename varchar(20);
select ename into my_ename from emp where empno = 1001;
select my_ename;
end $$
delimiter;
call proc03();

-- 用户变量
delimiter $$
create procedure proc04()
begin
set @var_ename01 ='beijing';
select @var_ename01;
end $$
delimiter;
call proc04();

-- 系统变量--全局变量

-- 查看全局变量 
show global variables;
-- 查看某全局变量 
select @@global.auto_increment_increment; 
-- 修改全局变量的值 
set global sort_buffer_size = 40000; 
set @@global.sort_buffer_size = 40000;
select @@global.sort_buffer_size;

-- 系统变量--会话变量

-- 查看会话变量
show session variables;
-- 查看某会话变量 
select @@session.auto_increment_increment;
-- 修改会话变量的值
set session sort_buffer_size = 50000; 
set @@session.sort_buffer_size = 50000 ;
select  @@session.sort_buffer_size;

-- 存储过程传参
-- in 传入
-- 封装有参数的存储过程，传入员工编号，查找员工信息
delimiter $$
create procedure proc06(in param_empno int )
begin
select * from emp where empno = param_empno;
end $$
delimiter ;
call proc06(1001);
call proc06(1002);

-- 封装有参数的存储过程，可以通过传入部门名和薪资，查询指定部门，并且薪资大于指定值的员工信息
delimiter $$
create procedure proc07(in param_dname varchar(50),in param_sal decimal (7,2))
begin
select * from dept a,emp b where a.deptno=b.deptno and a.dname=param_dname and b.sal > param_sal;
end $$
delimiter ;
call proc07('学工部',20000) ;

-- out 传出
-- 封装有参数的存储过程，传入员工编号，返回员工名字
delimiter $$
create procedure proc08(in in_empno int,out out_ename varchar(50))
begin
 select ename into out_ename from emp where empno = in_empno;
end $$

delimiter ;

call proc08(1001,@o_ename);

select @o_ename;

-- 封装有参数的存储过程，传入员工编号，返回员工名字和薪资
delimiter $$

create procedure proc09(in in_empno int,out out_ename varchar(50),out out_sal decimal(7,2))
begin
 select ename,sal into out_ename, out_sal
	from emp
	 where empno = in_empno;
end $$

delimiter ;

call proc09(1001,@o_ename,@o_sal);

select @o_ename;
select @o_sal;


-- inout 可以内部修改
-- 传入一个数字，乘以10后输出
delimiter $$
create procedure proc10(inout num int)
begin
set num = num*10;
end $$
delimiter ;
set @inout_num =2;
call proc10(@inout_num);
 
 select @inout_num;

-- 传入员工名，拼接部门号，传入薪资，求出年薪
delimiter $$
create procedure proc11(inout inout_ename varchar(50),inout inout_sal int)
begin
select concat_ws('_',deptno,ename) into inout_ename from emp where emp.ename =inout_ename;
set inout_sal=inout_sal * 12;
end $$
delimiter ;

set @inout_ename='关羽';
set @inout_sal =3000;

call proc11(@inout_ename,@inout_sal);

select @inout_ename;
select @inout_sal;

-- if

-- 输入学生的成绩，来判断成绩的级别
delimiter $$
create procedure proc12(in score int)
begin
 if score <60 then select '不及格';
  elseif score >=60 and score <80 then select '及格';
  elseif score >=80 and score <90  then select '良好';
	  elseif score >=90 and score <100 then select '优秀';
 else select '成绩错误';
 end if ;
end $$
delimiter ;

call proc12(55);

-- 输入员工的名字，判断工资的情况。
delimiter $$
create procedure proc13(in in_ename varchar(20))
begin
declare var_sal decimal(7,2);
declare result varchar(20);
 select sal into var_sal from emp where ename =in_ename;
 if var_sal <10000
  then
	 set result ='试用薪资';
	elseif var_sal >=10000 and var_sal <20000
	  then 
		 set result ='转正薪资';
	else
	set result ='元老薪资';	 
 end if;
 select result;
end $$
delimiter ;

call proc13('关羽');

-- case
-- 1
delimiter $$
create procedure proc14(in pay_type int)
begin
case pay_type
when 1 then select '微信支付';
when 2 then select '支付宝支付';
when 3 then select '银行卡支付';
else select '其他方式支付';
end case;
end $$
delimiter ;

call proc14(2);
-- 2
delimiter $$
create procedure proc15(in score int)
begin
case
when score <60 then select '不及格';
  when  score >=60 and score <80 then select '及格';
  when  score >=80 and score <90  then select '良好';
	  when  score >=90 and score <100 then select '优秀';
 else select '成绩错误';
 end case ;
end $$
delimiter ;

call proc15(120);

-- -----循环
create table user(
uid int primary key,
username varchar(50),
password varchar(50)
);

-- while
delimiter $$
create procedure proc16(in insertCount int)
begin
declare i int default 1 ;
  label:while i<= insertCount do
  insert into user(uid,username,password) values (i,concat('user-',i),'123456');
  set i = i + 1;
end while label;
end $$
delimiter ;

call proc16(10);

--    while+leave
truncate table user;
delimiter $$
create procedure proc17(in insertCount int)
begin
declare i int default 1 ;
  label:while i<= insertCount do
  insert into user(uid,username,password) values (i,concat('user-',i),'123456');
	if i = 5 then leave label;
	end if;
	  set i = i + 1;
end while label;
end $$
delimiter ;

call proc17(10);


--    while+iterate
truncate table user;
delimiter $$
create procedure proc18(in insertCount int)
begin
declare i int default 0 ;
  label:while i<= insertCount do
			 set i = i + 1;
		if i = 5 then 
	iterate label;
	end if;
  insert into user(uid,username,password) values (i,concat('user-',i),'123456');
end while label;
end $$
delimiter ;

call proc18(10);

-- repeat
truncate table user;
delimiter $$
create procedure proc19(in insertCount int)
begin
declare i int default 1;
label:repeat
insert into user(uid,username,password)values(i,concat('user-',i),'123456');
set i = i + 1;
until i >insertCount
end repeat label;
select '循环结束';
end $$
delimiter ;

call proc19(100);

-- loop
truncate table user;
delimiter $$
create procedure proc20(in insertCount int)
begin
declare i int default 1;
label:loop
insert into user(uid,username,password)values(i,concat('user-',i),'123456');
set i = i + 1;
if i > 5
then 
leave label;
end if;
end loop label;
select '循环结束';
end $$
delimiter ;

call proc20(10);

-- 游标
delimiter $$
create procedure proc21(in in_dname varchar(50))
begin
-- 定义局部变量
declare var_empno int;
declare var_ename varchar(50);
declare var_sal decimal(7,2);

-- 声明游标
declare my_cursor cursor for
select empno,ename,sal
from dept a,emp b
where a.deptno =b.deptno and a.dname = in_dname;

-- 打开游标
open my_cursor;

-- 通过游标获取值
fetch my_cursor into var_empno,var_ename,var_sal;
select var_empno,var_ename,var_sal;

-- 关闭游标
close my_cursor;

end $$
delimiter ;

call proc21('销售部');

-- 异常处理
delimiter $$
create procedure proc22(in in_dname varchar(50))
begin
-- 定义局部变量
declare var_empno int;
declare var_ename varchar(50);
declare var_sal decimal(7,2);

-- 定义标记值
declare flag int default 1;

-- 声明游标
declare my_cursor cursor for
select empno,ename,sal
from dept a,emp b
where a.deptno =b.deptno and a.dname = in_dname;

-- 定义句柄：定义异常的处理方式
declare continue handler for 1329 set flag =0;

-- 打开游标
open my_cursor;

-- 通过游标获取值
label:loop
fetch my_cursor into var_empno,var_ename,var_sal;
-- 判断flag值为1，则执行，否则不执行
if flag =1 then
select var_empno,var_ename,var_sal;
else
leave label;
end if;
end loop label;
-- 关闭游标
close my_cursor;

end $$
delimiter ;

call proc22('销售部');