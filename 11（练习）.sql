use mydb7_procedure;
drop procedure if exists proc22_demo;
delimiter $$
create procedure proc22_demo()
begin
    declare next_year int;-- 下一个月的年份
    declare next_month int;-- 下一个月的月份
    declare next_month_day int;-- 下一个月的最后一天日期
        
    declare next_month_str char(2);-- 下一个月月份字符串
    declare next_month_day_str char(2);-- 下一个月的日字符串
    
    -- 处理每天的表名
    declare table_name_str char(10);
    
    declare t_index int default 1;-- 月份是否大于10
    -- declare create_table_sql varchar(200);
    -- 获取下个月的年份
    set next_year = year(date_add(now(),INTERVAL 1 month));
    -- 获取下个月是几月 
    set next_month = month(date_add(now(),INTERVAL 1 month));
    -- 下个月最后一天是几号
    set next_month_day = dayofmonth(LAST_DAY(date_add(now(),INTERVAL 1 month)));
    
    if next_month < 10
        then set next_month_str = concat('0',next_month);-- 变成01，02.....
    else
        set next_month_str = concat('',next_month);
    end if;
    
    
    while t_index <= next_month_day do
        
        if (t_index < 10)
            then set next_month_day_str = concat('0',t_index);
        else
            set next_month_day_str = concat('',t_index);
        end if;
-- 2021_11_01
        set table_name_str = concat(next_year,'_',next_month_str,'_',next_month_day_str);
        -- 拼接create sql语句
        set @create_table_sql = concat(
                    'create table user_',
                    table_name_str,
                    '(`uid` INT ,`uname` varchar(50) ,`information`   varchar(50))COLLATE=\'utf8_general_ci\' ENGINE=InnoDB');
        -- FROM后面不能使用局部变量！
        prepare create_table_stmt FROM @create_table_sql;
        execute create_table_stmt;
        DEALLOCATE prepare create_table_stmt;
        
        set t_index = t_index + 1;
        
    end while;  
end $$
delimiter ;

call proc22_demo();
