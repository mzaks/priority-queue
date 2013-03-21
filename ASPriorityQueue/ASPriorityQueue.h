#import <Foundation/Foundation.h>

@interface ASPriorityQueue : NSObject

- (id)initWithComparator:(NSComparator)comparator;
- (id)initWithComparator:(NSComparator)comparator andCapacity:(NSUInteger)capacity;

- (void)addObject:(id)object;

- (id)firstObject;
- (void)removeFirstObject;

- (BOOL)containsObject:(id)object;
- (NSUInteger)count;
- (NSArray *)allValues;

@end
