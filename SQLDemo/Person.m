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

@end
