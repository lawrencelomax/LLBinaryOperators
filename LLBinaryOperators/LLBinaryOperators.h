//
//  LLBinaryOperators.h
//  LLBinaryOperators
//
//  Created by Lawrence Lomax on 14/06/13.
//  Copyright (c) 2013 Lawrence Lomax. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSComparisonResult (^MI9BinaryEnumerationBlock) ( NSUInteger index, id object, BOOL * stop );

@interface LLBinaryOperators : NSObject

+ (void) enumerateArray:(NSArray *)array withBlock:(MI9BinaryEnumerationBlock)block;

@end

@interface NSArray (LLBinaryOperators)

- (void) ll_binaryEnumerate:(MI9BinaryEnumerationBlock)block;

@end
