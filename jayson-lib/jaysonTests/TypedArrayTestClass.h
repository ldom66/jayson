//
//  TypedArrayTestClass.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-15.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestClass;

@interface TypedArrayTestClass : NSObject

@property (strong, nonatomic) NSArray<TestClass> *testArray;

@end
