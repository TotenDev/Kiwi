//
//  main.m
//  queue
//
//  Created by Gabriel Pacheco on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#warning TODO
//Response mode
//get initial line of procedure file
//Help

#import <Foundation/Foundation.h>
#import "QueueManager.h"
#import "MessageCenter.h"
#import "TDLog.h"
//App Definitions
#define KiwiVersion @"0.0.2a"
#define KiwiVersionCmds [NSArray arrayWithObjects:@"-v",@"-V",@"--version",@"--Version",nil]

//Declarations
void runQueue(void) ; //Run queue app
void scanCommands (int argc,const char *argv[]) ; //scan for basic commands into kiwi
static NSString * executablePath(void) ; //executable path
//App
int main(int argc, const char * argv[]) {
	//Pool
	NSAutoreleasePool *pooler = [[NSAutoreleasePool alloc] init];
	//Initial code
	//Scanf for normal command
	scanCommands(argc,argv);
	//Run queue
	runQueue();
	[pooler drain];
	return EXIT_SUCCESS;
}





#pragma mark - Ultils

//scan for basic commands into kiwi
void scanCommands (int argc,const char *argv[]) {
	while(argc--) {
		NSAutoreleasePool *babyPool = [[NSAutoreleasePool alloc] init];
		NSString * chk = [NSString stringWithFormat:@"%s",*argv++];//check str
		//Version check
		if ([KiwiVersionCmds containsObject:chk]) { 
			TDLog(kLogLevelStdout,nil,@"Kiwi version:%@\nCopyright:TotenDev LTDA.",KiwiVersion);
			[babyPool drain];//final pool
			exit(EXIT_SUCCESS); //bye
		}
		[babyPool drain];
	}
}

//Run queue app
void runQueue(void) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		MessageCenter *center = [[MessageCenter alloc] init];
			[center runLoop];
		[center release];
	[pool drain];
}