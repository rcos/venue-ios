//
//  AXAPI.h
//  
//
//  Created by Jim Boulter on 1/5/16.
//
//

#import <AFNetworking/AFNetworking.h>
#import "AXExec.h"
#import "AXAPI.h"
#import "AXLocationExec.h"

@interface AXAPI : AFHTTPSessionManager

+(AXAPI*)API;

+(void)loginWithUsername:(NSString*)username password:(NSString*)password block:(void(^)(BOOL))completion;

-(void)verifySubmissionWithImage:(UIImage*)image completion:(void(^)(BOOL))completion;
@end
