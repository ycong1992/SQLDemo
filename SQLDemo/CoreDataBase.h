/**
 https://www.cnblogs.com/mjios/archive/2013/02/26/2932999.html
 https://github.com/DeveloperErenLiu/CoreDataPDF

 CoreData是针对SQLite3封装的框架，它提供了对象-关系映射(ORM)的功能，即能够将OC对象转化成数据，保存在SQLite数据库文件中，也能够将保存在数据库中的数据还原成OC对象(本质还是要转换成对应的SQL语句去执行)
 t_person
 id  name  age
 1   AA    25
 2   BB    26
 关系模型：即数据库。如上数据库里面有张person表，person表里面有id、name、age三个字段，而且有2条记录(Person id=1,name=@"AA",age=25  Person id=2,name=@"BB",age=26)
 对象模型：OC对象
 
 在Core Data中，需要进行映射的对象称为实体(entity)，而且需要使用Core Data的模型文件来描述app中的所有实体和实体属性
 如Person(人)和Card(身份证)2个实体：Person中有个Card属性，Card中有个Person属性，这属于一对双向关联
 Person    Card
 name      no
 age       person
 card
 
 【创建模型文件的过程】
 1）选择模板，创建xxxModel.xcdatamodeld模型文件(存储着所有实体的数据结构和表示，如果是OC项目，创建后需要勾选成OC的)
 2）添加实体、实体属性
 3）如果是有关联关系的实体需要添加Relationships(在Person中加上Inverse属性后，你会发现Card中Inverse属性也自动补上了，建立了Person跟Card之间的一对一关联关系)
 【NSManagedObject】
 1）通过Core Data从数据库取出的对象，默认情况下都是NSManagedObject对象
 2）NSManagedObject的工作模式有点类似于NSDictionary对象，通过键-值对来存取所有的实体属性
 <1>setValue:forKey:存储属性值(属性名为key)；<2> valueForKey:获取属性值(属性名为key)
 【CoreData的核心类】
 NSPersistentStore：负责和SQL数据库进行数据交互
 NSPersistentStoreCoordinator(PSC)：负责协调存储区和上下文之间的关系
 NSManagedObjectContext(MOC)：托管对象上下文，进行数据操作时大多都是和这个类打交道
 NSManagedObjectModel(MOM)：一个托管对象模型关联一个模型文件(.xcdatamodeld)，存储着数据库的数据结构
 NSManagedObject及其子类称之为托管对象：托管对象类，所有CoreData中的托管对象都必须继承自当前类，根据实体创建托管对象类文件
 NSEntityDescription：用来描述实体
 关系：NSManagedObjectContext<->NSPersistentStoreCoordinator<->NSPersistentStore<->SQLite<->File System
 【开发步骤总结】
 1）初始化NSManagedObjectModel对象，加载模型文件，读取app中的所有实体信息
 2）初始化NSPersistentStoreCoordinator对象，添加持久化库(这里采取SQLite数据库)
 3）初始化NSManagedObjectContext对象，拿到这个上下文对象操作实体，进行CRUD操作
 备注：在CoreData中所有的托管对象被创建出来后，都是关联着上下文的。所以在对象进行任何操作后，都会被记录在MOC中。在最后调用MOC的save方法后，MOC会将操作交给PSC去处理，PSC将会将这个存储任务指派给NSPersistentStore对象
 
 【NSManagedObjectContext初始化】
 使用initWithConcurrencyType:方法来创建NSManagedObjectContext对象，初始化方法的枚举值有三种：
 1）NSConfinementConcurrencyType：在iOS9之后已经被苹果废弃
 2）NSPrivateQueueConcurrencyType：私有并发队列类型，操作都是在子线程中完成的
 3）NSMainQueueConcurrencyType：主并发队列类型，如果涉及到UI相关的操作，应该考虑使用这个参数初始化上下文
 
 NSPersistentStoreCoordinator有四种可选的持久化存储方案：NSSQLiteStoreType、NSXMLStoreType、NSBinaryStoreType(二进制文件)、NSInMemoryStoreType(直接存储在内存中)
 
 CoreData中可以通过设置NSFetchRequest类的predicate属性，来设置一个NSPredicate类型的谓词对象当做过滤条件(只获取符合过滤条件的托管对象，不会将所有托管对象都加载到内存中)
 功能：分页查询、模糊查询、加载请求模板(在模型文件中设置的请求模板)、获取结果Count值、位运算(对某个属性计算总和)、批量更新和删除(iOS8之后的API，操作后需手动刷新受影响的MOC中存储的托管对象，使MOC和本地持久化数据统一)、异步请求(系统会将所有的异步请求添加到一个操作队列中，确保线程安全)
 
 NSFetchedResultsController类：高效地管理UITableView或UICollectionView的数据源，可以绑定和监听MOC
 备注：如果是其它MOC对同个存储区进行操作，FRC是无法监听的，所以在CoreData持久化层设计时，尽量一个存储区只对应一个MOC，或设置一个负责UI的MOC
 
 版本迁移：在原有模型文件的基础上，创建一个新版本的模型文件(Xcode提供该功能)，然后在此基础上做不同方式的版本迁移
 1）轻量级版本迁移：针对增加和改变实体、属性这样的一些简单操作。设置options参数，PSC会自动推断版本迁移的过程
 2）Mapping Model迁移：通过Xcode创建一个后缀为.xcmappingmodel的文件，用来进行数据迁移
 
 MOC初始化时指定的并发队列由系统所拥有，外部无法获取。在多线程情况下使用MOC时，不能简单的将MOC从一个线程中传递到另一个线程中使用。而是通过MOC多线程调用方式：performBlock(异步执行，如将save方法放在MOC的block体中异步执行)和performBlockAndWait(同步执行)
 备注：这两种不能在NSConfinementConcurrencyType类型的MOC下调用
 
 大量数据处理且涉及到UI的操作时，一般采取多个MOC配合的方式：
 1）在iOS5之前实现MOC的多线程，可以创建多个MOC，多个MOC使用同一个PSC。但这种方式下，当一个MOC发生改变并持久化到本地时，系统并不会将其他MOC缓存在内存中的NSManagedObject对象改变，所以需要在MOC发生改变时，手动将其他MOC数据更新(监听所有MOC执行save操作后的通知，并在回调中进行数据同步)
 2）在iOS5之后，MOC可以设置parentContext，一个parentContext可以拥有多个ChildContext。在ChildContext执行save操作后，会将改变push到parentContext，再由parentContext执行save方法将改变保存到存储区，而parentContext中的managedObject发生变化时，会马上同步给ChildContext，这解决了之前MOC手动同步数据的问题(这里只需parentContext关联PSC，一般使用persistentStoreCoordinator <- backgroundContext <- mainContext <- privateContext的设计方案)
 
 CoreData优点：
 1）更加面向对象：无需任何SQL语句，直接使用托管对象即可
 2）可视化效果好且结构清晰：模型文件内部的结构以及实体之间的对应关系都可以展示出来
 3）可以设置关联关系(一对一或一对多的关系，关联的对象可以和当前对象一起被MOC操作)
 4）开发效率比较快
 缺点：
 1）CoreData是对SQLite的一个封装，上层不能直接对数据库进行操作(不建议用SQL语句对数据库直接操作，避免后期维护困难)
 2）进行大量数据处理时比较吃力，性能明显低于直接操作SQLite数据库，而且内存占用非常大，需要手动做内存控制
 
 MagicalRecord：基于CoreData封装的第三方
 */
