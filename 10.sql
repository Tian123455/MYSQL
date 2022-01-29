-- ------------创建视图

use mydb6_view;
create or replace view view1_emp
as
select ename,job from emp;
-- 查看表和视图
show tables;
show full tables;

select * from view1_emp;

-- -------------修改视图
alter view view1_emp
as
select a.deptno,a.dname,a.loc,b.ename,b.sal from dept a,emp b where a.deptno=b.deptno;

select * from view1_emp;

-- -------------更新视图
create or replace view view1_emp
as
select ename,job from emp;

select * from view1_emp;

update view1_emp set ename = '周瑜' where ename = '鲁肃';
insert into view1_emp values ('周瑜','文员');
-- ----------视图包含聚合函数不可更新
create or replace view view2_emp
as 
select count(*)  from emp;

select * from view2_emp;

insert into view2_emp values(100);
update view2_emp set cnt = 100;
-- ----------视图包含distinct不可更新
create or replace view view3_emp
as 
select distinct job from emp;

insert into view3_emp values('财务');
-- ----------视图包含goup by 、having不可更新

create or replace view view4_emp
as 
select deptno ,count(*) cnt from emp group by deptno having  cnt > 2;

insert into view4_emp values(30,100);
-- ----------------视图包含union或者union all不可更新
create or replace view view5_emp
as 
select empno,ename from emp where empno <= 1005
union 
select empno,ename from emp where empno > 1005;

insert into view5_emp values(1015,'韦小宝');
-- -------------------视图包含子查询不可更新
create or replace view view6_emp
as 
select empno,ename,sal from emp where sal = (select max(sal) from emp);

insert into view6_emp values(1015,'韦小宝',30000);
-- ----------------------视图包含join不可更新
create or replace view view7_emp
as 
select dname,ename,sal from emp a join  dept b  on a.deptno = b.deptno;

insert into view7_emp(dname,ename,sal) values('行政部','韦小宝',30000);
-- --------------------视图包含常量文字值不可更新
create or replace view view8_emp
as 
select '行政部' dname,'杨过'  ename;

insert into view8_emp values('行政部','韦小宝');

-- ----------------重命名视图
rename table view1_emp to my_view;
-- ------------------删除视图
drop view if exists my_view;


-- ---------------------练习----------------------------------
-- 查询部门平均薪水最高的部门名称
-- --------多表查询
select
	a.deptno,
	a.dname,
	a.loc,
	avg_sal 
from
	dept a,
	(
	select
		* 
	from
		(
		select
			*,
			rank() over ( order by avg_sal desc) rn 
		from
			( select deptno, avg( deptno ) avg_sal from emp group by deptno ) t 
		) tt 
	where
		rn = 1 
	) ttt 
where
	a.deptno = ttt.deptno;
	-- 	----------创建视图
create view test_view1
as
select deptno, avg( deptno ) avg_sal from emp group by deptno
	
    create view test_view2
as
	select
			*,
			rank() over ( order by avg_sal desc) rn 
		from
			test_view1 t 
	
create view test_view3
as
select
		* 
	from
		test_view2 tt 
	where
		rn = 1 	
	
	select * from test_view3;
-- 	-----优化
	select
	a.deptno,
	a.dname,
	a.loc,
	avg_sal 
from
	dept a,
	test_view3 ttt 
where
	a.deptno = ttt.deptno;
	
	
	
	-- 查询员工比所属领导薪资高的部门名、员工名、员工领导编号
create view emp_view1	
as
select
	a.ename ename,
	a.sal esal,
	b.ename mgrname,
	b.sal msal,
	a.deptno 
from
	emp a,
	emp b 
where
	a.mgr = b.empno 
	and a.sal > b.sal;

select * from dept a join emp_view1 b on a.deptno = b.deptno;
	
-- 查询工资等级为4级，2000年以后入职的工作地点为上海的员工编号、姓名和工资，并查询出薪资在前三名的员工信息
create view emp_view2
as
select
	a.deptno,
	a.dname,
	a.loc,
	b.empno,
	b.ename,
	b.sal,
	c.grade
from
	dept a
	join emp b on a.deptno = b.deptno and year(hiredate) >'2000' and a.loc='上海'
	join salgrade c on grade = 4 and b.sal between c.losal and c.hisal;

select
*
from
(
select 
*,
rank() over(order by sal desc) rn
from 
emp_view2
)t
where rn <=3;
