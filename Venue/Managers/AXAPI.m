//
//  AXAPI.m
//  
//
//  Created by Jim Boulter on 1/5/16.
//
//

#import "AXAPI.h"

@implementation AXAPI

#pragma mark - Singleton

+(AXAPI*) API
{
    static AXAPI* netExec = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netExec = [[AXAPI alloc] init];
        netExec.responseSerializer = [AFJSONResponseSerializer serializer];
        netExec.responseSerializer.acceptableContentTypes = [netExec.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        securityPolicy.allowInvalidCertificates = YES;
//        netExec.securityPolicy = securityPolicy;
    });
    return netExec;
}

#pragma mark - Login

+(void)loginWithUsername:(NSString*)username password:(NSString*)password block:(void(^)(BOOL))completion
{
    //Shoot our credentials to the server and acquire a new session token
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
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    //Create a request from the data supplied to us
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
    
    //Create a dataTask with our newly created request
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            //We've got a failure.  We need to check it out.
            
            //Cast the response from its container into its real class, so we can get the status code
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)dataTask.response;
            NSInteger statusCode = (NSInteger) httpResponse.statusCode;
            
            //401 == unauthorized request, the session probably expired
            if(statusCode == 401)
            {
                //Login check and then retry if successfully logged back in
                [AXAPI loginWithUsername:nil
                                 password:nil
                                    block:^(BOOL succeeded){
                                        if(succeeded)
                                        {
                                            //We logged back in and everything is fine, lets try that request again!
                                            NSURLSessionDataTask* dt = [self dataTaskWithHTTPMethod:method URLString:URLString parameters:parameters success:success failure:failure];
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
                failure(dataTask, error);
            }
        }
        else
        {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    
    return dataTask;
}

@end
