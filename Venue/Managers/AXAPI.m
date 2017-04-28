//
//  AXAPI.m
//  
//
//  Created by Jim Boulter on 1/5/16.
//
//

#import "AXAPI.h"
#import "FXKeychain.h"
#import "AXHTTPResponseSerializer.h"

@implementation AXAPI : AFHTTPSessionManager

#pragma mark - Singleton

+ (AXAPI *)API {
    static AXAPI* netExec = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netExec = [[AXAPI alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        netExec.responseSerializer = [[AXHTTPResponseSerializer alloc] init];
        
        [netExec.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [[FXKeychain defaultKeychain] objectForKey:kSessionToken]] forHTTPHeaderField:@"Authorization"];
        [netExec.requestSerializer setValue:[[FXKeychain defaultKeychain] objectForKey:kXSRFToken] forHTTPHeaderField:@"X-XSRF-TOKEN"];
    });
    return netExec;
}

#pragma mark - Init

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(self)
    {
        [UIImageView setSharedImageDownloader:[[AFImageDownloader alloc] initWithSessionManager:self downloadPrioritization:AFImageDownloadPrioritizationFIFO maximumActiveDownloads:10 imageCache:nil]];
    }
    return self;
}

#pragma mark - Login

-(void)setAuthToken:(NSString*)token {
    [[FXKeychain defaultKeychain] setObject:token forKey:kSessionToken];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
}

-(void)getTokenswithCompletion:(void(^)(BOOL))completion
{
    //todo: check if we all ready have tokens and return completion(1) if we do
    
    //get tokens
    [self GET:@"/api/courses" parameters:@{@"purpose" : @"Give me my tokens"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(completion)completion(1);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completion)completion(0);
    }];
}

-(void)loginWithCASRequest:(NSURLRequest*)request block:(void(^)(BOOL))completion {
    if(request) {
        //TODO: Retain details for this request, to be able to make it later on
        
        NSURLSessionDataTask* task = [[AXAPI API] dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if(!error) {
                
                [[FXKeychain defaultKeychain] setObject:nil forKey:kAPIEmail];
                [self parseLoginResponse:responseObject];
                if(completion)completion(true);
            } else {
                if(completion)completion(false);
            }
        }];
        [task resume];
    }
}

-(void)loginWithEmail:(NSString*)email password:(NSString*)password block:(void(^)(BOOL))completion
{
    if(!email || !password)
    {
        if(completion)completion(0);
        return;
    }
    
    //Shoot our credentials to the server and acquire a new session token
    [self getTokenswithCompletion:^(BOOL success) {
        if(success)
        {
            NSDictionary* params = @{@"email":email, @"password":password};
            [self POST:@"/auth/local" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[FXKeychain defaultKeychain] setObject:email forKey:kAPIEmail];
                [self parseLoginResponse:responseObject];
                if(completion)completion(1);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if(completion)completion(0);
            }];
        }
    }];
}

-(void)logOut
{
    [[FXKeychain defaultKeychain] setObject:nil forKey:kSessionToken];
    [[FXKeychain defaultKeychain] setObject:nil forKey:kUserId];
    [[FXKeychain defaultKeychain] setObject:nil forKey:kAPIPassword];
    
    self.requestSerializer = [[AFJSONRequestSerializer alloc] init];
}

#pragma mark - Data Parsing

-(NSArray*)parseEvents:(NSDictionary*)events
{
    NSMutableArray* eventsObj = [[NSMutableArray alloc] init];
    for (NSDictionary* e in events) {
        [eventsObj addObject:[[AXEvent alloc] initWithDictionary:e]];
    }
    return [eventsObj copy];
}

-(NSArray*)parseCourses:(NSDictionary*)courses
{
    NSMutableArray* coursesObj = [[NSMutableArray alloc] init];
    for (NSDictionary* c in [courses allValues]) {
        [coursesObj addObject:[[AXCourse alloc] initWithDictionary:c]];
    }
    return [coursesObj copy];
}

- (void)parseLoginResponse:(id)responseObject {
    [[FXKeychain defaultKeychain] setObject:responseObject[@"profile"][@"_id"] forKey:kUserId];
    [self setAuthToken:responseObject[@"token"]];
}

#pragma mark - Data Fetching

- (void)getCoursesWithProgressView:(UIProgressView*)progressView completion:(void(^)(NSArray *))completion {
    [self GET:@"/api/users/me?withCourses=true" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressView setProgress:downloadProgress.fractionCompleted animated:YES];
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        AXLog(@"Course Response object: %@", responseObject);
        completion([self parseCourses:responseObject[@"courses"]]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
    }];
}

-(void)getEventsWithSectionId:(NSString*)sectionId progressView:(UIProgressView*)progressView completion:(void(^)(NSArray* events))completion
{
    if(sectionId == nil)
    {
        completion(nil);
        return;
    }
    NSString* path = [NSString stringWithFormat:@"/api/sectionevents?onlySection=%@", sectionId];
    [self GET:path parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progressView)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressView setProgress:downloadProgress.fractionCompleted animated:YES];
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(progressView)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressView setProgress:1 animated:YES];
            });
        }
        completion([self parseEvents:responseObject[@"sectionEvents"]]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
    }];
}

-(void)getEventsWithProgressView:(UIProgressView*)progressView completion:(void(^)(NSArray* events))completion
{
    [self GET:@"/api/users/me?withSectionEvents=true" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progressView)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressView setProgress:downloadProgress.fractionCompleted animated:YES];
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(progressView)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressView setProgress:1 animated:YES];
            });
        }
        completion([self parseEvents:responseObject[@"sectionEvents"]]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
    }];
}

-(void)getSubmissionsWithEventId:(NSString*)eventId progressView:(UIProgressView*)progressView completion:(void(^)(NSArray* submissions))completion
{
    [self GET:[NSString stringWithFormat:@"/api/submissions?onlySectionEvent=%@", eventId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progressView)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressView setProgress:downloadProgress.fractionCompleted animated:YES];
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
    }];
}

-(void)getMySubmissionsWithEventId:(NSString*)eventId progressView:(UIProgressView*)progressView completion:(void(^)(NSArray* submissions))completion
{
    [self GET:[NSString stringWithFormat:@"/api/submissions?onlyStudent=me&onlySectionEvent=%@", eventId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progressView)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressView setProgress:downloadProgress.fractionCompleted animated:YES];
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
    }];
}

-(void)getImageAtPath:(NSString*)path completion:(void(^)(UIImage* image))completion
{
    AFImageDownloader* imageDownloader = [[AFImageDownloader alloc] initWithSessionManager:self downloadPrioritization:AFImageDownloadPrioritizationFIFO maximumActiveDownloads:10 imageCache:nil];
    
    NSError *serializationError = nil;
    NSMutableURLRequest* req = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:nil error:&serializationError];
    
    [imageDownloader downloadImageForURLRequest:req success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        completion(responseObject);
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        completion(nil);
    }];
}

#pragma mark - Attendance

-(void)verifySubmissionForEventId:(NSString*)eventId withImage:(UIImage*)image withProgressView:(UIProgressView*)progressView completion:(void(^)(BOOL, NSError*))completion
{
    [[AXLocationExec exec] getLocationWithCompletion:^(CLLocation* location) {
        NSDictionary* params = @{@"coordinates" : @[@(location.coordinate.longitude), @(location.coordinate.latitude)],
                                 @"eventId" : eventId,
                                 @"userId" : @"me",
                                 @"content" : @"no",
                                 };
        
        NSData* data = UIImageJPEGRepresentation(image, .5);
        AXLog(@"submission network request start");
        [self POST:@"/api/submissions" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:data name:@"files[0]" fileName:@"img.jpg" mimeType:@"image/jpeg"];
        }
          progress:^(NSProgress * _Nonnull downloadProgress) {
              if(progressView) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [progressView setProgress:downloadProgress.fractionCompleted animated:YES];
                  });
              }
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			  NSLog(@"NETWORK RESPONSE: %@", responseObject);
			  
			  if ([responseObject isKindOfClass:[NSDictionary class]]) {
				  if ([[responseObject objectForKey:@"images"] count] != 0) {
					  completion(YES, nil);
					  // properly handle this bettter. 
				  }
			  }
			  else {
				  completion(NO, nil);
			  }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(0, error);
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
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
	
	// I will refactor this one day.
	
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
	AXLog(@"create new data task");
	
	void (^handler)(NSURLResponse *, id, NSError *e) = ^(NSURLResponse *response, id responseObject, NSError *error) {
		if (error) {
			//We've got a failure.  We need to check it out.
			
			//Cast the response from its container into its real class, so we can get the status code
			NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)dataTask.response;
			NSInteger statusCode = (NSInteger) httpResponse.statusCode;
			
			
			AXLog(@"Data task failure: %@", request.URL);
			//401 == unauthorized request, the session probably expired
			if (statusCode == 401) {
				AXLog(@"401, relogin");
				//Login check and then retry if successfully logged back in
				[[AXAPI API] loginWithEmail:[[FXKeychain defaultKeychain] objectForKey:kAPIEmail]
								   password:[[FXKeychain defaultKeychain] objectForKey:kAPIPassword]
									  block:^(BOOL succeeded){
										  if (succeeded) {
											  AXLog(@"Relog success");
											  //We logged back in and everything is fine, lets try that request again!
											  NSURLSessionDataTask* dt = [self dataTaskWithHTTPMethod:method URLString:URLString parameters:parameters uploadProgress:uploadProgress downloadProgress:downloadProgress success:success failure:failure];
											  [dt resume];
										  }
										  else {
											  AXLog(@"Relog fail");
											  //We couldn't log back in with the credentials we have.  Log us out.
											  if (failure) {
												  failure(dataTask, error);
											  }
											  if (![[AXExec appDel] isLoggingIn]) {
												  [[AXExec appDel] setLoggedOut];
											  }
										  }
									  }];
				
			}
			else {
				if (failure) {
					failure(dataTask, error);
				}
			}
		}
		else {
			AXLog(@"Data Task success %@", request.URL);
			if (success) {
				// Place the XSRF-TOKEN into the header of all our requests.
				NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:baseURL]];
				for (NSHTTPCookie *cookie in cookies) {
					if([cookie.name isEqualToString:@"XSRF-TOKEN"])
					{
						[self.requestSerializer setValue:[cookie.value stringByRemovingPercentEncoding] forHTTPHeaderField:@"X-XSRF-TOKEN"];
						[[FXKeychain defaultKeychain] setObject:[cookie.value stringByRemovingPercentEncoding] forKey:kXSRFToken];
					}
				}
				
				success(dataTask, responseObject);
			}
		}

	};
	
	
	dataTask = [self dataTaskWithRequest:request uploadProgress:uploadProgress downloadProgress:downloadProgress completionHandler:handler];
	return dataTask;
}

@end
