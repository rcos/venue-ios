//
//  AXAPI.h
//  
//
//  Created by Jim Boulter on 1/5/16.
//
//

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFImageDownloader.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AXExec.h"
#import "AXAPI.h"
#import "AXLocationExec.h"
#import "AXEvent.h"
#import "AXCourse.h"

static NSString* kAPIEmail = @"kAPIEmail";
static NSString* kAPIPassword = @"kAPIPassword";
static NSString* kUserId = @"kAPIUserId";
static NSString* kSessionToken = @"kSessionToken";
static NSString* baseURL = @"https://venue.cs.rpi.edu";
static NSString* kXSRFToken = @"kXSRFToken";

@interface AXAPI : AFHTTPSessionManager

+(AXAPI*)API;

@property NSString* userId;

-(void)loginWithEmail:(NSString*)email password:(NSString*)password block:(void(^)(BOOL))completion;

-(void)loginWithCASRequest:(NSURLRequest*)request block:(void(^)(BOOL))completion;

-(void)logOut;

-(void)getCoursesWithProgressView:(UIProgressView*)progressView completion:(void(^)(NSArray*))completion;

-(void)getEventsWithSectionId:(NSString*)sectionId progressView:(UIProgressView*)progressView completion:(void(^)(NSArray* events))completion;

-(void)getEventsWithProgressView:(UIProgressView*)progressView completion:(void(^)(NSArray* events))completion;

-(void)getSubmissionsWithEventId:(NSString*)eventId progressView:(UIProgressView*)progressView completion:(void(^)(NSArray* submissions))completion;

-(void)getMySubmissionsWithEventId:(NSString*)eventId progressView:(UIProgressView*)progressView completion:(void(^)(NSArray* submissions))completion;

-(void)getImageAtPath:(NSString*)path completion:(void(^)(UIImage* image))completion;

-(void)verifySubmissionForEventId:(NSString*)eventId withImage:(UIImage*)image withProgressView:(UIProgressView*)progressView completion:(void(^)(BOOL))completion;
@end
