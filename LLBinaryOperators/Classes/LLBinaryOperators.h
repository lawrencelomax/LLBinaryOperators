//
//  LLBinaryOperators.h
//  LLBinaryOperators
//
//  Created by Lawrence Lomax on 14/06/13.
//  Copyright (c) 2013 Lawrence Lomax. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSUInteger LL_NSRangeMidpoint(NSRange range);

typedef NSComparisonResult (^LLBinaryEnumerationArrayBlock) (NSUInteger index, id object, NSRange currentRange, BOOL *stop);

@interface LLBinaryOperators : NSObject

/**
 * Enumerate through the given ordered array with a block.
 * @param array The Array to enumerate over
 * @param block The block defines which direction to traverse from each index, by returning an NSComparisonResult
 *  Returning NSOrderedSame will break out of the enumeration
 *  Returning NSOrderedAscending will enumerate upwards if there are any remaining values
 *  Returning NSOrderedDescening will enumerate downwards if there are any remaining values
 */
+ (void) binareEnumerateArray:(NSArray *)array withBlock:(LLBinaryEnumerationArrayBlock)block;

@end

@interface NSArray (LLBinaryOperators)

/**
 * A convenience method for +enumerateArray:withBlock: on self
 * @block The block to enumerate over the array
 */
- (void) ll_binaryEnumerate:(LLBinaryEnumerationArrayBlock)block;

@end
