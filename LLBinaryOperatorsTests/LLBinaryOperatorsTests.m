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
        
    });
    
});

SPEC_END