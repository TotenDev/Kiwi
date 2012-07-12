//
// WWQueue.m — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
//

#import "WWQueue.h"


//Main Implementation
@implementation WWQueue
//New queue
+ (WWQueue *)newQueue { return [[self alloc] init]; }
//Init
- (id)init {
	if ((self = [super init])) {
		//queue array
		queueArray = [[NSMutableArray alloc] init];
		locker = [[NSRecursiveLock alloc] init];
	}
	//return baby
	return self;
}
//hm....
- (void)dealloc {
	[super dealloc];
	[locker release];
	[queueArray release];
}
#pragma mark - Real queue
//Add object in queue, and return if can execute now
- (BOOL)addDictionaryInQueue:(NSDictionary *)queueDict {
	[locker lock];
	//Add it
	[queueArray addObject:[queueDict copy]];
	//Return if can execute now
	BOOL response = ([queueArray count] == 1 ? YES : NO);
	//
	[locker unlock];
	return response;
}
//Remove object in queue and return next one
- (NSDictionary *)nextInQueue {
	[locker lock];
	//Remove object if can
	if ([queueArray count] != 0) { 
		NSDictionary *d = [queueArray objectAtIndex:0];
		[queueArray removeObjectAtIndex:0]; 
		[d release];
	}
	//Return if available
	id response = ([queueArray count] != 0 ? [[queueArray objectAtIndex:0] copy] : nil);
	[locker unlock];
	return [response autorelease];
}
//Remove all objects in queue AND return last one in queue
- (NSDictionary *)lastInQueue {
	[locker lock];
	//Return if available
	NSDictionary *retValue = ([queueArray count] > 1 ? [[queueArray lastObject] copy] : nil);
	
	//Remove all objects
	[queueArray makeObjectsPerformSelector:@selector(release) withObject:nil];
	[queueArray removeAllObjects];
	[locker unlock];
	//return value
	return [retValue autorelease];
}
@end
