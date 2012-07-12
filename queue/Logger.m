//
// Logger.m — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
//

#import "Logger.h"
#import "WWQueue.h"
#import "Config.h"

@implementation Logger


//write log
+ (void)writeLog:(NSString *)logString {
	[self _queueWriteLog:logString];
}


#pragma mark - Queueing
//Status shared writer queue
static WWQueue *__sharedLogQueue = nil ;
static NSRecursiveLock *__sharedLogLocker = nil ;
//shared writer queue
+ (WWQueue *)_sharedLogWriterQueue {
	@synchronized ([Logger class]){
		if (!__sharedLogQueue) {
			__sharedLogQueue = [WWQueue newQueue];
		}
		return __sharedLogQueue;
	}
	return nil ;
}
+ (NSRecursiveLock *)_sharedLogLocker {
	@synchronized ([Logger class]){
		if (!__sharedLogLocker) {
			__sharedLogLocker = [[NSRecursiveLock alloc] init];
		}
		return __sharedLogLocker;
	}
	return nil ;	 
}

























#pragma mark - Writer
//queue write log
+ (void)_queueWriteLog:(NSString *)logString {
	[[self _sharedLogLocker] lock];
	if ([[self _sharedLogWriterQueue] addDictionaryInQueue:[NSDictionary dictionaryWithObject:logString forKey:@"1"]]) {
		[self _appendLogText:logString];
	}
	[[self _sharedLogLocker] unlock];
}
//append string into file
+ (void)_appendLogText:(NSString *)text {
	[[self _sharedLogLocker] lock];
	{
		// NSFileHandle won't create the file for us, so we need to check to make sure it exists
		if (![[NSFileManager defaultManager] fileExistsAtPath:logFilePath]) {
			// the file doesn't exist yet, so we can just write out the text using the 
			// NSString convenience method
			[[NSFileManager defaultManager] createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:nil error:nil];
			[text writeToFile:logFilePath atomically:YES];
		} 
		else {
			// get a handle to the file
			NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
			if (fileHandle) {
				// move to the end of the file
				[fileHandle seekToEndOfFile];
				// convert the string to an NSData object
				NSString *tmpString = [NSString stringWithFormat:@"[%@] %@\n",[NSDate date],text];
				NSData *textData = [tmpString dataUsingEncoding:NSUTF8StringEncoding];
				tmpString = nil;
				// write the data to the end of the file
				[fileHandle writeData:textData];
				// move to the end of the file
				NSInteger fileSize = [fileHandle seekToEndOfFile];
				// clean up
				[fileHandle closeFile];
				textData = nil ;
				fileHandle = nil ;
				//Check oversize file
				[self _checkOversizeFileLogWithSize:fileSize];
			}
		}
		
		//Check for next call
		NSDictionary *next = [[self _sharedLogWriterQueue] nextInQueue];
		if (next) {  [self _appendLogText:[next objectForKey:@"1"]];  }
	}
	[[self _sharedLogLocker] unlock];
}
//Check oversize file and make necessary actions to it
+ (void)_checkOversizeFileLogWithSize:(NSInteger)fileSize {
	[[self _sharedLogLocker] lock];
	{
		//Check if file have more bytes than allowed in storage
		if (fileSize > logFileSize) {
			//Get Timestamp
			NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
			NSString *newFilePath = [logFilePath stringByAppendingFormat:@"%i",timestamp];
			[[NSFileManager defaultManager] moveItemAtPath:logFilePath toPath:newFilePath error:nil];
		}
	}
	[[self _sharedLogLocker] unlock];
}
@end
