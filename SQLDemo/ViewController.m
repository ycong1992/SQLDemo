#import "ViewController.h"
#import "Person.h"
#import <sqlite3.h>
#import <FMDB.h>
#import <CoreData/CoreData.h>

@interface ViewController ()

@property (assign, nonatomic) sqlite3 *sqlite3 ;

@property (strong, nonatomic) NSMutableArray *sqlArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** sqlite3操作 */
//    [self openDatabase];
//    [self execData];
//    [self readData];
    
    /** FMDB操作 */
//    [self openFMDB];
//    [self openFMDBMultithreading]; // 多线程FMDatabaseQueue
}

#pragma mark - sqlite3
- (void)openDatabase {
    _sqlite3 = NULL;
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
    // 关闭数据库:sqlite3_close(_sqlite3)
}

- (void)execData {
    // 使用 `sqlite3_exec()` 方法可以执行任何`SQL`语句，比如`创表、更新、插入和删除`操作。但是一般不用它执行查询语句，因为它不会返回查询到的数据
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

#pragma mark - FMDB
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
    
    if ([database close]) {
        NSLog(@"database close success");
    } else {
        NSLog(@"database close fail");
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
    
    [queue close];
}

- (NSMutableArray *)sqlArray {
    if (_sqlArray == nil) {
        _sqlArray = [NSMutableArray array];
    }
    return _sqlArray;
}

#pragma mark - Core Data
- (void)initContext {
    /** 1）搭建上下文环境 */
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.data"]];
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = psc;
    // 用完之后，记得要[context release];

    /** 2）添加数据到数据库 */
    // 传入上下文，创建一个Person实体对象
    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    // 设置Person的简单属性
    [person setValue:@"MJ" forKey:@"name"];
    [person setValue:[NSNumber numberWithInt:27] forKey:@"age"];
    // 传入上下文，创建一个Card实体对象
    NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    [card setValue:@"4414241933432" forKey:@"no"];
    // 设置Person和Card之间的关联关系
    [person setValue:card forKey:@"card"];
    // 利用上下文对象，将数据同步到持久化存储库
    NSError *error2 = nil;
    BOOL success = [context save:&error2];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error2 localizedDescription]];
    }
    // 如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error2]，就能将更改的数据同步到数据库
    
    /** 3）从数据库中查询数据 */
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    // 设置排序（按照age降序）
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    // 设置条件过滤(搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*Itcast-1*"];
    request.predicate = predicate;
    // 执行请求
    NSError *error3 = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error3];
    if (error3) {
        [NSException raise:@"查询错误" format:@"%@", [error3 localizedDescription]];
    }
    // 遍历数据
    for (NSManagedObject *obj in objs) {
        NSLog(@"name=%@", [obj valueForKey:@"name"]);
    }
    // 注：Core Data不会根据实体中的关联关系立即获取相应的关联对象，比如通过Core Data取出Person实体时，并不会立即查询相关联的Card实体；当应用真的需要使用Card时，才会再次查询数据库，加载Card实体的信息。这个就是Core Data的延迟加载机制
    
    /** 4）删除数据库中的数据 */
    // 传入需要删除的实体对象
    [context deleteObject:card];
    // 将结果同步到数据库
    NSError *error4 = nil;
    [context save:&error4];
    if (error4) {
        [NSException raise:@"删除错误" format:@"%@", [error4 localizedDescription]];
    }
}

@end
