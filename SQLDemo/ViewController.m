/**
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
 https://sqlitebrowser.org/dl/
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
 sqlite3_exec实际上是将编译，执行进行了封装，等价于sqlite3_prepare_v2()、sqlite3_step()和sqlite3_finalize()，所以对于批量的更新、查询语句sqlite3_prepare方式更高效，因为只需要编译一次，就可以重复执行N次
 sqlite3_prepare_v2()：将sql文本转换成一个准备语句对象，同时返回这个对象的指针(仅仅为执行准备这个sql语句)
 
 一次性插入大批量数据的优化方案：使用sqlite3_exec或sqlite3_step()来执行sql语句，会自动开启一个“事务”，然后自动提交“事务”。当插入多条数据时会很耗费时间，此时应该优化插入语句(准备语句)并手动开启事务和手动提交事务
 
 
 备注：Core Data是针对SQLite3的封装，本质还是要转换成对应的SQL语句去执行
 */

/**
 数据库查看软件：DB Browser for SQLite
 
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

#import "ViewController.h"
#import "Person.h"
#import <sqlite3.h>
#import <FMDB.h>

@interface ViewController ()

@property (assign, nonatomic) sqlite3 *sqlite3 ;

@property (strong, nonatomic) NSMutableArray *sqlArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** sqlite3操作 */
//    _sqlite3 = NULL;
//    // 操作数据库之前必须先指定数据库文件和要操作的表，所以使用`SQLite3`，首先要打开数据库文件，然后指定或创建一张表
//    [self openDatabase];
//    // 使用 `sqlite3_exec()` 方法可以执行任何`SQL`语句，比如`创表、更新、插入和删除`操作。但是一般不用它执行查询语句，因为它不会返回查询到的数据
////    [self insertData];
//    [self readData];
    
    /** FMDB操作 */
//    [self openFMDB];
//    [self openFMDBMultithreading]; // 多线程FMDatabaseQueue
    
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.data"];
    Person *person = [[Person alloc] init];
    person.name = @"yyyyyyy";
    person.age = 999;
    [NSKeyedArchiver archiveRootObject:person toFile:file];
    
    Person *person2 = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    if (person2) {
        NSLog(@"unarchiveObjectWithFile:%@, %ld", person2.name, (long)person2.age);
    }
}

- (void)openDatabase {
    // 设置数据库文件名
    NSString *filename = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.db"];
    // 打开数据库文件，如果没有会自动创建一个文件
    NSInteger result = sqlite3_open(filename.UTF8String, &_sqlite3);
   
    if (result == SQLITE_OK) { // 打开数据库成功
        // 创建一个数据库表
        char *errmsg = NULL;
        sqlite3_exec(_sqlite3, "CREATE TABLE IF NOT EXISTS t_person(id integer primary key autoincrement, name text, age integer)", NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"sqlite3_exec error：%s", errmsg);
        } else {
            NSLog(@"sqlite3_exec success");
        }
    } else {
        NSLog(@"Open DB fail");
    }
}

- (void)insertData {
    NSString *nameStr;
    NSInteger age;

    for (NSInteger i = 0; i < 1000; i++) {
        nameStr = [NSString stringWithFormat:@"Bourne-%d", arc4random_uniform(10000)];
        age = arc4random_uniform(80) + 20;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_person (name, age) VALUES('%@', '%ld')", nameStr, age];
        char *errmsg = NULL;
        sqlite3_exec(_sqlite3, sql.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"sqlite3_exec insert error：%s", errmsg);
        }
    }
}

/**
 sqlite3_prepare_v2() : 检查sql的合法性
 sqlite3_step() : 逐行获取查询结果，不断重复，直到最后一条记录
 qlite3_coloum_xxx() : 获取对应类型的内容，iCol对应的就是SQL语句中字段的顺序，从0开始。根据实际查询字段的属性，使用sqlite3_column_xxx取得对应的内容即可。
 sqlite3_finalize() : 释放stmt
 */
- (void)readData
{
   NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1000];
   char *sql = "select name, age from t_person;";
   sqlite3_stmt *stmt;
   NSInteger result = sqlite3_prepare_v2(_sqlite3, sql, -1, &stmt, NULL);
   
   if (result == SQLITE_OK)
   {
       while (sqlite3_step(stmt) == SQLITE_ROW)
       {
           @autoreleasepool {
               char *name = (char *)sqlite3_column_text(stmt, 0);
               NSInteger age = sqlite3_column_int(stmt, 1);
               //创建对象
               Person *person = [Person personWithName:[NSString stringWithUTF8String:name] Age:age];
               [mArray addObject:person];
           }
       }
       self.sqlArray = mArray;
   }
   sqlite3_finalize(stmt);
}

- (void)openFMDB {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.db"];
    /**
     打开数据库
     databaseWithPath:方法中传入的path值有三种情况：
     1）具体文件路径，如果不存在会自动创建
     2）空字符串@""，会在临时目录创建一个空的数据库，当FMDatabase连接关闭时，数据库文件也被删除
     3）nil，会创建一个内存中临时数据库，当FMDatabase连接关闭时，数据库会被销毁
     */
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    if (![database open]) {
        NSLog(@"database open fail");
    }
    /**
     更新
     在FMDB中，除查询以外的所有操作，都称为“更新”,如：create、drop、insert、update、delete等操作，使用executeUpdate:方法执行更新：
     常用方法如下：
     - (BOOL)executeUpdate:(NSString*)sql, ...
     - (BOOL)executeUpdateWithFormat:(NSString*)format, ...
     - (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments
     */
    [database executeUpdate:@"CREATE TABLE IF NOT EXISTS t_person(id integer primary key autoincrement, name text, age integer)"];
//    [database executeUpdate:@"INSERT INTO t_person(name, age) VALUES(?, ?)", @"Bourne", [NSNumber numberWithInt:42]];

    /**
     查询
     - (FMResultSet *)executeQuery:(NSString*)sql, ...
     - (FMResultSet *)executeQueryWithFormat:(NSString*)format, ...
     - (FMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments
     */
    FMResultSet *result = [database executeQuery:@"SELECT * FROM t_person"];
    while ([result next])
    {
        @autoreleasepool {
            NSString *name = [result stringForColumn:@"name"];
            int age = [result intForColumn:@"age"];
            Person *person = [Person personWithName:name Age:age];
            [self.sqlArray addObject:person];
        }
    }
}

- (void)openFMDBMultithreading {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 使用队列
//    [queue inDatabase:^(FMDatabase *database) {
////        [database executeUpdate:@"INSERT INTO t_person(name, age) VALUES (?, ?)", @"Bourne_1", [NSNumber numberWithInt:1]];
////        [database executeUpdate:@"INSERT INTO t_person(name, age) VALUES (?, ?)", @"Bourne_2", [NSNumber numberWithInt:2]];
////        [database executeUpdate:@"INSERT INTO t_person(name, age) VALUES (?, ?)", @"Bourne_3", [NSNumber numberWithInt:3]];
//        FMResultSet *result = [database executeQuery:@"select * from t_person"];
//        while ([result next])
//        {
//            @autoreleasepool {
//                NSString *name = [result stringForColumn:@"name"];
//                int age = [result intForColumn:@"age"];
//                Person *person = [Person personWithName:name Age:age];
//                [self.sqlArray addObject:person];
//            }
//        }
//        NSLog(@"");
//    }];
//    NSLog(@"");
    
    // 使用事务
    [queue inTransaction:^(FMDatabase *database, BOOL *rollback) {
        [database executeUpdate:@"INSERT INTO t_person(name, age) VALUES (?, ?)", @"Bourne_1", [NSNumber numberWithInt:6]];
        [database executeUpdate:@"INSERT INTO t_person(name, age) VALUES (?, ?)", @"Bourne_2", [NSNumber numberWithInt:7]];
        [database executeUpdate:@"INSERT INTO t_person(name, age) VALUES (?, ?)", @"Bourne_3", [NSNumber numberWithInt:8]];
        FMResultSet *result = [database executeQuery:@"select * from t_person"];
        while ([result next])
         {
             @autoreleasepool {
                 NSString *name = [result stringForColumn:@"name"];
                 int age = [result intForColumn:@"age"];
                 Person *person = [Person personWithName:name Age:age];
                 [self.sqlArray addObject:person];
             }
         }
         NSLog(@"");
        //回滚
        *rollback = YES; // 设置为YES表示放弃所有更改
    }];
    NSLog(@"");

}

- (NSMutableArray *)sqlArray {
    if (_sqlArray == nil) {
        _sqlArray = [NSMutableArray array];
    }
    return _sqlArray;
}

@end
