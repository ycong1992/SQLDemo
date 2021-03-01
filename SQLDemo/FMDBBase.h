/**
 sqlite3总体来说使用比较麻烦，平时开发更多的是使用第三方框架FMDB
 FMDB是基于SQLite使用OC语法封装的数据库框架，它的优点如下:
 1）语法更加面向对象
 2）相对于CoreData框架，更加轻量级和灵活
 3）提供了多线程安全的数据库操作方法，可以有效地防止数据混乱
 缺点：只能在iOS平台上使用；需要写SQL语句
 主要类：
 FMDatabase：一个FMDatabase对象就代表一个单独的SQLite数据库，用来执行SQL语句
 FMResultSet：使用FMDatabase执行查询后的结果集
 FMDatabaseQueue：用于在多线程中执行多个查询或更新，它是线程安全的
 
 基本流程：打开数据库、执行更新、执行查询、关闭数据库
 备注：在FMDB中，除查询以外的所有操作，都称为更新，如create、drop、insert、update、delete等
 
 在多个线程中同时使用一个FMDatabase实例，会造成数据混乱等问题。为了保证线程安全，FMDB提供方便快捷的FMDatabaseQueue类(实际项目中建议都使用FMDatabaseQueue)
 常用操作方法：
 inDatabase：1）开启一个同步串行队列；2）获取db对象，如果没有打开数据库，则执行open操作；3）把db对象通过block传给调用方执行相应操作
 inTransaction：1）开启同步串行队列；2）根据事务的type执行对应的事务开启；3）把db对象和&rollback通过blcok传给调用方；4）根据rollback状态，如果rollback为YES，则执行db的"rollback transaction"，否的话执行"commit transaction"正常提交
 */
