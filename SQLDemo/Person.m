//
//  Person.m
//  SQLDemo
//
//  Created by SZOeasy on 2020/11/5.
//  Copyright © 2020 ycong. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (instancetype)personWithName:(NSString *)name Age:(NSInteger)age {
    Person *person = [[Person alloc] init];
    person.name = name;
    person.age = age;
    
    return person;
}

/**
 NSCoding协议, 使用归档时需要实现
 如果需要归档的类是某个自定义类的子类时，就需要在归档和解档之前先实现父类的归档和解档方法。即 [super encodeWithCoder:aCoder] 和 [super initWithCoder:aDecoder] 方法
 */
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.age = [coder decodeIntegerForKey:@"age"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.age forKey:@"age"];
}

@end
