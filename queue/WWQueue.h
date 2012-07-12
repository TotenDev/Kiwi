//
// WWQueue.h — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
//

#import <Foundation/Foundation.h>

@interface WWQueue : NSObject {
	NSRecursiveLock *locker ;	
	NSMutableArray *queueArray;	
}
//
+ (WWQueue *)newQueue ;
//Add object in queue, and return if can execute now
- (BOOL)addDictionaryInQueue:(NSDictionary *)queueDict ;
//Remove object in queue and return next one
- (NSDictionary *)nextInQueue ;
//Remove all objects in queue AND return last one in queue
- (NSDictionary *)lastInQueue ;
@end
