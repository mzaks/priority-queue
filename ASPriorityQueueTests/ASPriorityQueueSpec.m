#import "Kiwi.h"
#import "ASPriorityQueue.h"

SPEC_BEGIN(ASPriorityQueueSpec)


describe(@"ASPriorityQueue", ^{
	__block ASPriorityQueue *priorityQueue;


	context(@"initialized with the default init-method", ^{

		beforeEach(^{
			priorityQueue = [[[ASPriorityQueue alloc] init] autorelease];
		});

		it(@"creates an empty heap", ^{

			//when
			id firstObject = [priorityQueue firstObject];

			//then
			[firstObject shouldBeNil];
		});


		it(@"stores a single object", ^{

			//given
			[priorityQueue addObject:@1];

			//when
			id firstObject = [priorityQueue firstObject];

			//then
			[[firstObject should] equal:@1];
		});


		it(@"always returns the 'largest' object as the first object", ^{

			//given
			[priorityQueue addObject:@3];
			[priorityQueue addObject:@1];
			[priorityQueue addObject:@2];

			//when
			id firstObject = [priorityQueue firstObject];

			//then
			[[firstObject should] equal:@3];
		});


		it(@"removes the first object", ^{

			//given
			[priorityQueue addObject:@3];
			[priorityQueue addObject:@1];
			[priorityQueue addObject:@2];

			//when //then
			[priorityQueue removeFirstObject];
			[[[priorityQueue firstObject] should] equal:@2];

			//when //then
			[priorityQueue removeFirstObject];
			[[[priorityQueue firstObject] should] equal:@1];

			//when //then
			[priorityQueue removeFirstObject];
			[[priorityQueue firstObject] shouldBeNil];
		});


		it(@"removes multiple first objects", ^{

			//given
			[priorityQueue addObject:@3];
			[priorityQueue addObject:@3];
			[priorityQueue addObject:@2];
			[priorityQueue addObject:@3];
			[priorityQueue addObject:@1];

			//when //then
			[priorityQueue removeFirstObject];
			[[[priorityQueue firstObject] should] equal:@3];

			//when //then
			[priorityQueue removeFirstObject];
			[[[priorityQueue firstObject] should] equal:@3];

			//when //then
			[priorityQueue removeFirstObject];
			[[[priorityQueue firstObject] should] equal:@2];

		});


		it(@"finds a value", ^{

			//given
			[priorityQueue addObject:@"frim"];
			[priorityQueue addObject:@"frab"];
			[priorityQueue addObject:@"frob"];

			//when
			BOOL containsFrab = [priorityQueue containsObject:@"frab"];

			//then
			[[theValue(containsFrab) should] beYes];
		});


		it(@"counts the number of objects in the queue", ^{

			//given
			[priorityQueue addObject:@1];
			[priorityQueue addObject:@2];
			[priorityQueue addObject:@3];
			[priorityQueue addObject:@4];
			[priorityQueue addObject:@5];
			[priorityQueue addObject:@6];

			//when
			NSUInteger count = [priorityQueue count];

			//then
			[[theValue(count) should] equal:theValue(6)];
		});


		it(@"counts the number of objects in the queue with multiples", ^{

			//given
			[priorityQueue addObject:@1];
			[priorityQueue addObject:@1];
			[priorityQueue addObject:@2];
			[priorityQueue addObject:@3];
			[priorityQueue addObject:@3];
			[priorityQueue addObject:@4];
			[priorityQueue addObject:@5];
			[priorityQueue addObject:@5];
			[priorityQueue addObject:@6];

			//when
			NSUInteger count = [priorityQueue count];

			//then
			[[theValue(count) should] equal:theValue(9)];
		});



		it(@"returns 0 as the count of an empty queue", ^{

			//when
			NSUInteger count = [priorityQueue count];

			//then
			[[theValue(count) should] equal:theValue(0)];
		});


		it(@"provides a sorted array with all values", ^{

			//given
			[priorityQueue addObject:@3];
			[priorityQueue addObject:@1];
			[priorityQueue addObject:@2];

			//when
			NSArray *values = [priorityQueue allValues];

			//then
			[[values should] equal:@[@3, @2, @1]];
		});



		it(@"should by default use 'compare:' for comparison", ^{

			//given
			NSNumber *one = [NSNumber nullMockWithName:@"one"];
			NSNumber *two = [NSNumber nullMockWithName:@"two"];
			NSNumber *three = [NSNumber nullMockWithName:@"three"];

			//expectations
			[[one should] receive:@selector(compare:) withCountAtLeast:1];

			//when
			[priorityQueue addObject:three];
			[priorityQueue addObject:one];
			[priorityQueue addObject:two];

			[priorityQueue firstObject];

		});


		it(@"iterates through all objects in the queue", ^{

			//given
			[priorityQueue addObject:@3];
			[priorityQueue addObject:@1];
			[priorityQueue addObject:@2];
			[priorityQueue addObject:@5];
			[priorityQueue addObject:@4];


			//when
			NSMutableArray *collectedObjects = [NSMutableArray array];

			for(id this in priorityQueue) {
				[collectedObjects addObject:this];
			}


			//then
			[[collectedObjects should] haveCountOf:5];
			[[collectedObjects should] contain:@1];
			[[collectedObjects should] contain:@2];
			[[collectedObjects should] contain:@3];
			[[collectedObjects should] contain:@4];
			[[collectedObjects should] contain:@5];
		});


		it(@"keeps the queue sorted after iteration", ^{

			//given
			priorityQueue = [[[ASPriorityQueue alloc] initWithComparator:^NSComparisonResult(NSSet *obj1, NSSet *obj2) {
				id first = [obj1 anyObject];
				id second = [obj2 anyObject];
				return [first compare:second];
			}] autorelease];

			[priorityQueue addObject:[NSMutableSet setWithObject:@3]];
			[priorityQueue addObject:[NSMutableSet setWithObject:@1]];
			[priorityQueue addObject:[NSMutableSet setWithObject:@2]];
			[priorityQueue addObject:[NSMutableSet setWithObject:@4]];
			[priorityQueue addObject:[NSMutableSet setWithObject:@5]];

			//when
			for(NSMutableSet *this in priorityQueue) {
				NSInteger value = [[this anyObject] integerValue];
				[this removeAllObjects];
				[this addObject:[NSNumber numberWithInt:6 - value]];
			}

			//then
			[[[priorityQueue firstObject] should] equal:[NSMutableSet setWithObject:@5]];
			[priorityQueue removeFirstObject];
			[[[priorityQueue firstObject] should] equal:[NSMutableSet setWithObject:@4]];
			[priorityQueue removeFirstObject];
			[[[priorityQueue firstObject] should] equal:[NSMutableSet setWithObject:@3]];
			[priorityQueue removeFirstObject];
			[[[priorityQueue firstObject] should] equal:[NSMutableSet setWithObject:@2]];
			[priorityQueue removeFirstObject];
			[[[priorityQueue firstObject] should] equal:[NSMutableSet setWithObject:@1]];
		});

	});






	context(@"with parameters in the init-method", ^{


		it(@"uses a custom block for comparison", ^{

			//given
			NSComparator comparator = ^NSComparisonResult(id left, id right) {
				return [right compare:left]; //reverses ordering
			};

			priorityQueue = [[ASPriorityQueue alloc] initWithComparator:comparator];

			[priorityQueue addObject:@2];
			[priorityQueue addObject:@1];
			[priorityQueue addObject:@3];

			//when
			NSArray *values = [priorityQueue allValues];

			//then
			[[values should] equal:@[@1, @2, @3]];

		});


		it(@"should properly reallocate more storage", ^{

			//given
			NSComparator comparator = ^NSComparisonResult(id left, id right) {
				return [left compare:right];
			};

			priorityQueue = [[ASPriorityQueue alloc] initWithComparator:comparator andCapacity:16];

			//when
			[[theBlock(^{
				for (int i = 0; i < 154; i++) {
					[priorityQueue addObject:@(i)];
				}
			}) shouldNot] raise];

			// then
			NSArray *values = [priorityQueue allValues];

			[[values[0] should] equal:@153];
			[[values[1] should] equal:@152];
			[[values[2] should] equal:@151];
			[[values[3] should] equal:@150];
			[[values[4] should] equal:@149];
			[[values[5] should] equal:@148];

		});

	});

});

SPEC_END