//
//  JYCamelCaseConverter.m
//  jayson-lib
//
//  Created by Dominic Lacaille on 2015-06-02.
//  Copyright (c) 2015 ldom66. All rights reserved.
//

#import "JYCamelCaseConverter.h"

@implementation JYCamelCaseConverter

- (NSString *)convert:(NSString *)propertyName {
    NSMutableString *result = [NSMutableString new];
    int wordStart = 0;
    for (int i=0; i<propertyName.length; i++)
    {
        char c = [propertyName characterAtIndex:i];
        char next = 0;
        if (i + 1 < propertyName.length)
            next = [propertyName characterAtIndex:i + 1];
        BOOL isEndOfWord = (![self isUpperCase:c] || [self isDigit:c]) && ![self isWordSeparator:c] && [self isUpperCase:next];
        if ([self isWordSeparator:next])
            isEndOfWord = true;
        if ([self isWordSeparator:c])
            wordStart = i + 1;
        if (next == 0 || isEndOfWord)
        {
            // Add the word to result.
            NSString *word = [propertyName substringWithRange:NSMakeRange(wordStart, i + 1 - wordStart)];
            if (result.length == 0)
                [result appendString:[word lowercaseString]];
            else
                [result appendString:[self capitalize:word]];
            wordStart = i + 1;
        }
    }
    return [NSString stringWithString:result];
}

- (NSString *)capitalize:(NSString *)str {
    if (str.length == 0)
        return str;
    if (str.length == 1)
        return [str uppercaseString];
    return [NSString stringWithFormat:@"%@%@", [[str substringToIndex:1] uppercaseString], [[str substringFromIndex:1] lowercaseString]];
}

- (BOOL)isWordSeparator:(char)c {
    return c == '_' || c == '-';
}

- (BOOL)isDigit:(char)c {
    return c >= '0' && c <= '9';
}

- (BOOL)isUpperCase:(char)c {
    return c >= 'A' && c <= 'Z';
}

@end
