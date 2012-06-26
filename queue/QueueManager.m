//
//  QueueManager.m
//  queue
//
//  Created by Gabriel Pacheco on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QueueManager.h"
#import "TDLog.h"
#import "Config.h"



//Main Imeplementation
@implementation QueueManager
//
static QueueManager *_sharedQueueManager = nil ;
+ (QueueManager *)sharedQueueManager {
	@synchronized ([QueueManager class]){
		if (!_sharedQueueManager) {
			_sharedQueueManager = [[self alloc] init];
		}
		return _sharedQueueManager;
	}
	return nil ;
}
- (id)init {
	if ((self = [super init])) {
		//
		_queues = [[NSMutableDictionary alloc] init];
		_queueLocker = [[NSRecursiveLock alloc] init];
		TDLog(kLogLevelQueue,nil,@"Queue Manager has started");
	}
	return self;
}
- (void)dealloc {
	[super dealloc];
	[_queues removeAllObjects];
	[_queues release];
}

#pragma mark - Public Methodss
- (void)addIntoQueueWithRemoteProcedure:(RemoteProcedure *)_rp callBack:(id)_targetCallBack queueIdentifier:(NSString *)queueID {	
	TDLog(kLogLevelQueue,nil,@"new procedure with id:%@ has been requested",queueID);
	[self addAndCreateIfNeeded:
	 [NSDictionary dictionaryWithObjectsAndKeys:_rp,@"procedure",_targetCallBack,@"callback", nil] 
			   queueIdentifier:queueID];
}

#pragma mark - Queue Manager
- (void)addAndCreateIfNeeded:(NSDictionary *)queueProcedure queueIdentifier:(NSString *)queueID {
	[_queueLocker lock];
	NSMutableArray *queue ;
	//Check if already contains a queue with that ID
	if ([[_queues allKeys] containsObject:queueID]) {
		TDLog(kLogLevelQueue,nil,@"Adding procedure into existing queue with id:%@",queueID);
		queue = [_queues objectForKey:queueID]; 
	}
	else { 
		//init queue
		queue = [[[NSMutableArray alloc] init] autorelease];
		//add into queue manager
		[_queues setObject:queue forKey:queueID];
		if ([[_queues allKeys] count] <= maxNumberOfConcurrencyProcedures) {
			TDLog(kLogLevelQueue,nil,@"Creating queue with id:%@ and detaching new thread for it",queueID);
			//run procedure thread
			[NSThread detachNewThreadSelector:@selector(runProcedureQueueWithID:) toTarget:self withObject:queueID];	
		}
		else {
			TDLog(kLogLevelQueue,nil,@"Max number of concurrency procedures reached (%i),waiting for a queue to finish to execute queue with id:%@.",maxNumberOfConcurrencyProcedures,queueID);
		}
	}
	//add procedure into queue
	[queue addObject:queueProcedure];
	[_queueLocker unlock];
}
- (NSString *)removeProcedureWithQueueID:(NSString *)queueID {
	[_queueLocker lock];
	//Check if contains a queue with that ID
	if ([[_queues allKeys] containsObject:queueID]) { 
		NSMutableArray *queue = [_queues objectForKey:queueID];
		//remove proceude
		if ([queue count] > 0) { 
			TDLog(kLogLevelQueue,nil,@"removing procedure from stack of queue with id:%@",queueID);
			[queue removeObjectAtIndex:0]; 
		}
		//Check if stills need to be on queue manager
		if ([queue count] == 0) { 
			[_queues removeObjectForKey:queueID]; 
			TDLog(kLogLevelQueue,nil,@"queue with id:%@ does not have procedures on queue, removing thread of it.",queueID);
			//Check for waiting queue
			if ([[_queues allKeys] count] >= maxNumberOfConcurrencyProcedures) { 
				NSString *str = [[[_queues allKeys] objectAtIndex:maxNumberOfConcurrencyProcedures-1] copy];
				TDLog(kLogLevelQueue,nil,@"resuming queue with id:%@",str);
				[_queueLocker unlock];
				return [str autorelease]; 
			}
		}
	}
	[_queueLocker unlock];
	return nil;
}
- (NSDictionary *)procedureOfQueueID:(NSString *)queueID {
	[_queueLocker lock];
	//Check if contains a queue with that ID
	if ([[_queues allKeys] containsObject:queueID]) { 
		NSMutableArray *queue = [_queues objectForKey:queueID];
		if ([queue count] > 0) {
			NSDictionary *retValue = [queue objectAtIndex:0];
			[_queueLocker unlock];
			return retValue;	
		}
		else { [_queueLocker unlock]; }
	}	
	else { [_queueLocker unlock]; }
	return nil ;
}
#pragma mark - Proceduring
- (void)runProcedureQueueWithID:(NSString *)queueID {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	BOOL hasJob = YES ;
	TDLog(kLogLevelQueue,nil,@"now running deticated thread for queue with id:%@",queueID);
	while (hasJob) {
		//
		NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
		NSDictionary *jobDict = [self procedureOfQueueID:queueID];
		if (jobDict) {
			TDLog(kLogLevelQueue,nil,@"will run procedure:%@ in thread of queue with id%@:",jobDict,queueID);
			RemoteProcedure *procedure = [jobDict objectForKey:@"procedure"];
			NSString *response ;
			id targetCallback = [jobDict objectForKey:@"callback"];
			//Execute procedure
			@try { 
				[procedure executeWithResponse:&response]; 
				//Check if need callback
				if (targetCallback && [targetCallback respondsToSelector:@selector(response:)]) {
					[targetCallback performSelectorOnMainThread:@selector(response:) withObject:response waitUntilDone:YES];
				}
				[response release];
			}
			@catch (NSException *exception) { TDLog(kLogLevelQueue,nil,@"procedure:%@ in thread of queue with id:%@ exit with exception:%@\nSkiping to next procedure.",jobDict,queueID,exception); }
			//remove procedure of this queue
			jobDict = nil;
			NSString *nextQueueID = [self removeProcedureWithQueueID:queueID];
			//Check for waiting queues
			if (nextQueueID) { [self runProcedureQueueWithID:nextQueueID]; }
		}
		else hasJob = NO ;
		[pool2 drain];
	}
	[pool drain];
}

@end
