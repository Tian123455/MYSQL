-- DQL操作
-- 创建新数据库
create database if not exists mydb2;
use mydb2;
-- 创建商品表
create table product(
pid int primary key auto_increment,-- 商品编号
pname varchar(20),-- 商品名字
price double,-- 商品价格
category_id varchar(20)-- 商品所属分类
);
-- 添加数据
insert into product values(null,'海尔洗衣机',5000,'c001');
insert into product values(null,'美的冰箱',3000,'c001');
insert into product values(null,'格力空调',5000,'c001');
insert into product values(null,'九阳 电饭煲',5000,'c001');

insert into product values(null,'啄木鸟衬衣',300,'c002');
insert into product values(null,'恒源祥西裤',800,'c002');
insert into product values(null,'花花公子夹克',440,'c002');
insert into product values(null,'劲霸休闲裤',266,'c002');
insert into product values(null,'海澜之家卫衣',180,'c002');
insert into product values(null,'杰克琼斯运动裤',430,'c002');

insert into product values(null,'兰蔻面霜',300,'c003');
insert into product values(null,'雅诗兰黛精华水',200,'c003');
insert into product values(null,'香奈儿香水',350,'c003');
insert into product values(null,'SK-II神仙水',350,'c003');
insert into product values(null,'资生堂粉底液',180,'c003');

insert into product values(null,'老北京方便面',56,'c004');
insert into product values(null,'良品铺子海带丝',17,'c004');
insert into product values(null,'三只松鼠坚果',88,null);


-- 简单查询
-- 1.查询所有的商品.  
select  pid,pname,price,category_id from product;
select * from product;
-- 2.查询商品名和商品价格. 
select pname,price from product;
-- 3.别名查询.使用的关键字是as（as可以省略的）.  
-- 3.1表别名: 
select *from as p;
select *from p;

select product.id ,user.id from poduct,user;-- 多表查询
-- 3.2列别名：
select pname as '商品名',price '商品价格' from product;
-- 4.去掉重复值.  
select  distinct price from product;
select  distinct * from product;
-- 5.查询结果是表达式（运算查询）：将所有商品的价格+10元进行显示.
select pname,price +10 as new_price from product;



-- 运算符操作
use mydb2;
-- 算术运算符
select 6 + 2;
select 6 - 2;
select 6 * 2;
select 6 / 2;
select 6 % 2;
-- 将所有商品的价格加10元
select pname ,price + 10 as new_price1 from product;
-- 将所有商品价格上调10%
select pname ,price * 1.1 as new_price2 from product;

-- 运算符操作-条件查询
-- 查询商品名称为“海尔洗衣机”的商品所有信息：
select * from product where pname ='海尔洗衣机';
-- 查询价格为800商品
select * from product where price = 800;
-- 查询价格不是800的所有商品 
select * from product where price != 800;
select * from product where price <> 800;
select * from product where not( price = 800);
-- 查询商品价格大于60元的所有商品信息 
select * from product where price > 60;
-- 查询商品价格在200到1000之间所有商品
select * from product where price between 200 and 1000 ;
select * from product where price >= 200 and price <=1000;
-- 查询商品价格是200或800的所有商品
select * from product where price = 200 or price = 800;
select * from product where price in (200,800);
-- 查询含有‘裤'字的所有商品
select * from product where pname like '%裤%';-- %用来匹配任意字符
-- 查询以'海'开头的所有商品
select * from product where pname like '海%';
-- 查询第二个字为'蔻'的所有商品
select * from product where pname like '_蔻%';
-- 查询category_id为null的商品
select * from product where category_id is null;
-- 查询category_id不为null分类的商品
select * from product where category_id is not null;
-- 使用least求最小值
select least (10,5,20) as small_number;
select least (10,null,20) as small_number;
-- 如果求最小值时，有个值为null，则不会进行比较，直接为null
-- 使用greatest求最大值
select greatest (10,20,30) as big_number;
select greatest (10,null,30) as big_number;
-- 如果求最大值时，有个值为null，则不会进行比较，直接为null


-- 排序查询
-- 1.使用价格排序(降序)
select * from product order by price desc;
-- 2.在价格排序(降序)的基础上，以分类排序(降序)
select * from product order by price desc, category_id desc;
-- 3.显示商品的价格(去重复)，并排序(降序)
select distinct price from product order by price desc;


-- 聚合查询
-- 1 查询商品的总条数
select count(pid) from product;
select count(*) from product;
-- 2 查询价格大于200商品的总条数
select count(pid) from product where price >200;
-- 3 查询分类为'c001'的所有商品的总和
select sum(price) from product where category_id ='c001';
-- 4 查询商品的最大价格
select max(price) from product ;
-- 5 查询商品的最小价格
select min(price) from product ;
select max(price),min(price) from product ;
-- 6 查询分类为'c002'所有商品的平均价格
select avg(price) from product where category_id ='c002';


-- 分组查询
-- select 字段1,字段2… from 表名 group by 分组字段 having 分组条件;
-- 1 统计各个分类商品的个数
select category_id,count(*) from product group by category_id;
-- 2.统计各个分类商品的个数,且只显示个数大于4的信息
select category_id,count(*) from product group by category_id 
 having count(*) >4 order by count(*);


-- 分页查询
-- 查询product表的前5条记录 
select * from product limit 5;
-- 从第4条开始显示，显示5条 
select * from product limit 0,5;
select * from product limit 5,5;
select * from product limit 10,5;
select * from product limit 15,5;


use mydb2;
select (*) from product;
-- INSERT INTO SELECT
create table product2(
pname varchar(20),
price double
);

insert into product2(pname,price) select pname,price from product;
select * from product2;

create table product3(
category_id varchar(20),
product_count int
);

insert into product3 select category_id,count(*) from product group by category_id;

select * from product3;








-- ******************************************************练习巩固**************************************************************
use mydb2;
create table student(
id int,
name varchar(20),
gender varchar(20),
chinese int,
english int,
math int
);
insert into student(id ,name,gender,chinese,english,math) values(1,'张明','男',89,78,90);
insert into student(id,name,gender,chinese,english,math) values(2,'李进','男',67,53,95);
insert into student(id,name,gender,chinese,english,math) values(3,'王五','女',87,78,77);
insert into student(id,name,gender,chinese,english,math) values(4,'李一','女',88,98,92);
insert into student(id,name,gender,chinese,english,math) values(5,'李财','男',82,84,67);
insert into student(id,name,gender,chinese,english,math) values(6,'张宝','男',55,85,45);
insert into student(id,name,gender,chinese,english,math) values(7,'黄蓉','女',75,65,30);
insert into student(id,name,gender,chinese,english,math) values(7,'黄蓉','女',75,65,30);

-- 查询表中所有学生的信息
select * from student;
-- 查询表中所有学生的姓名和对应的英语成绩
select name,english from student;
-- 过滤表中重复的部分
select distinct * from student;
-- 统计每个学生的总分
select  name ,chinese + english + math as total_score from student;
-- 在所有学生总分数上加10分的特产分
select name,chinese + english + math + 10 as finally_score from student;
-- 使用别名表示学生分数
select name,chinese '语文成绩' ,english '英语成绩' ,math'数学成绩' from student;
-- 查询英语成绩大于90分的同学
select * from student where english >90;
-- 查询总分大于200分的同学
select * from student where chinese + english + math >200;
-- 查询英语成绩在80-90之间的同学
select * from student where english  >=80 and english <= 90;
select * from student where english between 80 and 90;
-- 查询英语成绩不在80-90之间的同学
select * from student where not english  >=80 and english <= 90;
select * from student where not english between 80 and 90;
-- 查询数学成绩为89，90，91的同学
select *from student where math in(89,90,91);
-- 查询数学成绩不为89，90，91的同学
select *from student where math not in(89,90,91);
-- 查询所有姓李的学生英语成绩
select name,english from student where name like '李%';
-- 查询数学为80并且语文为80的同学
select *from student where math =80 and chinese =80;
-- 查询英语为80或者总分为200的同学
select *from student where english =80 and chinese + english +math =200;
-- 对数学成绩降序排序后输出
select *from student order by math desc;
-- 对总分排序后输出，然后再按从高到低的顺序输出
select *from student order by chinese+ english +math desc;
-- 对姓李的同学成绩排序输出
select *from student where name like '李%' order by chinese + English + math desc;
-- 查询男生女生分别有多少人，并将人数降序排序输出,挑出人数大于4的性别人数信息
select 
	gender,count(*)
as 
	total_cnt
from
	student 
group by 
	gender 
having 
	total_cnt 
order by 
	total_cnt desc;
