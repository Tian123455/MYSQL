-- 正则表达式
-- ^ 在字符串开始处进行匹配
select 'abc' regexp '^a';
-- $ 在字符串末尾开始匹配
select 'abc' regexp 'a$';
select 'abc' regexp 'c$';
-- . 匹配任意单个字符,可以匹配除了换行符之外的任意字符
select 'abc' regexp '.b';
select 'abc' regexp 'a.';
select 'abc' regexp '.c';
-- [...] 匹配括号内的任意单个字符,是否在前面字符串中出现
select 'abc' regexp '[XYZ]';
select 'abc' regexp '[XaZ]';
-- [^...] 注意^符合只有在[]内才是取反的意思，在别的地方都是表示开始处匹配
select 'a' regexp '[^abc]';
select 'X' regexp '[^abc]';
select 'abc' regexp '[^a]';
-- a* 匹配0个或多个a,包括空字符串。 可以作为占位符使用.有没有指定字符都可以匹配到数据
select 'stab' regexp '.ta*b';
select 'stb' regexp '.ta*b';
select '' regexp 'a*';
-- a+  匹配1个或者多个a,但是不包括空字符
select 'stab' regexp '.ta+b';
select 'stb' regexp '.ta+b';
-- a?  匹配0个或者1个a
select 'stb' regexp '.ta?b';
select 'stab' regexp '.ta?b';
select 'staab' regexp '.ta?b';
-- a1|a2  匹配a1或者a2，
select 'a' regexp 'a|b';
select 'b' regexp 'a|b';
select 'a' regexp '^(a|b)';
select 'b' regexp '^(a|b)';
select 'c' regexp '^(a|b)';
-- a{m} 匹配m个a
select 'auuuuc' regexp 'au{4}c';
select 'auuuuc' regexp 'au{3}c';
-- a{m,n} 匹配m个或者更多的a
select 'auuuuc' regexp 'au{3,}c';
select 'auuuuc' regexp 'au{4,}c';
select 'auuuuc' regexp 'au{5,}c';
-- a{m,n} 匹配m到n个a,包含m和n
select 'auuuuc' regexp 'au{3,5}c';
select 'auuuuc' regexp 'au{4,5}c';
select 'auuuuc' regexp 'au{5,10}c';
-- (abc) abc作为一个序列匹配，不用括号括起来都是用单个字符去匹配，如果要把多个字符作为一个整体去匹配就需要用到括号，所以括号适合上面的所有情况。
select 'xababy' regexp 'x(abab)y';
select 'xababy' regexp 'x(ab)*y';
select 'xababy' regexp 'x(ab){1,2}y';
select 'xababy' regexp 'x(ab){3,4}y';
