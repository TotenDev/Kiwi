//
//  RemoteProcedure.m
//  queue
//
//  Created by Gabriel Pacheco on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteProcedure.h"
#import "TDLog.h"

//Main Implementation
@implementation RemoteProcedure
+ (RemoteProcedure *)newProcedureWithPath:(NSString *)path andParams:(NSString *)params {
	return [[self alloc] initProcedureWithPath:path andParameters:params];
}
- (id)initProcedureWithPath:(NSString *)_filePath andParameters:(NSString *)_params {
	if ((self = [super init])) {
		params = (_params ? [_params copy] : nil);
		filePath = (_filePath ? [_filePath copy] : nil );
		TDLog(kLogLevelProcedures,nil,@"New procedure with filepath:%@ and params:%@",filePath,params);
	}
	return self;
}
- (void)dealloc {
	if (params)[params release];
	if (filePath)[filePath release];
	[super dealloc];
}
- (void)executeWithResponse:(NSString **)response {
	NSAutoreleasePool * pooler = [[NSAutoreleasePool alloc] init];
		//Get execution 
		NSString *whereExecute = [[NSString stringWithString:[self executionCommand]] retain];
		NSPipe *procedureOutput = [NSPipe pipe];
		NSPipe *procedureOutputError = [NSPipe pipe];
		NSArray *procedureParams = [(params ? [NSArray arrayWithObjects:filePath,params,nil] : [NSArray arrayWithObject:filePath]) retain];
		TDLog(kLogLevelProcedures,nil,@"Starting Procedure");
		//Task it
		NSTask *theTask = [[NSTask alloc]init];
		[theTask setLaunchPath:whereExecute];
		[theTask setArguments:procedureParams];
		[theTask setStandardOutput:procedureOutput];
		[theTask setStandardError:procedureOutputError];
		[theTask launch];
		[theTask waitUntilExit];
		//Read pipe
		NSFileHandle *readHandleOut = [procedureOutput fileHandleForReading];
		NSData *readDataOut = [readHandleOut readDataToEndOfFile];
		*response = [[NSString alloc] initWithData:readDataOut encoding:NSUTF8StringEncoding];
		TDLog(kLogLevelProcedures,nil,@"Procedure finished with response:%@",*response);
		//Error Pipe
		NSFileHandle *readHandleError = [procedureOutput fileHandleForReading];
		NSData *readDataError = [readHandleError readDataToEndOfFile];
		NSString *error = [[NSString alloc] initWithData:readDataError encoding:NSUTF8StringEncoding];
		if (error && readDataError) { TDLog(kLogLevelProcedures,nil,@"Procedure finished with error:%@",error); }
		[error release];
		//clean jobs
		[procedureParams release];
		[whereExecute release];
		[theTask release];
	[pooler release];
}
#pragma mark - Helpers
- (NSString *)executionCommand {
	NSFileHandle *reader = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
	NSData *readData = [reader readDataOfLength:2048*4]; //first line
	NSString* dataString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
	NSMutableString *finder = [[NSMutableString alloc] init];
	int state = 0;
	for (int i = 0; i < [dataString length]; i++) {
		switch (state) {
			case 0: {
				if ([[dataString substringWithRange:NSMakeRange(i,1)] isEqualToString:@"#"]) {
					state = 1;
				}
			} break;
			case 1: {
				if (![[dataString substringWithRange:NSMakeRange(i,1)] isEqualToString:@"#"]) {
					[finder appendString:[dataString substringWithRange:NSMakeRange(i,1)]];
				}
				else if ([finder length]>0){ state = 2;}
			} break;
			default: break;
		}
		if (state == 2) { break; }
	}
	[dataString release];
	TDLog(kLogLevelProcedures,nil,@"Execution commnad:%@",finder);
	NSString *retValue = [NSString stringWithString:finder];
	[finder release];
	return retValue;
}
@end
