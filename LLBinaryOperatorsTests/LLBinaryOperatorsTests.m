#import <Kiwi/Kiwi.h>

#import "LLBinaryOperators.h"

SPEC_BEGIN(LLBinaryOperatorsTests)

describe(@"Range Operators", ^{
    
    it(@"should return the position when the length is 1", ^{
        [[theValue(LL_NSRangeMidpoint(NSMakeRange(10, 1))) should] equal:theValue(10)];
    });
    
    it(@"should return an evenly dividable midpoint", ^{
        [[theValue(LL_NSRangeMidpoint(NSMakeRange(20, 5))) should] equal:theValue(22)];
    });

    it(@"should the value below the middle for non evenly dividable midpoint", ^{
        [[theValue(LL_NSRangeMidpoint(NSMakeRange(30, 6))) should] equal:theValue(33)];
    });
    
});

describe(@"the binary operators", ^{
       
    context(@"an empty array", ^{
       
        it(@"should never call the enumeration block", ^{
            
            [LLBinaryOperators binareEnumerateArray:@[] withBlock:^NSComparisonResult(NSUInteger index, id object, NSRange range, BOOL *stop) {
                fail(@"This block should not be called");
                return NSOrderedSame;
            }];
            
        });
        
    });
    
    context(@"an array of 1", ^{
       
        it(@"should call the enum block once", ^{
            
            __block NSUInteger enumCount = 0;
            __block NSRange firstRange;
            
            [LLBinaryOperators binareEnumerateArray:@[@1] withBlock:^NSComparisonResult(NSUInteger index, id object, NSRange range, BOOL *stop) {
                enumCount++;
                firstRange = range;
                return NSOrderedDescending;
            }];
            
            [[theValue(enumCount) should] equal:theValue(1)];
            [[theValue(firstRange) should] equal:theValue(NSMakeRange(0, 1))];
        });
        
    });
    
    context(@"In a small array", ^{
       
        __block NSArray * array;
        
        beforeEach(^{
            array = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
        });
        
        it(@"should start off in the middle", ^{
            
            [LLBinaryOperators binareEnumerateArray:array withBlock:^NSComparisonResult(NSUInteger index, id object, NSRange range, BOOL *stop) {
                [[theValue(index) should] equal:theValue(5)];
                [[theValue(range) should] equal:theValue(NSMakeRange(0, 11))];
                *stop = YES;
                return NSOrderedSame;
            }];
            
        });
        
        it(@"should move downwards to the new middle when NSOrderedDescending is returned", ^{
            
            __block NSUInteger enumCount = 0;
            
            [LLBinaryOperators binareEnumerateArray:array withBlock:^NSComparisonResult(NSUInteger index, id object, NSRange range, BOOL *stop) {
                if(enumCount == 0){
                    enumCount++;
                    return NSOrderedDescending;
                } else {
                    [[theValue(index) should] equal:theValue(2)];
                    [[theValue(range) should] equal:theValue(NSMakeRange(0, 5))];
                    *stop = YES;
                    return NSOrderedSame;
                }
            }];
            
        });
        
        it(@"should move upwards to the new middle when NSOrderedAscending is returned", ^{
            
            __block NSUInteger enumCount = 0;
            
            [LLBinaryOperators binareEnumerateArray:array withBlock:^NSComparisonResult(NSUInteger index, id object, NSRange range, BOOL *stop) {
                if(enumCount == 0){
                    enumCount++;
                    return NSOrderedAscending;
                } else {
                    [[theValue(index) should] equal:theValue(8)];
                    [[theValue(range) should] equal:theValue(NSMakeRange(6, 5))];
                    *stop = YES;
                    return NSOrderedSame;
                }
            }];
            
        });
        
        it(@"should break out when NSOrderingSame is returned", ^{
            
            __block NSUInteger enumCount = 0;
            
            [LLBinaryOperators binareEnumerateArray:array withBlock:^NSComparisonResult(NSUInteger index, id object, NSRange range, BOOL *stop) {
                enumCount++;
                return NSOrderedSame;
            }];
            
            [[theValue(enumCount) should] equal:theValue(1)];
        });
        
        it(@"should break out when there are no more values to enumerate", ^{
            
            __block NSUInteger enumCount = 0;
            
            [LLBinaryOperators binareEnumerateArray:array withBlock:^NSComparisonResult(NSUInteger index, id object, NSRange range, BOOL *stop) {
                enumCount++;
                return NSOrderedDescending;
            }];
            
            [[theValue(enumCount) should] equal:theValue(4)];
        });
        
        it(@"should bounce back and forth", ^{
            
            __block NSUInteger enumCount = 0;
            
            [LLBinaryOperators binareEnumerateArray:array withBlock:^NSComparisonResult(NSUInteger index, id object, NSRange range, BOOL *stop) {
                enumCount++;
                
                if(enumCount == 1)
                {
                    [[theValue(index) should] equal:theValue(5)];
                    return NSOrderedAscending;
                }
                else if(enumCount == 2)
                {
                    [[theValue(index) should] equal:theValue(8)];
                    return NSOrderedDescending;
                }
                else if(enumCount == 3)
                {
                    [[theValue(index) should] equal:theValue(7)];
                    return NSOrderedDescending;
                }
                else if(enumCount == 4)
                {
                    [[theValue(index) should] equal:theValue(6)];
                    return NSOrderedDescending;
                }
                else
                {
                    fail(@"Should have broken out of the loop before here");
                }
                
                return NSOrderedDescending;
            }];
            
        });
        
    });
    
    context(@"in a large array", ^{
        
        __block NSArray * array;
        
        beforeEach(^{
            NSMutableArray * mutableArray = [[NSMutableArray alloc] initWithCapacity:101];
            // Array of 1 - 100
            for(int i=1; i <= 100; i++) {
                [mutableArray addObject:@(i)];
            }
            array = [mutableArray copy];
        });
        
        it(@"should bounce back and forth", ^{
            __block NSUInteger enumCount = 0;
            
            [LLBinaryOperators binareEnumerateArray:array withBlock:^NSComparisonResult(NSUInteger index, id object, NSRange range, BOOL *stop) {
                enumCount++;
                
                if(enumCount == 1)
                {
                    // 1-100, Mid = 50
                    [[theValue(index) should] equal:theValue(50)];
                    [[theValue(range) should] equal:theValue(NSMakeRange(0, 100))];
                    return NSOrderedAscending;
                }
                else if(enumCount == 2)
                {
                    // 51 51 - 100
                    [[theValue(index) should] equal:theValue(75)];
                    [[theValue(range) should] equal:theValue(NSMakeRange(51, 49))];
                    return NSOrderedDescending;
                }
                else if(enumCount == 3)
                {
                    // 51 - 74
                    [[theValue(index) should] equal:theValue(63)];
                    [[theValue(range) should] equal:theValue(NSMakeRange(51, 24))];
                    return NSOrderedDescending;
                }
                else if(enumCount == 4)
                {
                    // 51 - 62
                    [[theValue(index) should] equal:theValue(57)];
                    [[theValue(range) should] equal:theValue(NSMakeRange(51, 12))];
                    return NSOrderedDescending;
                }
                else if(enumCount == 5)
                {
                    // 51 - 56
                    [[theValue(index) should] equal:theValue(54)];
                    [[theValue(range) should] equal:theValue(NSMakeRange(51, 6))];
                    return NSOrderedAscending;
                }
                else if(enumCount == 6)
                {
                    // 55 - 56
                    [[theValue(index) should] equal:theValue(56)];
                    [[theValue(range) should] equal:theValue(NSMakeRange(55, 2))];
                    return NSOrderedAscending;
                }
                
                fail(@"Should have broken out of the loop before here");
                return NSOrderedDescending;
            }];
        });
        
    });
    
});

SPEC_END