#import <Kiwi/Kiwi.h>

#import "LLBinaryOperators.h"

SPEC_BEGIN(LLBinaryOperatorsTests)

describe(@"the binary operators", ^{
   
    __block NSArray * orderedNumbers;
    
    beforeEach(^{
        orderedNumbers = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    });
    
    describe(@"the directions of enumeration", ^{
        
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
                    [[theValue(index) should] equal:theValue(7)];
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