//
// QueueManager.h — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
//

#import <Foundation/Foundation.h>
#import "RemoteProcedure.h"

@interface QueueManager : NSObject {
	NSMutableDictionary *_queues ;
	NSRecursiveLock *_queueLocker ;
}
#pragma mark - Public Methods
+ (QueueManager *)sharedQueueManager ;
- (void)addIntoQueueWithRemoteProcedure:(RemoteProcedure *)_rp callBack:(id)_targetCallBack queueIdentifier:(NSString *)queueID ;

#pragma mark - Queue Manager
- (void)addAndCreateIfNeeded:(NSDictionary *)queueProcedure queueIdentifier:(NSString *)queueID ; //add and create queue if needed and can (max number of threads) -- may execute too
- (NSString*)removeProcedureWithQueueID:(NSString *)queueID ; //remove procedure and return next queue_id if have and not executed by max number of threads
- (NSDictionary *)procedureOfQueueID:(NSString *)queueID ; //Check first procedure on this queue that can be executed
#pragma mark - Proceduring
- (void)runProcedureQueueWithID:(NSString *)queueID ;
@end
