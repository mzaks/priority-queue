#import "Kiwi.h"
#import "ASPriorityQueue.h"

SPEC_BEGIN(ASPriorityQueueSpec)


describe(@"ASPriorityQueue", ^{
	__block ASPriorityQueue *priorityQueue;


	context(@"initialized with the default init-method", ^{

		beforeEach(^{
			priorityQueue = [[ASPriorityQueue alloc] init];
		});


		//array sort: 23.57
		//heap sort with NSArray: 21.26
		//heap sort with c array: 13.07
		//heap sort with c array and memmove: 13.46
		//heap sort with c array without ARC: 7.504

//		it(@"should be fast", ^{
//
//			NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
//			for (int i = 0; i < 5000000; i++) {
//				priorityQueue = [[ASPriorityQueue alloc] init];
//				[priorityQueue addObject:@3];
//				[priorityQueue addObject:@1];
//				[priorityQueue addObject:@2];
//				[priorityQueue removeFirstObject];
//			}
//			NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
//			NSTimeInterval timeDelta = endTime - startTime;
//
//			[[theValue(timeDelta) should] equal:theValue(1)];
//		});


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
			BOOL containsFrob = [priorityQueue containsObject:@"frob"];

			//then
			[[theValue(containsFrob) should] beYes];
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


		it(@"calls a block with every object", ^{
			//TODO implement me
			//should still be a heap after this operation
		});


	});


	context(@"with parameters in the init-method", ^{


		it(@"uses a custom block for comparison", ^{

			//given
			NSComparator comparator = ^NSComparisonResult(id left, id right) {
				return [right compare:left];
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
				return [right compare:left];
			};

			priorityQueue = [[ASPriorityQueue alloc] initWithComparator:comparator andCapacity:16];

			//then
			[[theBlock(^{
				for (int i = 0; i < 154; i++) {
					[priorityQueue addObject:@(i)];
				}
			}) shouldNot] raise];

		});

	});





});

SPEC_END