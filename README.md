LLBinaryOperators
=================

Binary Enumeration Operators on NSArray. Fully unit tested.

### Rationale
The NSArray methods for binary enumeration only work when dealing with object equality:

```
- (NSUInteger)indexOfObject:(id)obj inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp
```

Sometimes, you may wish to get the performance gain of a binary enumeration within a sorted array, without requiring object equality. It isn't always possible or desirable to override ``isEqual:`` to allow for object equality. For example in a hashed collection, you cannot express intersection via a ``hashCode``

### Usage

You may have a object that contains some layout information for a large number of items ordered by position. To obtain the layout information for a given query rectangle, you could use linear enumeration, however it would be much more efficient to use a Binary Search. As you cannot use the standard ``NSArray`` methods due to requiring object equality, you can use LLBinaryOperators to obtain the layout information that intersects with the query rectangle.

Use the category method. method:
```
- (void) ll_binaryEnumerate:(MI9BinaryEnumerationBlock)block;
```

You can do this to obtain the rectangles that intersect with the lowest value in the x dimension:
```
NSArray * arrayOfCGRects = ....;
CGRect intersectionRect = ....;
__block NSUInteger intersectionIndex = NSNotFound;
[arrayOfCGRects ll_binaryEnumerate:NSComparisonResult^(NSUInteger index, LayoutInformation * object, NSRange range, BOOL * stop) {
  CGRect * rect = [object bounds];
  if(CGRectIntersectsRect(rect, intersectionRect) {
    intersectionIndex = index;
    // We have an index that intersects, but it could be anywhere in a range
    // we should go downwards to find the lowest index that intersects
    // When we have this index we can enumerate linearly up to find the highest index
    return NSOrderedDescending;
  } else if (CGRectGetMinX(rect) > CGRectGetMaxX(intersectionRect)) {
    // Move right (up) the array
    return NSOrderedAscending;
  } else if (CGRectGetMaxX(rect) < CGRectGetMinX(intersectionRect)) {
    // Move left (down) along the array
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
        if(CGRectIntersectsRect([obj bounds], intersectionRect)) {
            [intersectionObjects addObject:obj];
            return;
        }
        *stop = YES;
    }];
    
    NSLog(@"Objects %@ intersect rect %@", intersectionObjects, NSStringFromCGRect(intersectionRect));
}
```
