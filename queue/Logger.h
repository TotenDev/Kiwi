//
// Logger.h — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
//

#import <Cocoa/Cocoa.h>
@class WWQueue;
@interface Logger : NSObject
//write log
+ (void)writeLog:(NSString *)logString ;
//DO NOT CALL THIS METHODS DIRECTLY
#pragma mark - Private 
//queue write log
+ (void)_queueWriteLog:(NSString *)logString ;
//shared writer queue
+ (WWQueue *)_sharedLogWriterQueue ;
//append string into file
+ (void)_appendLogText:(NSString *)text ;
//Check oversize file and make necessary actions to it
+ (void)_checkOversizeFileLogWithSize:(NSInteger)fileSize ;
@end
