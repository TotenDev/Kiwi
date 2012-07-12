//
// TDLog.h — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
//

//Log functionalitys
typedef enum {
	kLogFuncNone   = 0x01,
	kLogFuncLog    = 0x02,
	kLogFuncStdout = 0x04, //Use only for error logs (be carefull)
	kLogFuncWriter = 0x08
}kLogFunctionality;

//Log Levels
typedef enum {
	//Manager
	kLogLevelQueue				= kLogFuncWriter,
	kLogLevelProcedures			= kLogFuncWriter,
	kLogLevelMessageCenter		= kLogFuncWriter,
	//
	kLogLevelMain				= kLogFuncWriter,
	kLogLevelStdout				= kLogFuncStdout,
	//Error
	kLogLevelError				= kLogFuncStdout
}kLogLevels;


// Functions
#pragma mark - Functions

// Log current file location
#define CurrentFileLocation [NSString stringWithFormat:@"%s[l:%d]",__PRETTY_FUNCTION__, __LINE__]
// Normal log
//#define __TDLog(...) NSLog(@"%s[l:%d] %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define __TDLog(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])
//Stdout
#define __TDStdout(...) NSLog(@" %@", [NSString stringWithFormat:__VA_ARGS__])
// Assertion Log
#define TDALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
// Assert
#define TDAssert(condition, ...) do { if (!(condition)) { TDALog(__VA_ARGS__); }} while(0)

#import "Logger.h"
// REAL log
#define TDLog(logLevel,condition,...) \
if ((logLevel&kLogFuncLog) == kLogFuncLog) { if (!(condition)) __TDLog(__VA_ARGS__); } \
if ((logLevel&kLogFuncStdout) == kLogFuncStdout) { __TDStdout(__VA_ARGS__); } \
if ((logLevel&kLogFuncWriter) == kLogFuncWriter) { if (!(condition)) [Logger writeLog:[NSString stringWithFormat:@"%@-%@",CurrentFileLocation,[NSString stringWithFormat:__VA_ARGS__]]]; }
//if ((logLevel&kLogFuncAssert) == kLogFuncAssert) { TDAssert(condition,__VA_ARGS__); } 


