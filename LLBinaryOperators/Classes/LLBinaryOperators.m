//
//  LLBinaryOperators.m
//  LLBinaryOperators
//
//  Created by Lawrence Lomax on 14/06/13.
//  Copyright (c) 2013 Lawrence Lomax. All rights reserved.
//

#import "LLBinaryOperators.h"

extern NSUInteger LL_NSRangeMidpoint(NSRange range)
{
    if(range.length == 0)
        return range.location;
    
    NSUInteger midpoint = range.location + floor(range.length / 2);
    return midpoint;
}

@implementation LLBinaryOperators

+ (void) binareEnumerateArray:(NSArray *)array withBlock:(LLBinaryEnumerationArrayBlock)block
{
    [self enumerateArray:array withBlock:block inRange:NSMakeRange(0, array.count)];
}

+ (void) enumerateArray:(NSArray *)array withBlock:(LLBinaryEnumerationArrayBlock)block inRange:(NSRange)range
{
    while (range.length > 0)
    {
        NSUInteger index = LL_NSRangeMidpoint(range);
        id value = array[index];
        
        BOOL stop = NO;
        NSComparisonResult result = block(index, value, range, &stop);
        
        if(result == NSOrderedSame) break;
        if(stop) break;
        if(range.length == 0) break;
        
        // Enumerate Downwards
        if(result == NSOrderedDescending)
        {
            range = NSMakeRange(range.location, index - range.location);
            continue;
        }
        // Enumerate Upwards
        else if(result == NSOrderedAscending)
        {
            range = NSMakeRange(index + 1, NSMaxRange(range) - (index + 1));
            continue;
        }
        
        NSAssert(NO, @"Unknown NSOrdering range Provided: %ld", result);
    }
}

@end

@implementation NSArray (LLBinaryOperators)

- (void) ll_binaryEnumerate:(LLBinaryEnumerationArrayBlock)block
{
    [LLBinaryOperators binareEnumerateArray:self withBlock:block];
}

@end
