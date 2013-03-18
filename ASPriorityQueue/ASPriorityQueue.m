#import "ASPriorityQueue.h"

@implementation ASPriorityQueue {
	NSMutableArray *_objects;
	NSComparator _comparator;
}



- (id)init {
	return [self initWithComparator:^NSComparisonResult(id first, id second){
		return [first compare:second];
	}];
}

- (id)initWithComparator:(NSComparator)comparator {
	self = [super init];
	if (self) {
		_objects = [NSMutableArray array];
		_comparator = comparator;
	}

	return self;
}


- (id)firstObject {
	if (_objects.count == 0) {
		return nil;
	}

	[self heapify];
	return _objects[0];
}


- (void)addObject:(id)object {
	[_objects addObject:object];

}

- (void)removeFirstObject {
	[self heapify];
	[_objects removeObjectAtIndex:0];

}

- (BOOL)containsObject:(id)object {
	return [_objects containsObject:object];
}


- (NSUInteger)count {
	return [_objects count];
}

- (NSArray *)allValues {
	[self heapify];
 	return [_objects copy];
}



- (void)heapify {
	[_objects sortUsingComparator:_comparator];
}

@end
