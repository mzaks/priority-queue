#import "ASPriorityQueue.h"

#define parent(index) (index >> 1)
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
	free(_objects);
	_objects = NULL;
	_heapSize = 0;
	_capacity = 0;
	[_comparator release];
	[super dealloc];
}


- (id)firstObject {
	if (_heapSize == 0) {
		return nil;
	}

	return _objects[0];
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

	if (index >= _heapSize) {
		return;
	}

	NSUInteger left = left(index);
	NSUInteger right = right(index);

	NSUInteger arrayIndex = index - 1;

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

	NSArray *values = [[objectsAsArray sortedArrayUsingComparator:^NSComparisonResult(id first, id second){
		return _comparator(second, first);
	}] autorelease];

	[objectsAsArray release];
	return values;
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
