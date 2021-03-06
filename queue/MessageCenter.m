//
// MessageCenter.m — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
//

#import "MessageCenter.h"
#import "TDLog.h"
#import "RemoteProcedure.h"
#import "QueueManager.h"
#import "Config.h"

@implementation MessageCenter

- (void)runLoop {
	TDLog(kLogLevelMessageCenter,nil,@"Starting MessageCenter runloop");
	static key_t key = ipcQueueKey;  
	while (YES) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		int msqid;  
		struct msgbuf rcvbuffer; 
		if ((msqid = msgget(key, 0777)) >= 0) {
			size_t msgSize = 0;
//			if ((msgSize=msgrcv(msqid, &rcvbuffer, sizeof(rcvbuffer.mtext), 1, IPC_NOWAIT)) != -1) -- LESS MEMORY CPU - 5 msg/sec
//			while ((msgSize=msgrcv(msqid, &rcvbuffer, sizeof(rcvbuffer.mtext), 1, IPC_NOWAIT)) != -1) -- MORE MEMORY CPU - 10000 msg/sec
			//Receive an answer of message type 1.  
#if optimizedMode
			if ((msgSize=msgrcv(msqid, &rcvbuffer, sizeof(rcvbuffer.mtext), 1, IPC_NOWAIT)) != -1) {
#else
			while ((msgSize=msgrcv(msqid, &rcvbuffer, sizeof(rcvbuffer.mtext), 1, IPC_NOWAIT)) != -1) {
#endif
				NSString *messageStr = [NSString stringWithFormat:@"%s",rcvbuffer.mtext];
				TDLog(kLogLevelMessageCenter,nil,@"Message recived:%@",messageStr);
				NSError *msgError = nil;
				NSArray *msgCommands = nil;
				[[self class] checkMessage:messageStr error:&msgError commands:&msgCommands];
				//Check if errored
				if (msgError) {  TDLog(kLogLevelMessageCenter,nil,@"Message decoding errored:%@",msgError);  }
				else if (!msgCommands) { TDLog(kLogLevelMessageCenter,nil,@"Message commands appear to be NULL :("); }
				//Add procedure into queue
				else {
					//0 - QUEUE ID
					//1 - RP Path
					//2 - Paramas
					RemoteProcedure *procedure = [RemoteProcedure newProcedureWithPath:[msgCommands objectAtIndex:1] andParams:([msgCommands count]>2 ? [msgCommands objectAtIndex:2] : nil)];
					[[QueueManager sharedQueueManager] addIntoQueueWithRemoteProcedure:procedure callBack:nil queueIdentifier:[msgCommands objectAtIndex:0]];	
					[procedure release];
				}
			}	
		}		
		[NSThread sleepForTimeInterval:.1f];
		[pool drain];
	}
		

	TDLog(kLogLevelMessageCenter,nil,@"Finishing MessageCenter runloop");
}

#pragma mark - Private
//Objects are returned in autorelease !
+ (void)checkMessage:(NSString *)message error:(NSError **)error commands:(NSArray **)commands {
	//Get message and filter it
	NSString *messageString = [NSString stringWithString:message];
	[self initialMessageFilter:&messageString withError:error]; // initial filter for php style (until now 0.0.21)
	if (*error) { return; }
	TDLog(kLogLevelQueue,nil,@"decoded message:%@",messageString);
	//Try to get commands
	NSArray *tmp = [messageString componentsSeparatedByString:@"||"];
	if ([tmp count] < 2) {
		*error = [NSError errorWithDomain:@"MessageCenter error domain" code:01 userInfo:
				  [NSDictionary dictionaryWithObject:
				   [NSString stringWithFormat:@"Commands counts(%i) in under required",[tmp count]] 
											  forKey:NSLocalizedFailureReasonErrorKey]];
		return;
	}
	else if ([tmp count] > 3) {
		NSMutableArray *newCommands = [[NSMutableArray alloc] init];
		[newCommands addObject:[tmp objectAtIndex:0]];
		[newCommands addObject:[tmp objectAtIndex:1]];
		//Format additional command into one
		NSMutableString *lastCommand = [[NSMutableString alloc] init];
		for (int i = 0;i < [tmp count]-2;i++) { [lastCommand appendFormat:@"%@",[tmp objectAtIndex:i+2]]; }
		[newCommands addObject:lastCommand];
		[lastCommand release];
		//Set new commands array
		tmp = [NSArray arrayWithArray:newCommands];
		[newCommands release];
	}
	//3 commands
	else { /*normal, nothing to do*/ }
	//Commons filters
	{
		//Get last command
		NSMutableArray *retValue = [NSMutableArray new];
		[retValue addObjectsFromArray:[tmp subarrayWithRange:NSMakeRange(0, [tmp count]-1)]];
		//Check for last command \'\ cases
		NSString *lastCommand = [tmp lastObject];
		if ([[lastCommand substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"'"] && 
			[[lastCommand substringWithRange:NSMakeRange([lastCommand length]-1, 1)] isEqualToString:@"'"]) {
			[retValue addObject:[lastCommand substringWithRange:NSMakeRange(1, [lastCommand length]-2)]];
		}
		else { [retValue addObject:lastCommand]; }
		//set commands value
		*commands = [NSArray arrayWithArray:retValue];
		[retValue release];
	}
	return;
}
//Initial message filter
//Objects are returned in autorelease !
+ (void)initialMessageFilter:(NSString **)messageString withError:(NSError **)error {
	//Get real message
	int state = 0; //1 finding, 2 finded, 3 done,0 not finded
	NSString *initialLenght = nil ;
	for (int i = 0; i < [*messageString length]; i++) {
		switch (state) {
			case 0:{
				if ([[*messageString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@":"]) {
					*messageString = [*messageString substringWithRange:NSMakeRange(1, [*messageString length]-1)];
					state = 1;
				}
				else { *messageString = [*messageString substringWithRange:NSMakeRange(1, [*messageString length]-1)]; }		
			}break;
			case 1:{
				if ([[*messageString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@":"]) {
					*messageString = [*messageString substringWithRange:NSMakeRange(1, [*messageString length]-1)];
					state = 2;
				}
				else { 
					initialLenght = (initialLenght ? [initialLenght stringByAppendingString:[*messageString substringWithRange:NSMakeRange(0, 1)]] : [*messageString substringWithRange:NSMakeRange(0, 1)]);
					*messageString = [*messageString substringWithRange:NSMakeRange(1, [*messageString length]-1)]; 
				}
			}break;
			case 2:{
				if ([*messageString length] > [initialLenght intValue]) {
					*messageString = [*messageString substringWithRange:NSMakeRange(1, [initialLenght intValue])];
					state = 3;
				}
			}break;
			default:
				break;
		}
		if (state==3) { break; }
	}
	if (state != 3) {
		*error = [NSError errorWithDomain:@"MessageCenter error domain" code:02 userInfo:
				  [NSDictionary dictionaryWithObject:
				   [NSString stringWithFormat:@"Inconsistency on message, could format message, stopped in state %i.",state] 
											  forKey:NSLocalizedFailureReasonErrorKey]];
		return;
	}
}
@end
