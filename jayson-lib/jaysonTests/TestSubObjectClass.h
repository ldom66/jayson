//
//  TestSubObjectClass.h
//  jayson-lib
//
//  Created by Hugo Crochetière on 2015-06-09.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComplexTypeTestClass.h"

@interface TestSubObjectClass : NSObject
@property ComplexTypeTestClass *test;
@property NSArray *testArray;
@end
