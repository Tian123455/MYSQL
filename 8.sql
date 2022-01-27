create database mydb4;
use mydb4;

create table emp(
    emp_id int primary key auto_increment comment '编号',
    emp_name char(20) not null default '' comment '姓名',
    salary decimal(10,2) not null default 0 comment '工资',
    department char(20) not null default '' comment '部门'
);

insert into emp(emp_name,salary,department) 
values('张晶晶',5000,'财务部'),('王飞飞',5800,'财务部'),('赵刚',6200,'财务部'),('刘小贝',5700,'人事部'),
('王大鹏',6700,'人事部'),('张小斐',5200,'人事部'),('刘云云',7500,'销售部'),('刘云鹏',7200,'销售部'),
('刘云鹏',7800,'销售部');
-- 将所有员工的名字合并成一行 
select group_concat(emp_name) from emp;
-- 指定分隔符合并 
select group_concat(emp_name separator ';' ) from emp;
-- 指定排序方式和分隔符 
select department,group_concat(emp_name separator ';' ) from emp group by department;
select department,group_concat(emp_name order by salary desc separator ';' ) from emp group by department;



-- --------------数学函数
select abs(-10);-- 求绝对值
select abs(10);

select ceil(1.1);-- 向上取整

select floor(1.1);-- 向下取整

select greatest (1,2,3);-- 取最大值

select least(1,2,3);-- 取最小值

select mod(5,2);-- 取余数

select power(2,3);-- 取X的Y次方

select floor(rand() * 100);-- 取随机数

select round (3.5415);-- 小数四舍五入
select round (3.5415,3);-- 小数四舍五入取指定小数


-- ------------字符串函数
-- 获取字符串字符个数
select char_length('hello');
select char_length('你好');

select length('hello');-- length 返回的是字节，一个汉字代表三个字节
select length('你好');

-- 字符串的合并
select concat('hello','world');
select concat (c1,c2) from table_name;

-- 指定分隔符进行字符串的合并
select concat_ws('-','hello','world');

-- 返回字符串在列表中第一次出现的位置
select field('aaa','aaa','bbb','ccc');
select field('ccc','aaa','bbb','ccc');

-- 去掉字符串左边空格
select ltrim('     aaa');-- 左
select rtrim('     aaa       ');-- 右
select trim('    aaa      ');-- 两侧

-- 字符串截取
select mid("helloword",2,3);

-- 获取字符串A在B中的位置
select position('abc' in 'habchelloabcword');

-- 替换
select replace ('helloaaaworld','aaa','bbb');

-- 字符串翻转
select reverse('hello');

-- 返回字符串后几个字符
select right ('hello',3);

-- 比较字符串
select strcmp('hello','world');

-- 字符串的截取
select substr('hello',2,3);

-- 小写转大写
select ucase("helloWorld");
select upper("helloWorld");
-- 大写转小写
select lcase("HELLOwORLD");
select lower("HELLOwORLD");


-- -----------日期函数
-- 获取时间段（毫秒值）
select unix_timestamp();

-- 将日期字符串转为毫秒值
select unix_timestamp('2022-1-27 14:14:14');

-- 将毫秒值转为日期值
select from_unixtime(1643264054,'%Y-%m-%d %H:%i:%s');

-- 获取当前年月日
select curdate();
select current_date();

-- 获取当前时分秒
select current_time();
select curtime();

-- 获取年月日和时分秒
select current_timestamp();

-- 从日期字符串中获取年月日
select date('2022-1-27 14:22:30');

-- 获取日期差值
select datediff('2022-1-27','2008-08-08');

-- 计算时间差值
select timediff('12:12:12','14:14:14');

-- 日期格式化
select date_format('2022-1-1 1:1:1','%Y-%m-%d %H-%i-%s');

-- 将字符串转为日期
select str_to_date('2022-01-27','%Y-%m-%d');

-- 将日期减
select date_sub('2022-01-27',interval 2 day);
select date_sub('2022-01-27',interval 2 month);

-- 将日期加
select date_add('2022-01-27',interval 2 day);
select date_add('2022-01-27',interval 2 year);

-- 从日期中获取小时
select extract(hour from '2022-1-27 14:14:14');
select extract(year from '2022-1-27 14:14:14');

-- 获取给定日期所在月的最后一天
select last_day('2022-1-27');

-- 获取指定年份和天数的日期
select makedate('2022',53);

-- 根据日期获取年月日，时分秒
select year('2022-1-27 14:14:14');
select month('2022-1-27 14:14:14');
select minute('2022-1-27 14:14:14');

-- 获取季度
select quarter('2022-1-27 14:14:14');

-- 根据日期获取信息
select monthname('2022-1-27 14:14:14');-- 月份英文
select dayname('2022-1-27 14:14:14');-- 获取周几英文
select dayofmonth('2022-1-27 14:14:14');-- 当月的第几天
select dayofweek('2022-1-27 14:14:14');-- 获取周几，1是周日，2是周一
select dayofyear('2022-1-27 14:14:14');-- 获取一年的第几天
select week('2022-1-27 14:14:14');-- 获取一年的第几周
select weekday('2022-1-27 14:14:14');-- 获取周几，1是周一，2是周二
select weekofyear('2022-1-27 14:14:14');-- 获取本年的第几周

-- 获取当前年月日，时分秒
select now();
