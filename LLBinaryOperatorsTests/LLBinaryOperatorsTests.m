#import <Kiwi/Kiwi.h>

#import "LLBinaryOperators.h"

SPEC_BEGIN(LLBinaryOperatorsTests)

describe(@"Range Operators", ^{
    
    it(@"should return the position when the length is zero", ^{
        [[theValue(LL_NSRangeMidpoint(NSMakeRange(10, 0))) should] equal:theValue(10)];
    });
    
    it(@"should return an evenly dividable midpoint", ^{
        [[theValue(LL_NSRangeMidpoint(NSMakeRange(20, 5))) should] equal:theValue(22)];
    });

    it(@"should the value below the middle for non evenly dividable midpoint", ^{
        [[theValue(LL_NSRangeMidpoint(NSMakeRange(30, 6))) should] equal:theValue(33)];
    });

    
});

describe(@"the binary operators", ^{
   
    __block NSArray * orderedNumbers;
    
    beforeEach(^{
        orderedNumbers = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    });
    
    context(@"an empty array", ^{
       
        it(@"should never call the enumeration block", ^{
            
            [LLBinaryOperators enumerateArray:@[] withBlock:^NSComparisonResult(NSUInteger index, id object, BOOL *stop) {
                fail(@"This block should not be called");
                return NSOrderedSame;
            }];
            
        });
        
    });
    
    context(@"an array of 1", ^{
       
        it(@"should call the enum block once", ^{
            
            __block NSUInteger enumCount = 0;
            
            [LLBinaryOperators enumerateArray:@[@1] withBlock:^NSComparisonResult(NSUInteger index, id object, BOOL *stop) {
                enumCount++;
                return NSOrderedDescending;
            }];
            
            [[theValue(enumCount) should] equal:theValue(1)];
        });
        
    });
    
    context(@"the directions of enumeration", ^{
        
        it(@"should start off in the middle", ^{
            
            [LLBinaryOperators enumerateArray:orderedNumbers withBlock:^NSComparisonResult(NSUInteger index, id object, BOOL *stop) {
                [[theValue(index) should] equal:theValue(5)];
                *stop = YES;
                return NSOrderedSame;
            }];
            
        });
        
        it(@"should move downwards to the new middle when NSOrderedDescending is returned", ^{
            
            __block NSUInteger enumCount = 0;
            
            [LLBinaryOperators enumerateArray:orderedNumbers withBlock:^NSComparisonResult(NSUInteger index, id object, BOOL *stop) {
                if(enumCount == 0){
                    enumCount++;
                    return NSOrderedDescending;
                } else {
                    [[theValue(index) should] equal:theValue(2)];
                    *stop = YES;
                    return NSOrderedSame;
                }
            }];
            
        });
        
        it(@"should move upwards to the new middle when NSOrderedAscending is returned", ^{
            
            __block NSUInteger enumCount = 0;
            
            [LLBinaryOperators enumerateArray:orderedNumbers withBlock:^NSComparisonResult(NSUInteger index, id object, BOOL *stop) {
                if(enumCount == 0){
                    enumCount++;
                    return NSOrderedAscending;
                } else {
                    [[theValue(index) should] equal:theValue(8)];
                    *stop = YES;
                    return NSOrderedSame;
                }
            }];
            
        });
        
        it(@"should break out when NSOrderingSame is returned", ^{
            
            __block NSUInteger enumCount = 0;
            
            [LLBinaryOperators enumerateArray:orderedNumbers withBlock:^NSComparisonResult(NSUInteger index, id object, BOOL *stop) {
                enumCount++;
                return NSOrderedSame;
            }];
            
            [[theValue(enumCount) should] equal:theValue(1)];
            
        });
        
    });
    
});

SPEC_END