/**
 数据库查看软件：DB Browser for SQLite https://sqlitebrowser.org/dl/
 数据库(Database)是按照数据结构来组织、存储和管理数据的仓库
 数据库可以分为2大种类：关系型数据库(主流如SQLite)、对象型数据库
 SQLite是一款轻型的嵌入式数据库：1）它占用资源非常的低，在嵌入式设备中，可能只需要几百K的内存就够了；2）它的处理速度比Mysql、PostgreSQL这两款著名的数据库都还快
 数据库是如何存储数据的？数据库的存储结构和excel很像，以表(table)为单位
 步骤：1）新建数据库文件；2）新建一张表；3）添加多个字段(column/列，属性)；4）添加多行记录(row/行，每行存放多个字段对应的值)
 
 【SQL(structured query language)】结构化查询语言，是一种对关系型数据库中的数据进行定义和操作(增删改查，CRUD)的语言
 备注：增加(Create)、检索(Retrieve)、更新(Update)、删除(Delete)
 SQL语句的种类：
 1）数据定义语句(DDL，Data Definition Language)
 包括create和drop等操作(在数据库中创建新表create table或删除表drop table)
 2）数据操作语句(DML，Data Manipulation Language)
 包括insert、update、delete等操作(添加、修改、删除表中的数据)
 3）数据查询语句(DQL，Data Query Language)
 可以用于查询获得表中的数据(关键字select是DQL用得最多的操作，其他DQL常用的关键字有where、order by、group by、having)
 统计(个数/平均值/求和/最大、小值)、排序(升、降序)、limit分页(控制查询条数)
 https://www.xp.cn/e/sql/sql_intro.html
 
 【SQL语法】
 创表：create table if not exists 表名 (字段名1 字段类型1, 字段名2 字段类型2, ...);
 删表：drop table if exists 表名;
 插入数据：insert into 表名 (字段1, 字段2, ...) values (字段1的值, 字段2的值, ...);
 更新数据：update 表名 set 字段1 = 字段1的值, 字段2 = 字段2的值, ...;
 删除数据：delete from 表名;
 备注：1）字段类型：integer整型值、real浮点值、text文本字符串、blob二进制数据；2）数据库中的字符串内容应该用单引号括住
 条件语句：如果只想更新或者删除某些固定的记录，那就必须在DML语句后加上一些条件，如下
 where字段=某个值; 或 where字段is某个值;
 where字段!=某个值; 或 where字段is not某个值;
 where字段>某个值;
 where字段1=某个值and字段2>某个值;  // and相当于C语言中的&&
 where字段1=某个值or字段2=某个值;  // or相当于C语言中的||
 查询部分字段：select 字段1, 字段2, ... from 表名;
 查询所有字段：select * from 表名;
 起别名：字段和表都可以起别名，如下
 select 字段1 别名, 字段2 别名, ...from 表名 别名;
 select 字段1 别名, 字段2 as 别名, ...from 表名 as 别名;
 select 别名.字段1, 别名.字段2, ... from 表名 别名;
 计算记录的数量：select count (字段) from 表名 ; 或 select count (*) from 表名;
 排序，查询出来的结果可以用order by进行排序：select * from t_student order by 字段;
 默认是按照升序排序(由小到大)，也可以变为降序(由大到小)，如：
 select * from t_student order by age desc ; //降序
 select * from t_student order by age asc ; // 升序(默认)
 也可以用多个字段进行排序，如：
 select * from t_student order by age asc, height desc;(先按照年龄升序排序，年龄相等就按照身高降序排序)
 limit：使用limit可以精确地控制查询结果的数量，比如每次只查询10条数据，select * from 表名 limit 数值1, 数值2;
 
 简单约束，建表时可以给特定的字段设置一些约束条件，以保证数据的规范性，常⻅的约束有：
 1）not null：规定字段的值不能为null；2）unique：规定字段的值必须唯一；3）default：指定字段的默认值
 主键(Primary Key，简称PK)用来唯一地标识某一条记录(可以是一个字段或多个字段)
 主键的声明：在创表的时候用primary key声明一个主键(如果想要让主键(integer类型)自动增⻓，应该增加autoincrement)
 主键的设计原则：1）主键应当是对用户没有意义的；2）永远也不要更新主键；3）主键不应包含动态变化的数据；4）主键应当由计算机自动生成
 外键：如果表A的主关键字是表B中的字段，则该字段称为表B的外键
 外键约束：利用外键约束可以用来建立表与表之间的联系(外键的一般情况是一张表的某个字段，引用着另一张表的主键字段)
 
 多表设计案例：微博APP如何保存用户的名称、头像、发的微博等
 两张表，一张用户表保存用户基本信息，一张微博表保存用户微博信息。微博表通过外键关联用户表(如用户表的主键为id，微博表中的外键字段为user_id，user_id关联用户表的id)
 实际应用中：外键存在时，数据库需要维护外键的内部管理，如增、删、更新后触发的相关操作，所以出于性能和后期维护考虑，一般不使用外键，而是在业务层进行处理和限制
 
 表连接查询：需要联合多张表才能查到想要的数据
 表连接的类型：
 left join(左连接/左外连接)：返回包括左表中的所有记录和右表中连接字段相等的记录(以左表为主，将右表中相同字段的数据匹配过来)
 right join(右连接/右外连接)：返回包括右表中的所有记录和左表中连接字段相等的记录(以右表为主，将左表中相同字段的数据匹配过来)
 inner join(内连接/等值连接)：只返回两个表中连接字段相等的行(取交集)
 full join(全连接/全外连接)：返回左右表中所有的记录和左右表中连接字段相等的记录(并集)
 A表
 id  name
 1    小王
 2    小李
 3    小刘
 B表
 id    A_id    job
 1      2      老师
 2      4      程序员
 左连接：select a.name,b.job from A a  left join B b on a.id=b.A_id
 小王    null
 小李    老师
 小刘    null
 右连接：select a.name,b.job from A a  right join B b on a.id=b.A_id
 小李    老师
 null   程序员
 内连接：select a.name,b.job from A a  inner join B b on a.id=b.A_id
 小李    老师
 全连接：select a.name,b.job from A a  full join B b on a.id=b.A_id
 小王    null
 小李    老师
 小刘    null
 null   程序员
  
 事务(Transaction)：是并发控制的单位，是用户定义的一个操作序列。这些操作要么都做，要么都不做，是一个不可分割的工作单位。通过事务，可以将逻辑相关的一组操作绑定在一起，保持数据的完整性
 事务与非事务：简单的举例来说就是，事务就是把所有的东西打包在一起，一次性处理它，而非事务就是一条一条的来执行并且处理

 【SQLite3】在iOS中使用SQLite3，首先要添加库文件libsqlite3.dylib和导入主头文件
 一般流程：1）创建/打开数据库；2）创建表；3）增删改查；4）删除表；5）关闭数据库
 sqlite3_open：根据文件路径打开数据库，如果不存在，则会创建一个新的数据库
 sqlite3_exec：执行任何SQL语句，比如创表、更新、插入和删除操作。但是一般不用它执行查询语句，因为它不会返回查询到的数据(查询一般使用stmt)
 
 更新SQL的函数(创表、更新、插入和删除)：
 1）sqlite3_exec实际上是将编译，执行进行了封装，等价于sqlite3_prepare_v2()、sqlite3_step()和sqlite3_finalize()
 2）sqlite3_stmt机制操作：
 <1>指令准备：sqlite3_prepare_v2会对sql语句(模板)进行解析和编译，生成一个准备语句对象
 <2>变量绑定：sqlite3_bind_xxx可以将变量绑定到准备语句对象中
 <3>语句执行：sqlite3_step执行准备语句对象的SQL语句(执行完后可以使用sqlite3_reset重置，回退到<2>重新赋值执行)
 <4>结果获取：sqlite3_column_xxx根据不同的数据类型使用不同的方法
 <5>关闭数据库：sqlite3_prepare_v2需要使用sqlite3_finalize进行关闭
 3）单条命令使用sqlite3_exec和sqlite3_stmt效率是一样的；但是在涉及到批量操作时，推荐使用sqlite3_stmt机制(一次编译，多次执行)
 
 一次性插入大批量数据的优化方案：sqlite3_exec或sqlite3_step执行sql语句时会自动开启一个“事务”，然后自动提交“事务”，当插入多条数据时就会很耗费时间。此时应该优化插入语句(准备语句)并手动开启事务和手动提交事务
 */
