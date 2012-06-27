//
//  RemoteProcedure.h
//  queue
//
//  Created by Gabriel Pacheco on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
