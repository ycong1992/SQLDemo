/**
 sqlite3 总体来说使用比较麻烦，平时开发更多的是使用第三方框架FMDB
 FMDB是基于SQLite使用OC语法封装的数据库框架，它的优点如下:
 1）语法更加面向对象
 2）相对于CoreData框架，更加轻量级和灵活
 3）提供了多线程安全的数据库操作方法，可以有效地防止数据混乱
 主要类：
 FMDatabase：一个FMDatabase对象就代表一个单独的SQLite数据库
 FMResultSet：使用FMDatabase执行查询后的结果集
 FMDatabaseQueue：用于在多线程中执行多个查询或更新，它是线程安全的
 基本流程：设置数据库名称、创建表、添加数据、删除数据、修改数据、查询数据
 */
