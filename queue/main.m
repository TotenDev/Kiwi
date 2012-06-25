//
//  main.m
//  queue
//
//  Created by Gabriel Pacheco on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueueManager.h"
int main(int argc, const char * argv[]) {
	NSAutoreleasePool * pool2 = [[NSAutoreleasePool alloc] init];
	RemoteProcedure *procedure = [RemoteProcedure newProcedureWithPath:@"/Users/gwdp/Desktop/teste.php" andParams:nil];
	[pool2 drain];
	int u = 0;
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];			[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"2"];			[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"2"];			[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"2"];			[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"2"];			[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"12"];			[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];			[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:@"1"];
	[pool drain];
	while (YES) {
		
	}
    return 0;
}

