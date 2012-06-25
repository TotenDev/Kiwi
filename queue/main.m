//
//  main.m
//  queue
//
//  Created by Gabriel Pacheco on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueueManager.h"
#import "MessageCenter.h"
int main(int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	MessageCenter *center = [[MessageCenter alloc] init];
	[center runLoop];
	[center release];
	[pool drain];
    return 0;
}

