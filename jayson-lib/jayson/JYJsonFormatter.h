//
//  JYJsonFormatter.h
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-12.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYCaseConverter.h"
#import "JYFormatterState.h"

@interface JYJsonFormatter : NSObject

/*
 * Serializer used by the json formatter.
 */
@property (nonatomic, strong, readonly) id jsonSerializer;

/**
 * Case converter used to name json properties.
 */
@property (nonatomic, strong) NSObject<JYCaseConverter> *caseConverter;

/*
 * Initializes a json formatter with a json formatter.
 */
- (instancetype)initWithSerializer:(id)serializer;

/**
 * Writes an object to the state.
 */
- (void)writeObject:(id)obj withState:(JYFormatterState *)state errors:(NSArray **)errors;

@end
