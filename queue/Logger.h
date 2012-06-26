//
//  Logger.h
//  queue
//
//  Created by Gabriel Pacheco on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Logger : NSObject
//write log
+ (void)writeLog:(NSString *)logString ;

//DO NOT CALL THIS METHODS DIRECTLY
#pragma mark - Private 
//queue write log
+ (void)_queueWriteLog:(NSString *)logString ;
//shared writer queue
+ (NSOperationQueue *)_sharedLogWriterQueue ;
//append string into file
+ (void)_appendLogText:(NSString *)text ;
//Check oversize file and make necessary actions to it
+ (void)_checkOversizeFileLogWithSize:(NSInteger)fileSize ;
@end
