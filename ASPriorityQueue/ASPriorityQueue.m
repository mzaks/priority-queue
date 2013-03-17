#import "ASPriorityQueue.h"

@implementation ASPriorityQueue {
	NSMutableArray *_objects;
}


- (id)init {
	self = [super init];
	if (self) {
		_objects = [NSMutableArray array];
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


- (void)heapify {
	[_objects sortUsingSelector:@selector(compare:)];
}


- (void)addObject:(id)object {
	[_objects addObject:object];

}

@end
