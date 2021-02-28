/**
 数据库查看软件：DB Browser for SQLite https://sqlitebrowser.org/dl/
 数据库(Database)是按照数据结构来组织、存储和管理数据的仓库
 数据库可以分为2大种类：关系型数据库(主流如SQLite)、对象型数据库
 SQLite是一款轻型的嵌入式数据库：1）它占用资源非常的低，在嵌入式设备中，可能只需要几百K的内存就够了；2）它的处理速度比Mysql、PostgreSQL这两款著名的数据库都还快
 数据库是如何存储数据的？数据库的存储结构和excel很像，以表(table)为单位
 
 SQL(structured query language)：结构化查询语言，是一种对关系型数据库中的数据进行定义和操作(增删改查，CRUD)的语言
 备注：增加(Create)、检索(Retrieve)、更新(Update)、删除(Delete)
 SQL语句的种类：
 1）数据定义语句(DDL:Data Definition Language)
 包括create和drop等操作(在数据库中创建新表create table或删除表drop table)
 2）数据操作语句(DML:Data Manipulation Language)
 包括insert、update、delete等操作(添加、修改、删除表中的数据)
 3）数据查询语句(DQL:Data Query Language)
 可以用于查询获得表中的数据(关键字select是DQL用得最多的操作，其他DQL常用的关键字有where、order by、group by、having)
 统计(个数/平均值/求和/最大、小值)、排序(升、降序)、limit分页(控制查询条数)
 https://www.xp.cn/e/sql/sql_intro.html
 
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
 
 一般流程：1）创建/打开数据库；2）创建表；3）增删改查；4）删除表；5）关闭数据库
 
 事务(Transaction)：是并发控制的单位，是用户定义的一个操作序列。这些操作要么都做，要么都不做，是一个不可分割的工作单位。通过事务，可以将逻辑相关的一组操作绑定在一起，保持数据的完整性
 事务与非事务，简单的举例来说就是，事务就是把所有的东西打包在一起，一次性处理它。而非事务就是一条一条的来执行并且处理。

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
 
 
 备注：Core Data是针对SQLite3的封装，本质还是要转换成对应的SQL语句去执行
 */
