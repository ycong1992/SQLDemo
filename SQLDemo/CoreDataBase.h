/**
 https://www.cnblogs.com/mjios/archive/2013/02/26/2932999.html
 备注：Core Data是针对SQLite3的封装，本质还是要转换成对应的SQL语句去执行

 Core Data是iOS5之后才出现的一个框架，它提供了对象-关系映射(ORM)的功能，即能够将OC对象转化成数据，保存在SQLite数据库文件中，也能够将保存在数据库中的数据还原成OC对象(在此数据操作期间，我们不需要编写任何SQL语句)
 person
 id  name  age
 1   AA    25
 2   BB    26
 关系模型：即数据库。如上数据库里面有张person表，person表里面有id、name、age三个字段，而且有2条记录
 Person id=1,name=@"AA",age=25  Person id=2,name=@"BB",age=26
 对象模型：OC对象
 
 在Core Data中，需要进行映射的对象称为实体(entity)，而且需要使用Core Data的模型文件来描述app中的所有实体和实体属性
 如Person(人)和Card(身份证)2个实体：Person中有个Card属性，Card中有个Person属性，这属于一对双向关联
 Person    Card
 name      no
 age       person
 card
 【创建模型文件的过程】
 1）选择模板，创建xxxModel.xcdatamodeld模型文件(如果是OC项目，创建后需要勾选成OC的)
 2）添加实体、实体属性
 3）如果是有关联关系的实体需要添加Relationships(在Person中加上Inverse属性后，你会发现Card中Inverse属性也自动补上了，建立了Person跟Card之间的一对一关联关系)
 
 【NSManagedObject】
 1）通过Core Data从数据库取出的对象，默认情况下都是NSManagedObject对象
 2）NSManagedObject的工作模式有点类似于NSDictionary对象，通过键-值对来存取所有的实体属性
 <1>setValue:forKey:存储属性值(属性名为key)；<2> valueForKey:获取属性值(属性名为key)
 
 【CoreData中的核心对象】
 NSManagedObjectContext：负责应用和数据库之间的交互
 NSPersistentStoreCoordinator：添加持久化存储库(如SQLite数据库)
 NSManagedObjectModel：代表Core Data的模型文件
 NSEntityDescription：用来描述实体
 开发步骤总结：
 1）初始化NSManagedObjectModel对象，加载模型文件，读取app中的所有实体信息
 2）初始化NSPersistentStoreCoordinator对象，添加持久化库(这里采取SQLite数据库)
 3）初始化NSManagedObjectContext对象，拿到这个上下文对象操作实体，进行CRUD操作
 
 优点：
 1）更加面向对象：无需任何SQL语句，直接使用托管对象即可
 2）可视化效果好且结构清晰：模型文件内部的结构以及实体之间的对应关系都可以展示出来
 3）可以设置关联关系(一对一或一对多的关系)
 4）开发效率比较快
 缺点：
 1）CoreData是对SQLite的一个封装，上层不能直接对数据库进行操作(不建议用SQL语句对数据库直接操作，避免后期维护困难)
 2）进行大量数据处理时比较吃力，性能明显低于直接操作SQLite数据库，而且内存占用非常大，需要手动做内存控制
 */
