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
static NSString* kAPIPassword = @"kAPIPassword";
//static NSString* kUserId = @"kUserId";
static NSString* kSessionToken = @"kSessionToken";

@interface AXAPI : AFHTTPSessionManager

+(AXAPI*)API;

-(void)loginWithEmail:(NSString*)email password:(NSString*)password block:(void(^)(BOOL))completion;

-(void)logOut;

-(void)getCoursesWithProgressView:(UIProgressView*)progressView completion:(void(^)(NSArray*))completion;

-(void)getEventsWithProgressView:(UIProgressView*)progressView completion:(void(^)(NSArray* events))completion;

-(void)verifySubmissionWithImage:(UIImage*)image completion:(void(^)(BOOL))completion;
@end
