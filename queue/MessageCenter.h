//
// MessageCenter.h — Kiwi
// today is 7/12/12, it is now 00:12 AM
// created by TotenDev
// see LICENSE for details.
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
