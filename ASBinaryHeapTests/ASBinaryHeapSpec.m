#import "Kiwi.h"
#import "ASBinaryHeap.h"

SPEC_BEGIN(ASBinaryHeapSpec)


describe(@"ASBinaryHeap", ^{
	__block ASBinaryHeap *binaryHeap;

	beforeEach(^{
		binaryHeap = [[ASBinaryHeap alloc] init];
	});


	it(@"creates an empty heap", ^{

		//when
		id firstObject = [binaryHeap firstObject];

		//then
		[firstObject shouldBeNil];

    });


	it(@"stores a single object", ^{

		//given
		[binaryHeap addObject:@1];

		//when
		id firstObject = [binaryHeap firstObject];

		//then
		[[firstObject should] equal:@1];
	});


	it(@"always returns the 'smallest' object as the first object", ^{

		//given
		[binaryHeap addObject:@3];
		[binaryHeap addObject:@1];
		[binaryHeap addObject:@2];

		//when
		id firstObject = [binaryHeap firstObject];

		//then
		[[firstObject should] equal:@1];
	});


	it(@"should by default us 'compare:' for comparison", ^{

		//given
		NSNumber *one = [NSNumber nullMockWithName:@"one"];
		NSNumber *two = [NSNumber nullMockWithName:@"two"];
		NSNumber *three = [NSNumber nullMockWithName:@"three"];

		//expectations
		[[one should] receive:@selector(compare:)];
		[[three should] receive:@selector(compare:)];

		//when
		[binaryHeap addObject:three];
		[binaryHeap addObject:one];
		[binaryHeap addObject:two];

		[binaryHeap firstObject];

	});




});

SPEC_END