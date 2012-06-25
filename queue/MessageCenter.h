//
//  MessageCenter.h
//  queue
//
//  Created by Gabriel Pacheco on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/types.h>  
#include <sys/ipc.h>  
#include <sys/msg.h>  
#include <stdio.h>  
#include <stdlib.h> 

#define MAXSIZE 4096
struct msgbuf   {  
    long    mtype;  
    char    mtext[MAXSIZE];  
} ; 

@interface MessageCenter : NSObject
- (void)runLoop ;

#pragma mark - Private
//Objects are returned in autorelease !
+ (void)checkMessage:(NSString *)message error:(NSError **)error commands:(NSArray **)commands ;
//Initial message filter
//Objects are returned in autorelease !
+ (void)initialMessageFilter:(NSString **)messageString withError:(NSError **)error ;
@end
