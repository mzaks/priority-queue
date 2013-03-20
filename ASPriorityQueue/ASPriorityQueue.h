#import <Foundation/Foundation.h>

@interface ASPriorityQueue : NSObject

- (id)initWithComparator:(NSComparator)comparator;
- (id)initWithComparator:(NSComparator)comparator andCapacity:(NSUInteger)capacity;

- (id)firstObject;
- (void)removeFirstObject;

- (void)addObject:(id)object;

- (BOOL)containsObject:(id)object;
- (NSUInteger)count;
- (NSArray *)allValues;

@end
