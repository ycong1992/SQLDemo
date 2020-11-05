//
//  ViewController.m
//  SQLDemo
//
//  Created by SZOeasy on 2020/11/5.
//  Copyright © 2020 ycong. All rights reserved.
//

/**
 数据库查看软件：DB Browser for SQLite
 
 sqlite3 总体来说使用比较麻烦，平时开发更多的是使用第三方框架FMDB
 事务：事务是一个并发控制的基本单元，所谓的事务，它是一个操作序列，这些操作要么都执行，要么都不执行，它是一个不可分割的工作单位。
 事务与非事务，简单的举例来说就是，事务就是把所有的东西打包在一起，一次性处理它。而非事务就是一条一条的来执行并且处理。
 
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
