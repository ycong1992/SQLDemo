//
//  Person.h
//  SQLDemo
//
//  Created by SZOeasy on 2020/11/5.
//  Copyright © 2020 ycong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject <NSCoding>

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger age;

+ (instancetype)personWithName:(NSString *)name Age:(NSInteger)age;

@end

NS_ASSUME_NONNULL_END
