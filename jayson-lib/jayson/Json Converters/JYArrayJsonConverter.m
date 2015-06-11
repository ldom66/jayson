//
//  JYArrayJsonConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-05-07.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYArrayJsonConverter.h"
#import <objc/runtime.h>

@implementation JYArrayJsonConverter


- (instancetype)initWithSerializer:(JYJsonSerializer *)serializer {
    if (self = [super init]) {
        self.jsonSerializer = serializer;
        return self;
    }
    return nil;
}

- (id)serialize:(id)obj {
    return obj;
}

- (id)deserialize:(NSString *)string {
    return [self deserialize:string withClass:[NSArray class]];
}

- (id)deserialize:(NSString *)string withClass:(Class)objectClass {
    return [self deserializeArray:string withClass:nil];
}

- (id)deserializeArray:(NSString *)string withClass:(Class)objectClass {
    if ([string isEqual:@"null"])
        return nil;
    // These characters are whitespaces that we should ignore.
    char const IgnoredChars[] = {' ', '\r', '\n', '\t'};
    if (![self canConvertJson:string])
        [NSException raise:@"Json Converter Error" format:@"Value '%@' is invalid for array", string];
    BOOL escaped = NO;
    BOOL inString = NO; // True if the character is currently part of a string.
    int arrayCounter = 0; // Deals with nested arrays.
    int objCounter = 0; // Deals with nested objects.
    NSMutableArray *array = [NSMutableArray new];
    NSMutableString *builder = [NSMutableString new];
    for (int i=1; i<[string length] - 1; i++)
    {
        // TODO: parse strings with \n
        char c = [string characterAtIndex:i];
        // If we find an unescaped " we reverse inString. We should not escape " if we are not in a string.
        if ((!inString || !escaped) && c == '\"')
            inString = !inString;
        // If we find [ or ] and we are not in a string, update array counter.
        if (!inString && (c == '[' || c == ']'))
            arrayCounter += c == '[' ? 1 : -1;
        // If we find { or } and we are not in a string, update array counter.
        if (!inString && (c == '{' || c == '}'))
            objCounter += c == '{' ? 1 : -1;
        // Reset escaped state.
        if (escaped)
            escaped = NO;
        // Escape characters with \ before them (eg: \" or \n)
        if (inString && c == '\\')
            escaped = YES;
        // If we are not in a string, we should escape whitespaces.
        if (!inString)
        {
            BOOL ignored = NO;
            for (int j=0; j<sizeof IgnoredChars; j++)
                if (IgnoredChars[j] == c)
                    ignored = YES;
            if (ignored)
                continue;
        }
        // If we are not in a string, an array or a dictionary and we find a comma we deserialize the string and add it to the array.
        if (!inString && arrayCounter == 0 && objCounter == 0 && c == ',')
        {
            [array addObject:[self.jsonSerializer deserializeObject:[NSString stringWithString:builder] withClass:objectClass]];
            builder = [NSMutableString new];
            // We should not add the comma to the next object.
            continue;
        }
        // We add the current character to the string.
        [builder appendFormat:@"%c", c];
    }
    // In the end we are left with a string and no comma. We should add the deserialized string to the array.
    if ([builder length] > 0)
        [array addObject:[self.jsonSerializer deserializeObject:[NSString stringWithString:builder] withClass:objectClass]];
    // Return the completed array.
    return array;
}

- (BOOL)canConvert:(Class)objectClass {
    return [objectClass isSubclassOfClass:[NSArray class]];
}

- (BOOL)canConvertJson:(NSString *)string {
    return [string hasPrefix:@"["] && [string hasSuffix:@"]"];
}

@end
