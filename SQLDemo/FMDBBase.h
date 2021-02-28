/**
 sqlite3总体来说使用比较麻烦，平时开发更多的是使用第三方框架FMDB
 FMDB是基于SQLite使用OC语法封装的数据库框架，它的优点如下:
 1）语法更加面向对象
 2）相对于CoreData框架，更加轻量级和灵活
 3）提供了多线程安全的数据库操作方法，可以有效地防止数据混乱
 主要类：
 FMDatabase：一个FMDatabase对象就代表一个单独的SQLite数据库，用来执行SQL语句
 FMResultSet：使用FMDatabase执行查询后的结果集
 FMDatabaseQueue：用于在多线程中执行多个查询或更新，它是线程安全的
 
 基本流程：打开数据库、执行更新、执行查询
 备注：在FMDB中，除查询以外的所有操作，都称为更新，如create、drop、insert、update、delete等
 
 在多个线程中同时使用一个FMDatabase实例，会造成数据混乱等问题。为了保证线程安全，FMDB提供方便快捷的FMDatabaseQueue类
 */
