-- ----------控制流函数
-- IF
select if (5>3,'大于','小于');
use mydb3;
select *,if (score,'优秀','及格') flag from score;
-- IFNULL
select ifnull(5,0);
select ifnull(NULL,0);
-- ISNULL
select isnull(5);
select isnull(NULL);
-- NULLIF
select nullif(12,12);
select nullif(12,13);

-- case when
select 
 case 5
 when 1 then '你好'
 when 2 then 'hello'
 when 5 then '正确'
 else
    '其他'
		end as info;
		
use mydb4; 
-- 创建订单表
create table orders(
 oid int primary key, -- 订单id
 price double, -- 订单价格
 payType int -- 支付类型(1:微信支付 2:支付宝支付 3:银行卡支付 4：其他)
);

insert into orders values(1,1200,1);
insert into orders values(2,1000,2);
insert into orders values(3,200,3);
insert into orders values(4,3000,1);
insert into orders values(5,1500,2);

-- 方式1
select 
*  ,
case 
  when payType=1 then '微信支付' 
    when payType=2 then '支付宝支付' 
    when payType=3 then '银行卡支付' 
    else '其他支付方式' 
end  as payTypeStr
from orders;
-- 方式2
select 
*  ,
case payType
  when 1 then '微信支付' 
    when 2 then '支付宝支付' 
    when 3 then '银行卡支付' 
    else '其他支付方式' 
end  as payTypeStr
from orders;


-- ------------窗口函数
use mydb4; 
create table employee( 
   dname varchar(20), -- 部门名 
   eid varchar(20), 
   ename varchar(20), 
   hiredate date, -- 入职日期 
   salary double -- 薪资
); 
insert into employee values('研发部','1001','刘备','2021-11-01',3000);
insert into employee values('研发部','1002','关羽','2021-11-02',5000);
insert into employee values('研发部','1003','张飞','2021-11-03',7000);
insert into employee values('研发部','1004','赵云','2021-11-04',7000);
insert into employee values('研发部','1005','马超','2021-11-05',4000);
insert into employee values('研发部','1006','黄忠','2021-11-06',4000);

insert into employee values('销售部','1007','曹操','2021-11-01',2000);
insert into employee values('销售部','1008','许褚','2021-11-02',3000);
insert into employee values('销售部','1009','典韦','2021-11-03',5000);
insert into employee values('销售部','1010','张辽','2021-11-04',6000);
insert into employee values('销售部','1011','徐晃','2021-11-05',9000);
insert into employee values('销售部','1012','曹洪','2021-11-06',6000);

-- 对每个部门的员工按照薪资排序并给出排序
select 
dname,
ename,
salary,
row_number() over (partition by dname order by salary desc) as rn1,
rank() over (partition by dname order by salary desc) as rn2,
dense_rank() over (partition by dname order by salary desc) as rn3
from employee;

-- 求出每个部门薪资排在前三名的员工
select * from
(
select 
dname,
ename,
salary,
dense_rank() over (partition by dname order by salary desc) as rn
from employee
) t
where t.rn <=3;

-- 对所有员工进行全局排序
select
dname,
ename,
salary,
dense_rank() over(order by salary desc) as rn
from employee;


select  
 dname,
 ename,
  hiredate,
 salary,
 sum(salary) over(partition by dname order by hiredate) as c1 
from employee;

select  
dname,
 ename,
  hiredate,
 salary,
sum(salary) over(partition by dname) as c1
from employee;  -- 如果没有order  by排序语句  默认把分组内的所有数据进行sum操作

-- 从头加到尾
select  
 dname,
 ename,
 salary,
 sum(salary) over(partition by dname order by hiredate  rows between unbounded preceding and current row) as c1 
from employee;
--  向上三行加上当前行一起
select  
 dname,
 ename,
 salary,
 sum(salary) over(partition by dname order by hiredate   rows between 3 preceding and current row) as c1 
from employee;

select  
 dname,
 ename,
 salary,
 sum(salary) over(partition by dname order by hiredate   rows between 3 preceding and 1 following) as c1 
from employee;

select  
 dname,
 ename,
 salary,
 sum(salary) over(partition by dname order by hiredate   rows between current row and unbounded following) as c1 
from employee;


-- CUME_DIST
select  
 dname,
 ename,
 salary,
 cume_dist() over(order by salary) as rn1, -- 没有partition语句 所有的数据位于一组
 cume_dist() over(partition by dname order by salary) as rn2 
from employee;


-- PERCENT_RANK
select 
 dname,
 ename,
 salary,
 rank() over(partition by dname order by salary desc ) as rn,
 percent_rank() over(partition by dname order by salary desc ) as rn2
from employee;


-- LAG
select 
 dname,
 ename,
 hiredate,
 salary,
 lag(hiredate,1,'2000-01-01') over(partition by dname order by hiredate) as time1,
 lag(hiredate,2) over(partition by dname order by hiredate) as time2 
from employee;

-- LEAD
select 
 dname,
 ename,
 hiredate,
 salary,
 lead(hiredate,1,'2000-01-01') over(partition by dname order by hiredate) as last_1_time,
 lead(hiredate,2) over(partition by dname order by hiredate) as last_2_time 
from employee;

-- FIRST_VALUE   LAST_VALUE
select
  dname,
  ename,
  hiredate,
  salary,
  first_value(salary) over(partition by dname order by hiredate) as first,
  last_value(salary) over(partition by dname order by  hiredate) as last 
from  employee;
-- 注意,  如果不指定ORDER BY，则进行排序混乱，会出现错误的结果


-- NTH_VALUE
-- 查询每个部门截止目前薪资排在第二和第三的员工信息
select 
  dname,
  ename,
  hiredate,
  salary,
  nth_value(salary,2) over(partition by dname order by hiredate) as second_score,
  nth_value(salary,3) over(partition by dname order by hiredate) as third_score
from employee;


-- NTILE
-- 根据入职日期将每个部门的员工分成3组
select 
  dname,
  ename,
  hiredate,
  salary,
ntile(3) over(partition by dname order by  hiredate  ) as rn 
from employee;
-- 取出每个部门的第一组员工
select 
*
from (
select 
  dname,
  ename,
  hiredate,
  salary,
ntile(3) over(partition by dname order by  hiredate  ) as nt 
from employee
)t
where t.nt = 1;