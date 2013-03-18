#import <Foundation/Foundation.h>

@interface ASPriorityQueue : NSObject

- (id)firstObject;

- (id)initWithComparator:(NSComparator)comparator;

- (void)addObject:(id)object;

- (void)removeFirstObject;

- (BOOL)containsObject:(id)object;

- (NSUInteger)count;

- (NSArray *)allValues;
@end
