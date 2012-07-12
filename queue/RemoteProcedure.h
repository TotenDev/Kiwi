//
// RemoteProcedure.h — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
//

#import <Foundation/Foundation.h>

@interface RemoteProcedure : NSObject {
	NSString *filePath ;
	NSString *params ;
}

#pragma mark - Environment Methods
+ (RemoteProcedure *)newProcedureWithPath:(NSString *)path andParams:(NSString *)params ;
- (id)initProcedureWithPath:(NSString *)_filePath andParameters:(NSString *)_params ;
#pragma mark - 
//Main Method for execution
- (void)executeWithResponse:(NSString **)response ;
#pragma mark - Private
- (NSString *)executionCommand; //required medium processing and IO, so use carefull
@end
