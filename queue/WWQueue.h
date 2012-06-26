//
//  WWQueue.h
//  WWDCounter
//
//  Created by Gabriel Pacheco on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWQueue : NSObject {
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
