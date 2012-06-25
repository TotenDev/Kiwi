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

+ (RemoteProcedure *)newProcedureWithPath:(NSString *)path andParams:(NSString *)params ;
- (void)executeWithResponse:(NSString **)response ;


#pragma mark - Private
- (id)initProcedureWithPath:(NSString *)_filePath andParameters:(NSString *)_params ;
- (NSString *)executionCommand;
@end
