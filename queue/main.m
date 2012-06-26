//
//  main.m
//  queue
//
//  Created by Gabriel Pacheco on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#warning TODO
//Logging write
//Response mode
//Config File
	//thread count
	//key queue
		//msg types (white card too)
	//log file
//get initial line of procedure file
//Help

#import <Foundation/Foundation.h>
#import "QueueManager.h"
#import "MessageCenter.h"
#import "TDLog.h"
//App Definitions
#define KiwiVersion @"0.0.2a"
#define KiwiVersionCmds [NSArray arrayWithObjects:@"-v",@"-V",@"--version",@"--Version",nil]
#define KiwiConfigFileCmds [NSArray arrayWithObjects:@"-c",@"-C",@"--config",@"--Config",nil]

//Declarations
void runQueue(void) ; //Run queue app
void scanCommands (int argc,const char *argv[]) ; //scan for basic commands into kiwi
static NSString * executablePath(void) ; //executable path
//Static ivars
static NSString *executionPath = NULL ;
static NSString *executableName = NULL ;
static NSString *configurationFile = NULL ;
//App
int main(int argc, const char * argv[]) {
	//Pool
	NSAutoreleasePool *pooler = [[NSAutoreleasePool alloc] init];
	//Initial code
	executionPath = executablePath();
	if (executionPath) {
		executionPath = [[NSString alloc] initWithString:executionPath];//retain
		executableName = [[[executionPath pathComponents] lastObject] copy];//retain
		{
			//Scanf for normal command
			scanCommands(argc,argv);
			//Run queue
			runQueue();
		}
		//Release
		[executionPath release];
		[executableName release];
		[configurationFile release];
		[pooler drain];
		return EXIT_SUCCESS;
	}
	else {
		TDLog(kLogLevelStdout,nil,@"Couldn't get executable path! Not running on linux ?");
		TDLog(kLogLevelStdout,nil,@"Aborting now.");
		[pooler drain];
		return EXIT_FAILURE;
	}
}





#pragma mark - Ultils

//scan for basic commands into kiwi
void scanCommands (int argc,const char *argv[]) {
	while(argc--) {
		NSAutoreleasePool *babyPool = [[NSAutoreleasePool alloc] init];
		NSString * chk = [NSString stringWithFormat:@"%s",*argv++];//check str
		//Auxs
		BOOL configFile = NO ;
		//Version check
		if ([KiwiVersionCmds containsObject:chk]) { 
			TDLog(kLogLevelStdout,nil,KiwiVersion);
			[babyPool drain];//final pool
			exit(EXIT_SUCCESS); //bye
		}
		//config file
		else if ([KiwiConfigFileCmds containsObject:chk] || configFile) { 
			if (configFile) { 
				configurationFile = [[NSString alloc] initWithString:chk];
				TDLog(kLogLevelStdout,nil,@"Will run queue with config file:%@",chk); 
			}
			configFile = !configFile ;
		}
		[babyPool drain];
	}
	if (!configurationFile) {
		TDLog(kLogLevelStdout,nil,@"Configuration file not found. Aborting NOW.");
		exit(EXIT_FAILURE);
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

//executable path
static NSString * executablePath(void){
	char buf[1024];
	/* The manpage says it won't null terminate.  Let's zero the buffer. */
	memset(buf, 0, sizeof(buf));
	/* Note we use sizeof(buf)-1 since we may need an extra char for NUL. */
	if (readlink("/proc/self/exe", buf, sizeof(buf)-1)) { return NULL; }
	NSString *rtVal = [NSString stringWithFormat:@"%s",buf];
	free(buf);
	return rtVal;
}