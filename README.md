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

For example, you may have a large array of (NSValue wrapped) CGRects which are ordered in an NSArray and want to obtain a subarray that intersects with a given query rect

You can use the category:
```
- (void) ll_binaryEnumerate:(MI9BinaryEnumerationBlock)block;
```

You can do this to obtain the rectange that intersects with the lowest value in the x dimension:
```
NSArray * arrayOfCGRects = ....;
CGRect intersectionRect = ....;
__block NSUInteger intersectionIndex = NSNotFound;
[intersectionAray ll_binaryEnumerate:NSComparisonResult^( NSUInteger index, SomeObject * object, BOOL * stop) {
  CGRect * rect = [[object boundsValue] CGRectValue];
  if(CGRectIntersectsRect(rect, intersectionRect) {
    intersectionIndex = index;
    *stop = YES;
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
