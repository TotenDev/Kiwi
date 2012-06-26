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
//New queue
+ (WWQueue *)newQueue { return [[self alloc] init]; }
//Init
- (id)init {
	if ((self = [super init])) {
		//queue array
		queueArray = [[NSMutableArray alloc] init];
	}
	//return baby
	return self;
}
//hm....
- (void)dealloc {
	[super dealloc];
	[queueArray release];
}
#pragma mark - Real queue
//Add object in queue, and return if can execute now
- (BOOL)addDictionaryInQueue:(NSDictionary *)queueDict {
	//Add it
	[queueArray addObject:queueDict];
	//Return if can execute now
	return ([queueArray count] == 1 ? YES : NO);
}
//Remove object in queue and return next one
- (NSDictionary *)nextInQueue {
	//Remove object if can
	if ([queueArray count] != 0) { [queueArray removeObjectAtIndex:0]; }
	//Return if available
	return ([queueArray count] != 0 ? [queueArray objectAtIndex:0] : nil);
}
//Remove all objects in queue AND return last one in queue
- (NSDictionary *)lastInQueue {
	//Return if available
	NSDictionary *retValue = [([queueArray count] > 1 ? [queueArray lastObject] : nil) copy];
	
	//Remove all objects
	[queueArray removeAllObjects];
	
	//return value
	return retValue;
}
@end
