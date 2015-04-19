//
//  FlickrClient.h
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface FlickrClient : NSObject<Singleton>

- (void)setup;

- (void)getPhotosAsync:(void(^)(NSArray *, NSError *))completionBlock;

- (BOOL)isAuthorized;

- (void)checkAuthorization;

- (void)completeAuthWithURL:(NSURL *)url;

- (void)logout;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *fullName;


@end
