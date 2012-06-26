//
//  Logger.m
//  queue
//
//  Created by Gabriel Pacheco on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Logger.h"
#import "Config.h"

@implementation Logger


//write log
+ (void)writeLog:(NSString *)logString {
	[self _queueWriteLog:logString];
}


#pragma mark - Queueing
//Status shared writer queue
static NSOperationQueue *__sharedLogQueue = nil ;
//shared writer queue
+ (NSOperationQueue *)_sharedLogWriterQueue {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		__sharedLogQueue = [NSOperationQueue new];
		[__sharedLogQueue setMaxConcurrentOperationCount:1];
	});
	return __sharedLogQueue;
}
//queue write log
+ (void)_queueWriteLog:(NSString *)logString {
	//Append thread info !
	//	if ([[NSThread currentThread] name]) {
	//		logString = [NSString stringWithFormat:@"[%@]
	//	}
	//
	[[self _sharedLogWriterQueue] addOperationWithBlock:^{
		//Write !
		[self _appendLogText:logString];
	}];	
}
#pragma mark - Writer

//append string into file
+ (void)_appendLogText:(NSString *)text {
	
    // NSFileHandle won't create the file for us, so we need to check to make sure it exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logFilePath]) {
        // the file doesn't exist yet, so we can just write out the text using the 
        // NSString convenience method
        NSError *error = nil;
		[text writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    } 
	else {
        // get a handle to the file
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
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
//Check oversize file and make necessary actions to it
+ (void)_checkOversizeFileLogWithSize:(NSInteger)fileSize {
	//Check if file have more bytes than allowed in storage
	if (fileSize > maLogFileSize) {
		//Get Timestamp
		NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
		NSString *newFilePath = [logFilePath stringByAppendingFormat:@"%i",timestamp];
		[[NSFileManager defaultManager] moveItemAtPath:logFilePath toPath:newFilePath error:nil];
	}
}
@end
