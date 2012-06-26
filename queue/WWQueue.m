//
//  WWQueue.m
//  WWDCounter
//
//  Created by Gabriel Pacheco on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WWQueue.h"


//Main Implementation
@implementation WWQueue
@synthesize queueArray;
//New queue
+ (WWQueue *)newQueue { return [[self alloc] init]; }
//Init
- (id)init {
	if ((self = [super init])) {
		//queue array
		self.queueArray = [[NSMutableArray alloc] init];
		locker = [[NSRecursiveLock alloc] init];
	}
	//return baby
	return self;
}
//hm....
- (void)dealloc {
	[super dealloc];
	[locker release];
	[self.queueArray release];
}
#pragma mark - Real queue
//Add object in queue, and return if can execute now
- (BOOL)addDictionaryInQueue:(NSDictionary *)queueDict {
	[locker lock];
	//Add it
	[self.queueArray addObject:[queueDict retain]];
	//Return if can execute now
	BOOL response = ([self.queueArray count] == 1 ? YES : NO);
	//
	[locker unlock];
	return response;
}
//Remove object in queue and return next one
- (NSDictionary *)nextInQueue {
	[locker lock];
	//Remove object if can
	if ([self.queueArray count] != 0) { 
		NSDictionary *d = [self.queueArray objectAtIndex:0];
		[self.queueArray removeObjectAtIndex:0]; 
		[d release];
	}
	//Return if available
	id response = ([self.queueArray count] != 0 ? [[self.queueArray objectAtIndex:0] copy] : nil);
	[locker unlock];
	return response;
}
//Remove all objects in queue AND return last one in queue
- (NSDictionary *)lastInQueue {
	[locker lock];
	//Return if available
	NSDictionary *retValue = ([self.queueArray count] > 1 ? [[self.queueArray lastObject] copy] : nil);
	
	//Remove all objects
	[self.queueArray makeObjectsPerformSelector:@selector(release) withObject:nil];
	[self.queueArray removeAllObjects];
	[locker unlock];
	//return value
	return retValue;
}
@end
