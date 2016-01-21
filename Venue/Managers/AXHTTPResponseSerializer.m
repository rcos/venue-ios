//
//  AXHTTPResponseSerializer.m
//  Venue
//
//  Created by Jim Boulter on 1/21/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXHTTPResponseSerializer.h"

@interface AXHTTPResponseSerializer ()
@property AFImageResponseSerializer* imageResponseSerializer;
@end

@implementation AXHTTPResponseSerializer

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.imageResponseSerializer = [[AFImageResponseSerializer alloc] init];
        [self.imageResponseSerializer setAcceptableContentTypes:[self.imageResponseSerializer.acceptableContentTypes setByAddingObject:@"image/jpeg"]];
        self.acceptableContentTypes = [self.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    return self;
}

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error
{
    if([response.MIMEType isEqualToString:@"image/jpeg"])
    {
        id ro = [self.imageResponseSerializer responseObjectForResponse:response data:data error:error];
        return ro;
    }
    else return [super responseObjectForResponse:response data:data error:error];
}

@end
