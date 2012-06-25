//
//  TDLog.h
//  WWDCounter
//
//  Created by Gabriel Pacheco on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//Log functionalitys
typedef enum {
	kLogFuncNone   = 0x01,
	kLogFuncLog    = 0x02,
	kLogFuncAssert = 0x04, //Use only for error logs (be carefull)
	//kLogFuncWriter = 0x08,
}kLogFunctionality;

//Log Levels
typedef enum {
	//Manager
	kLogLevelQueue				= kLogFuncLog,
	kLogLevelProcedures			= kLogFuncLog,
	kLogLevelMessageCenter			= kLogFuncLog,
	//Error
	kLogLevelError             = kLogFuncAssert,
}kLogLevels;


// Functions
#pragma mark - Functions

// Log current file location
#define CurrentFileLocation [NSString stringWithFormat:@"%s[l:%d]",__PRETTY_FUNCTION__, __LINE__]
// Normal log
#define __TDLog(...) NSLog(@"%s[l:%d] %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
// Assertion Log
#define TDALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]\
 file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
// Assert
#define TDAssert(condition, ...) do { if (!(condition)) { TDALog(__VA_ARGS__); }} while(0)

// REAL log
#define TDLog(logLevel,condition,...) \
if ((logLevel&kLogFuncLog) == kLogFuncLog) { if (!(condition)) __TDLog(__VA_ARGS__); } \
if ((logLevel&kLogFuncAssert) == kLogFuncAssert) { TDAssert(condition,__VA_ARGS__); }
//if ((logLevel&kLogFuncWriter) == kLogFuncWriter) { if (!(condition)) [TDEventsController writeLog:[NSString stringWithFormat:@"%@-%@",CurrentFileLocation,[NSString stringWithFormat:__VA_ARGS__]]]; } \


