#import "ASPriorityQueue.h"

#define left(index) (index << 1)
#define right(index) ((index << 1) | 1)

#define DEFAULT_CAPACITY 10

@implementation ASPriorityQueue {
	id *_objects;
	NSUInteger _capacity;
	NSUInteger _heapSize;
	NSComparator _comparator;
}

- (id)init {
	return [self initWithComparator:^NSComparisonResult(id first, id second){
		return [first compare:second];
	}];
}

- (id)initWithComparator:(NSComparator)comparator {
	return [self initWithComparator:comparator andCapacity:DEFAULT_CAPACITY];
}

- (id)initWithComparator:(NSComparator)comparator andCapacity:(NSUInteger)capacity {
	self = [super init];
	if (self) {
		_capacity = capacity;
		_objects = (id *) calloc(_capacity, sizeof(id));
		_heapSize = 0;
		_comparator = [comparator retain];
	}

	return self;
}


- (void)dealloc {
	[_comparator release];
	free(_objects);
	[super dealloc];
}


- (void)addObject:(id)object {
	if (_heapSize == _capacity) {
		[self resizeStorage];
	}

	_objects[_heapSize] = [object retain];
	_heapSize++;

	[self heapify];
}


- (void)resizeStorage {
	_objects = (id *) realloc(_objects, sizeof(id) * (_capacity + DEFAULT_CAPACITY));
	for (int i = _capacity; i < _capacity + DEFAULT_CAPACITY; i++) {
		_objects[i] = NULL;
	}
	_capacity += DEFAULT_CAPACITY;
}


- (id)firstObject {
	if (_heapSize == 0) {
		return nil;
	}

	return _objects[0];
}


- (void)removeFirstObject {
	if (_heapSize < 1) {
		return;
	}

	[_objects[0] release];
	memmove(_objects, _objects+1, sizeof(*_objects) * _heapSize);
	if (_heapSize < _capacity) {
		_objects[_heapSize-1] = nil;
	}
	--_heapSize;

	[self heapify];
}


- (BOOL)containsObject:(id)object {
	BOOL wasFound = NO;
	[self searchObject:object fromIndex:1 wasFound:&wasFound];
	return wasFound;
}


- (void)searchObject:(id)object fromIndex:(NSUInteger)index wasFound:(BOOL*)wasFound {
	NSUInteger arrayIndex = index - 1;

	//We don't need to continue searching if object at current index is "smaller" than searched object
	if (index >= _heapSize || _comparator(_objects[arrayIndex], object) == NSOrderedAscending) {
		return;
	}

	NSUInteger left = left(index);
	NSUInteger right = right(index);


	if ([_objects[arrayIndex] isEqual:object]) {
		*wasFound = YES;
		return;
	}
	else {
		[self searchObject:object fromIndex:left wasFound:wasFound];
		[self searchObject:object fromIndex:right wasFound:wasFound];
	}
}


- (NSUInteger)count {
	return _heapSize;
}


- (NSArray *)allValues {

	NSArray *objectsAsArray = [[NSArray alloc] initWithObjects:_objects count:_heapSize];
	NSArray *values = [objectsAsArray sortedArrayUsingComparator:^NSComparisonResult(id first, id second){
		return _comparator(second, first);
	}];

	[objectsAsArray release];
	return values;
}


- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id[])buffer count:(NSUInteger)len {

	if(state->state == 0) {
		state->mutationsPtr = (unsigned long *) self;
		state->itemsPtr = _objects;
		state->state = 1;
		return _heapSize;
	}

	[self rebuildHeap];
	return 0;
}



- (void)rebuildHeap {

	for (NSUInteger i = _heapSize / 2; i >= 1; i--) {
		[self heapifyFromIndex:i];
	}

	[self heapifyFromIndex:1]; //TODO for some reason we have to heapify an extra time. Find out why and fix it.
}


- (void)heapify {
	if (_heapSize < 2) {
		return;
	}
	[self heapifyFromIndex:1];
}


- (void)heapifyFromIndex:(NSUInteger)index {


	NSUInteger left = left(index);
	NSUInteger right = right(index);

	NSUInteger arrayIndex = index - 1;
	NSUInteger arrayLeft = left - 1;
	NSUInteger arrayRight = right - 1;

	NSUInteger largest;
	if (left <= _heapSize && _comparator(_objects[arrayLeft], _objects[arrayIndex]) == NSOrderedDescending) {
		largest = left;
	}
	else {
		largest = index;
	}

	if (right <= _heapSize && _comparator(_objects[arrayRight], _objects[arrayIndex]) == NSOrderedDescending) {
		largest = right;
	}

	if (largest != index) {
		id temp = _objects[arrayIndex];
		_objects[arrayIndex] = _objects[largest - 1];
		_objects[largest - 1] = temp;

		[self heapifyFromIndex:largest];
	}

}


@end
