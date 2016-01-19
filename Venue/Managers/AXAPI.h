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

static NSString* kAPIEmail = @"kAPIEmail";
static NSString* kSessionToken = @"kSessionToken";

@interface AXAPI : AFHTTPSessionManager

+(AXAPI*)API;

-(void)loginWithEmail:(NSString*)email password:(NSString*)password block:(void(^)(BOOL))completion;

-(void)verifySubmissionWithImage:(UIImage*)image completion:(void(^)(BOOL))completion;
@end
