//
// QueueManager.m — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
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
	[self addAndCreateIfNeeded:
	 [NSDictionary dictionaryWithObjectsAndKeys:_rp,@"procedure",_targetCallBack,@"callback", nil] 
			   queueIdentifier:queueID];
}

#pragma mark - Queue Manager
//add and create queue if needed and can (max number of threads) -- may execute too
- (void)addAndCreateIfNeeded:(NSDictionary *)queueProcedure queueIdentifier:(NSString *)queueID {
	[_queueLocker lock];
	NSMutableArray *queue ;
	//Check if already contains a queue with that ID
	if ([[_queues allKeys] containsObject:queueID]) {
		TDLog(kLogLevelQueue,nil,@"Adding task into EXISTING queue(%@)",queueID);
		queue = [_queues objectForKey:queueID]; 
	}
	else { 
		//init queue
		queue = [[[NSMutableArray alloc] init] autorelease];
		//add into queue manager
		[_queues setObject:queue forKey:queueID];
		if ([[_queues allKeys] count] <= maxNumberOfConcurrencyProcedures) {
			TDLog(kLogLevelQueue,nil,@"Creating queue(%@) and detaching new thread for it.",queueID);
			//run procedure thread
			[NSThread detachNewThreadSelector:@selector(runProcedureQueueWithID:) toTarget:self withObject:queueID];	
		}
		else { TDLog(kLogLevelQueue,nil,@"Max number of concurrency procedures reached (%i),waiting for a queue to finish to execute queue with id:%@.",maxNumberOfConcurrencyProcedures,queueID); }
	}
	//add procedure into queue
	[queue addObject:queueProcedure];
	[_queueLocker unlock];
}
//remove procedure and return next queue_id if have and not executed by max number of threads
- (NSString *)removeProcedureWithQueueID:(NSString *)queueID {
	[_queueLocker lock];
	//Check if contains a queue with that ID
	if ([[_queues allKeys] containsObject:queueID]) { 
		//Get queue with QueueID
		NSMutableArray *queue = [_queues objectForKey:queueID];

		//remove procedure
		if ([queue count] > 0) { 
			TDLog(kLogLevelQueue,nil,@"removing procedure from stack of queue(%@)",queueID);
			[queue removeObjectAtIndex:0]; 
		}
	
		//Check if stills need to be on queue manager
		if ([queue count] == 0) { 
			//Remove queue of this id and 
			[_queues removeObjectForKey:queueID]; 
			TDLog(kLogLevelQueue,nil,@"queue(%@) does NOT have procedures on queue, wipping it resources.",queueID);

			
			//Check for waiting queue
			if ([[_queues allKeys] count] >= maxNumberOfConcurrencyProcedures) { 
				NSString *str = [[[_queues allKeys] objectAtIndex:maxNumberOfConcurrencyProcedures-1] copy];
				TDLog(kLogLevelQueue,nil,@"resuming sleepy queue(%@)",str);
				[_queueLocker unlock];
				return [str autorelease]; 
			}
		}
	}
	[_queueLocker unlock];
	return nil;
}
//Check first procedure on this queue that can be executed
- (NSDictionary *)procedureOfQueueID:(NSString *)queueID {
	[_queueLocker lock];
	//Check if contains a queue with that ID
	if ([[_queues allKeys] containsObject:queueID]) { 
		NSMutableArray *queue = [_queues objectForKey:queueID];
		if ([queue count] > 0) {
			NSDictionary *retValue = [[queue objectAtIndex:0] copy];
			[_queueLocker unlock];
			return [retValue autorelease];	
		}
	}	
	[_queueLocker unlock];
	return nil ;
}

#pragma mark - Proceduring
- (void)runProcedureQueueWithID:(NSString *)queueID {
	//
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *localQueueID = [queueID retain];
	//Queue runloop
	{
		TDLog(kLogLevelQueue,nil,[NSString stringWithFormat:@"now running deticated thread for queue(%@)",localQueueID]);
		BOOL hasJob = YES ;
		while (hasJob) {
			//
			NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
			NSDictionary *jobDict = [self procedureOfQueueID:localQueueID];
			if (jobDict) {
				//Auxs
				RemoteProcedure *procedure = [jobDict objectForKey:@"procedure"];
				NSString *response ;
				id targetCallback = [jobDict objectForKey:@"callback"];
				TDLog(kLogLevelQueue,nil,[NSString stringWithFormat:@"will run procedure:%@ in thread of queue(%@)",procedure,queueID]);
				//Execute procedure
				@try { 
					//Execute
					[procedure executeWithResponse:&response]; 
					//Check if need callback
					if (targetCallback && [targetCallback respondsToSelector:@selector(response:)]) {
						[targetCallback performSelectorOnMainThread:@selector(response:) withObject:response waitUntilDone:YES];
					}
					//release retained response
					[response release];
				}
				//Exception on execution
				@catch (NSException *exception) { TDLog(kLogLevelQueue,nil,[NSString stringWithFormat:@"procedure:%@ in thread of queue(%@) EXIT with exception:%@\nSkiping to next procedure.",procedure,queueID,exception]); }
				//remove procedure of this queue
				jobDict = nil;
				NSString *nextQueueID = [self removeProcedureWithQueueID:queueID];
				//Check for waiting queues
				if (nextQueueID) { [self runProcedureQueueWithID:nextQueueID]; }
			}
			else hasJob = NO ;
			[pool2 drain];
		}
	}
	//Cleanup
	[localQueueID release];
	[pool drain];
}
@end