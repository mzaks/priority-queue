#import "ASPriorityQueue.h"

#define parent(index) (index >> 1)
#define left(index) (index << 1)
#define right(index) ((index << 1) | 1)

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

	return _objects[0];
}


- (void)addObject:(id)object {
	[_objects addObject:object];
	[self heapify];
}

- (void)removeFirstObject {
	[_objects removeObjectAtIndex:0];
	[self heapify];
}

- (BOOL)containsObject:(id)object {
	return [_objects containsObject:object];
}


- (NSUInteger)count {
	return [_objects count];
}


- (NSArray *)allValues {
 	return [_objects sortedArrayUsingComparator:^NSComparisonResult(id first, id second) {
		return _comparator(second, first);
	}];
}



- (void)heapify {
	[self heapifyFromIndex:1];
}

- (void)heapifyFromIndex:(NSUInteger)index {
	NSUInteger left = left(index);
	NSUInteger right = right(index);

	NSUInteger arrayIndex = index - 1;
	NSUInteger arrayLeft = left - 1;
	NSUInteger arrayRight = right - 1;

	NSUInteger largest;
	if (left <= _objects.count && _comparator(_objects[arrayLeft], _objects[arrayIndex]) == NSOrderedDescending) {
		largest = left;
	}
	else {
		largest = index;
	}

	if (right <= _objects.count  && _comparator(_objects[arrayRight], _objects[arrayIndex]) == NSOrderedDescending) {
		largest = right;
	}

	if (largest != index) {
		[_objects exchangeObjectAtIndex:arrayIndex withObjectAtIndex:largest - 1];
		[self heapifyFromIndex:largest];
	}

}

@end
