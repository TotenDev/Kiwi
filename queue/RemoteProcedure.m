//
// RemoteProcedure.m — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
//

#import "RemoteProcedure.h"
#import "TDLog.h"

//Main Implementation
@implementation RemoteProcedure
#pragma mark - Environment Methods
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
- (NSString *)description {
	return [NSString stringWithFormat:@"[%@<0x%x>] command:%@ filePath:%@ params:%@",NSStringFromClass([self class]),self,[self executionCommand],filePath,params];
}

#pragma mark - Main Methods
- (void)executeWithResponse:(NSString **)response {
	NSAutoreleasePool * pooler = [[NSAutoreleasePool alloc] init];
	NSTask *theTask; NSPipe *procedureOutput,*procedureOutputError; NSString *whereExecute; NSArray *procedureParams ;
	//Get execution ivars
	{
		whereExecute = [[NSString stringWithString:[self executionCommand]] retain];
		procedureOutput = [NSPipe pipe];
		procedureOutputError = [NSPipe pipe];
		procedureParams = [(params ? [NSArray arrayWithObjects:filePath,params,nil] : [NSArray arrayWithObject:filePath]) retain];
		TDLog(kLogLevelProcedures,nil,@"Starting Procedure");
	}
	//Task
	{
		//Task it
		theTask = [[NSTask alloc]init];
		[theTask setLaunchPath:whereExecute];
		[theTask setArguments:procedureParams];
		[theTask setStandardOutput:procedureOutput];
		[theTask setStandardError:procedureOutputError];
		[theTask launch];
		[theTask waitUntilExit];
	}
	//Read pipe
	{
		NSFileHandle *readHandleOut = [procedureOutput fileHandleForReading];
		NSData *readDataOut = [readHandleOut readDataToEndOfFile];
		*response = [[NSString alloc] initWithData:readDataOut encoding:NSUTF8StringEncoding];
		TDLog(kLogLevelProcedures,nil,@"Procedure finished with stdout: %@",*response);
	}
	//Error Pipe
	{
		NSFileHandle *readHandleError = [procedureOutput fileHandleForReading];
		NSData *readDataError = [readHandleError readDataToEndOfFile];
		NSString *error = [[NSString alloc] initWithData:readDataError encoding:NSUTF8StringEncoding];
		if (error && [error length] > 0) { TDLog(kLogLevelProcedures,nil,@"Procedure stderr: %@",error); }
		[error release];
	}
	//clean jobs
	{
		[procedureParams release];
		[whereExecute release];
		[theTask release];
		[pooler drain];
	}
}

#pragma mark - Helpers
//required medium processing and IO, so use carefull
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
	NSString *retValue = [NSString stringWithString:finder];
	[finder release];
	return retValue;
}
@end
