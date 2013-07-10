LLBinaryOperators
=================

Binary Enumeration Operators, since NSArray only supports object equality

### Rationale
The NSArray methods for binary enumeration only work when dealing with object equality:

```
- (NSUInteger)indexOfObject:(id)obj inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp
```

Sometimes, you may wish to get the performance gain of a binary enumeration within a sorted array, without requiring object equality

### Usage

For example, you may have a large array of (NSValue wrapped) CGRects which are ordered in an NSArray and want to obtain a subarray that intersects with a given query rect

