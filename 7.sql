use mydb3;
create table if not exists dept3(
  deptno varchar(20) primary key ,  -- 部门号
  name varchar(20) -- 部门名字
);
create table if not exists emp3 (
  eid varchar(20) primary key, -- 员工编号
  ename varchar(20), -- 员工名字
  age int,  -- 员工年龄
  dept_id varchar(20)  -- 员工所属部门
);

insert into dept3 values('1001','研发部');
insert into dept3 values('1002','销售部');
insert into dept3 values('1003','财务部');
insert into dept3 values('1004','人事部');

insert into emp3 values('1','乔峰',20, '1001');
insert into emp3 values('2','段誉',21, '1001');
insert into emp3 values('3','虚竹',23, '1001');
insert into emp3 values('4','阿紫',18, '1001');
insert into emp3 values('5','扫地僧',85, '1002');
insert into emp3 values('6','李秋水',33, '1002');
insert into emp3 values('7','鸠摩智',50, '1002'); 
insert into emp3 values('8','天山童姥',60, '1003');
insert into emp3 values('9','慕容博',58, '1003');
insert into emp3 values('10','丁春秋',71, '1005');

-- 交叉连接查询
select * from dept3,emp3;
-- 内连接查询
-- 查询所有部门的成员
select * from dept3,emp3 where deptno = dept_id;
select * from dept3 inner join emp3 on dept3.deptno =emp3.dept_id; 
-- 查询研发部门的所属成员
select * from dept3 inner join emp3 on dept3.deptno =emp3.dept_id and name ='研发部'; 
-- 查询研发部和销售部的所属员工
select * from dept3 inner join emp3 on dept3.deptno =emp3.dept_id and (name ='研发部' or name ='销售部'); 
select * from dept3 inner join emp3 on dept3.deptno =emp3.dept_id and name in ('研发部','销售部'); 
-- 查询每个部门的员工数,并升序排序
select a.name,a.deptno,count(1) from dept3 a join emp3 b on a.deptno =b.dept_id
 group by a.deptno;
-- 查询人数大于等于3的部门，并按照人数降序排序
select a.name,a.deptno,count(1) as total_cnt
from dept3 a join emp3 b on a.deptno=b.dept_id 
group by a.deptno,a.name 
having total_cnt >=3
order by total_cnt desc;

-- 外连接查询
use mydb3;
-- 左外连接
-- 查询哪些部门有员工，哪些部门没有员工
select * from dept3 a left outer join emp3 b on a.deptno=b.dept_id;
-- 右外连接
-- 查询哪些员工有对应的部门，哪些没有
select * from dept3 a right outer join emp3 b on a.deptno=b.dept_id;
-- 满外连接
-- 使用union关键字实现左外连接和右外连接的并集,并去重
select * from dept3 a left outer join emp3 b on a.deptno=b.dept_id 
union
select * from dept3 a right outer join emp3 b on a.deptno=b.dept_id;


-- 子查询
-- 查询年龄最大的员工信息，显示信息包含员工号、员工名字，员工年龄
select max(age) from emp3;
select * from emp3 where age=(select max(age) from emp3);
-- 查询年研发部和销售部的员工信息，包含员工号、员工名字
select *from dept3 a join emp3 b on a.deptno=b.dept_id and name in('研发部','销售部');

select deptno from dept3 where  name in('研发部','销售部');
select * from emp3 where dept_id in('1001','1002');
-- 查询研发部20岁以下的员工信息,包括员工号、员工名字，部门名字
select *from dept3 a join emp3 b on a.deptno=b.dept_id and (name ='研发部'and age <20);

select * from dept3 where name ='研发部';
select * from emp3 where (dept_id ='1001'and age <20);

select * from (select * from dept3 where name ='研发部') t1 join(select * from emp3 where age <40) t2 on deptno = dept_id;

-- ALL
-- 查询年龄大于‘1003’部门所有年龄的员工信息
select * from emp3 where age > all(select age from emp3 where dept_id ='1003');
-- 查询不属于任何一个部门的员工信息
select * from emp3 where dept_id != all(select deptno from dept3);

-- ANY,SOME
-- 查询年龄大于‘1003’部门任意一个员工年龄的员工信息
select * from emp3 where age >any(select age from emp3 where dept_id='1003') and dept_id !='1003';
select * from emp3 where age >some(select age from emp3 where dept_id='1003') and dept_id !='1003';

-- IN
-- 查询研发部和销售部的员工信息，包含员工号、员工名字
select eid,ename from emp3 where dept_id in (select deptno from dept3 where name in('研发部','销售部'));

-- EXISTS
-- 查询公司是否有大于60岁的员工，有则输出
select * from emp3 a where exists (select * from emp3 b where a.age >60);
select * from emp3 a where eid in (select eid from emp3 b where a.age >60);
-- 查询有所属部门的员工信息
select * from emp3 a where exists (select * from dept3 b where b.deptno =a.dept_id);
select * from emp3 a where dept_id in (select deptno from dept3 b where b.deptno =a.dept_id);

-- 自关联查询
create table if not exists t_sanguo(
    eid int primary key ,
    ename varchar(20),
    manager_id int,-- 外键列
 foreign key (manager_id) references t_sanguo (eid)  -- 添加自关联约束
);
-- 添加数据 
insert into t_sanguo values(1,'刘协',NULL);
insert into t_sanguo values(2,'刘备',1);
insert into t_sanguo values(3,'关羽',2);
insert into t_sanguo values(4,'张飞',2);
insert into t_sanguo values(5,'曹操',1);
insert into t_sanguo values(6,'许褚',5);
insert into t_sanguo values(7,'典韦',5);
insert into t_sanguo values(8,'孙权',1);
insert into t_sanguo values(9,'周瑜',8);
insert into t_sanguo values(10,'鲁肃',8);

-- 进行关联查询
-- 查询每个三国人物及他的上级信息，如:  关羽  刘备 
select * from t_sanguo a, t_sanguo b where a.manager_id = b.eid;
select a.ename,b.ename from t_sanguo a, t_sanguo b where a.manager_id = b.eid;
select a.ename,b.ename from t_sanguo a join t_sanguo b on a.manager_id = b.eid;
-- 查询所有人物及上级
select a.ename,b.ename from t_sanguo a left join t_sanguo b on a.manager_id = b.eid;
-- 查询所有人物的上级及上上级
select a.ename,b.ename,c.ename from t_sanguo a 
left join t_sanguo b on a.manager_id = b.eid
left join t_sanguo c on b.manager_id = c.eid;

