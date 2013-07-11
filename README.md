LLBinaryOperators
=================

Binary Enumeration Operators, since NSArray only supports object equality

### Rationale
The NSArray methods for binary enumeration only work when dealing with object equality:

```
- (NSUInteger)indexOfObject:(id)obj inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp
```

Sometimes, you may wish to get the performance gain of a binary enumeration within a sorted array, without requiring object equality.

### Usage

For example, you may have a large array of (NSValue wrapped) CGRects which are ordered by position in an NSArray, and want to obtain a subarray that intersects with a given query rect

You can use the category:
```
- (void) ll_binaryEnumerate:(MI9BinaryEnumerationBlock)block;
```

You can do this to obtain the rectangles that intersect with the lowest value in the x dimension:
```
NSArray * arrayOfCGRects = ....;
CGRect intersectionRect = ....;
__block NSUInteger intersectionIndex = NSNotFound;
[arrayOfCGRects ll_binaryEnumerate:NSComparisonResult^(NSUInteger index, SomeObject * object, NSRange range, BOOL * stop) {
  CGRect * rect = [[object boundsValue] CGRectValue];
  if(CGRectIntersectsRect(rect, intersectionRect) {
    intersectionIndex = index;
    *stop = YES;
    // Enumerates downwards
    return NSOrderedDescending;
  } else if (CGRectGetMinX(rect) > CGRectGetMaxX(intersectionRect)) {
    return NSOrderedAscending;
  } else if (CGRectGetMaxX(rect) < CGRectGetMinX(intersectionRect)) {
    return NSOrderedDescending;
  }
  
  *stop = YES;
  return NSOrderedSame;
}];
```

We have the leftmost index, now linearly enumerate upwards until we hit the rightmost index
```
NSMutableArray * intersectionObjects = [NSMutableArray array];
if(intersectionIndex != NSNotFound) {
    [arrayOfCGRects enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(intersectionIndex, [array count] - indersectionIndex)] options:0 usingBlock:^(SomeObject * obj, NSUInteger idx, BOOL *stop) {
        if(CGRectIntersectsRect([[obj boundsValue] CGRectValue], intersectionRect)) {
            [intersectionObjects addObject:obj];
            return;
        }
        *stop = YES;
    }];
    
    NSLog(@"Objects %@ intersect rect %@", intersectionObjects, NSStringFromCGRect(intersectionRect));
}
```

