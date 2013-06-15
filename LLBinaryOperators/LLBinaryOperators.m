//
//  LLBinaryOperators.m
//  LLBinaryOperators
//
//  Created by Lawrence Lomax on 14/06/13.
//  Copyright (c) 2013 Lawrence Lomax. All rights reserved.
//

#import "LLBinaryOperators.h"

@implementation LLBinaryOperators

+ (void) enumerateArray:(NSArray *)array withBlock:(MI9BinaryEnumerationBlock)block
{
    [self enumerateArray:array withBlock:block inRange:NSMakeRange(0, array.count)];
}

+ (void) enumerateArray:(NSArray *)array withBlock:(MI9BinaryEnumerationBlock)block inRange:(NSRange)range
{
    while (range.length > 0)
    {
        NSUInteger index = midpoint(range);
        id value = array[index];
        
        BOOL stop = NO;
        NSComparisonResult result = block(index, value, &stop);
        
        if(result == NSOrderedSame) break;
        if(stop) break;
        if(range.length == 0) break;
        
        if(result == NSOrderedDescending)
        {
            range = NSMakeRange(range.location, index - range.location);
        }
        else
        {
            range = NSMakeRange(index + 1, NSMaxRange(range) - (index + 1));
        }
    }
}

static NSUInteger midpoint(NSRange range)
{
    if(range.length == 0)
        return range.location;
    
    return (NSUInteger) NSMaxRange(range) / 2;
}

@end
