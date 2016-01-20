//
//  AXAPI.m
//  
//
//  Created by Jim Boulter on 1/5/16.
//
//

#import "AXAPI.h"
#import "FXKeychain.h"

@implementation AXAPI : AFHTTPSessionManager

#pragma mark - Singleton

+(AXAPI*) API
{
    static AXAPI* netExec = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netExec = [[AXAPI alloc] initWithBaseURL:[NSURL URLWithString:@"http://104.131.185.159:9000"]];
        netExec.responseSerializer = [AFJSONResponseSerializer serializer];
        netExec.responseSerializer.acceptableContentTypes = [netExec.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [netExec.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [[FXKeychain defaultKeychain] objectForKey:kSessionToken]] forHTTPHeaderField:@"Authorization"];
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        securityPolicy.allowInvalidCertificates = YES;
//        netExec.securityPolicy = securityPolicy;
    });
    return netExec;
}

#pragma mark - Login

-(void)getTokenswithCompletion:(void(^)(BOOL))completion
{
    //check if we all ready have tokens and return completion(1) if we do
    
    //get tokens
    [self GET:@"/api/courses" parameters:@{@"purpose" : @"Give me my tokens"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //Place the XSRF-TOKEN into the header of all our requests.
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:@"http://104.131.185.159:9000"]];
        for (NSHTTPCookie *cookie in cookies)
        {
            if([cookie.name isEqualToString:@"XSRF-TOKEN"])
            {
                [self.requestSerializer setValue:[cookie.value stringByRemovingPercentEncoding] forHTTPHeaderField:@"X-XSRF-TOKEN"];
            }
        }
        
        completion(1);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(0);
    }];
}

-(void)loginWithEmail:(NSString*)email password:(NSString*)password block:(void(^)(BOOL))completion
{
    if(!email || !password)
    {
        completion(0);
        return;
    }
    
    //Shoot our credentials to the server and acquire a new session token
    [self getTokenswithCompletion:^(BOOL success) {
        if(success)
        {
            NSDictionary* params = @{@"email":email, @"password":password};
            [self POST:@"/auth/local" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[FXKeychain defaultKeychain] setObject:email forKey:kAPIEmail];
                [[FXKeychain defaultKeychain] setObject:responseObject[@"token"] forKey:kSessionToken];
                [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", responseObject[@"token"]] forHTTPHeaderField:@"Authorization"];
                completion(1);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completion(0);
            }];
        }
    }];
}

-(void)logOut
{
    [[FXKeychain defaultKeychain] setObject:nil forKey:kSessionToken];
    self.requestSerializer = [[AFJSONRequestSerializer alloc] init];
}

#pragma mark - Data Fetching

-(void)getCoursesWithProgressView:(UIProgressView*)progressView completion:(void(^)(NSArray*))completion
{
    [self GET:@"/api/courses" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progressView) [progressView setProgress:downloadProgress.fractionCompleted animated:YES];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
    }];
}

-(void)getEventsWithProgressView:(UIProgressView*)progressView completion:(void(^)(NSArray* events))completion
{
    [self GET:@"/api/users/me?withEvents=true" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progressView) [progressView setProgress:downloadProgress.fractionCompleted animated:YES];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject[@"events"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
    }];
}

#pragma mark - Attendance

-(void)verifySubmissionWithImage:(UIImage*)image completion:(void(^)(BOOL))completion
{
    [[AXLocationExec exec] getLocationWithCompletion:^(CLLocation* location) {
        [self POST:@"/api/submissions" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completion(1);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(0);
        }];
    }];
}

#pragma mark - Session Manager

/*
 Override from AFHTTPSessionManager
 ==================================
 This function creates a datatask with specified configuration and examines the statusCode it receives in a response.
 It will re-log the user if it can, and if it can't, it'll send the app to logged out.
 */

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           
//                           NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:@"http://104.131.185.159:9000"]];
//                           for (NSHTTPCookie *cookie in cookies)
//                           {
//                               NSLog(@"%@\n", cookie);
//                           }
                           
                           if (error) {
                               //We've got a failure.  We need to check it out.
                               
                               //Cast the response from its container into its real class, so we can get the status code
                               NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)dataTask.response;
                               NSInteger statusCode = (NSInteger) httpResponse.statusCode;
                               
                               //401 == unauthorized request, the session probably expired
                               if(statusCode == 401)
                               {
                                   //Login check and then retry if successfully logged back in
                                   [[AXAPI API] loginWithEmail:[[FXKeychain defaultKeychain] objectForKey:kAPIEmail]
                                                      password:[[FXKeychain defaultKeychain] objectForKey:kAPIPassword]
                                                         block:^(BOOL succeeded){
                                                             if(succeeded)
                                                             {
                                                                 //We logged back in and everything is fine, lets try that request again!
                                                                 NSURLSessionDataTask* dt = [self dataTaskWithHTTPMethod:method URLString:URLString parameters:parameters uploadProgress:uploadProgress downloadProgress:downloadProgress success:success failure:failure];
                                                                 [dt resume];
                                                             }
                                                             else
                                                             {
                                                                 //We couldn't log back in with the credentials we have.  Log us out.
                                                                 if (failure) {
                                                                     failure(dataTask, error);
                                                                 }
                                                                 [[AXExec appDel] setLoggedOut];
                                                             }
                                                         }];
                                   
                               }
                               else
                               {
                                   if (failure) {
                                       failure(dataTask, error);
                                   }
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
}

@end
