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

- (void)getPhotosAsync:(void(^)(NSArray *, NSError *))completionBlock pageSize:(NSInteger)pageSize pageOffset:(NSInteger)pageOffset;

- (NSURL *)thumbnailURLForPhotoDictionary:(NSDictionary *)photoDictionary;

- (NSURL *)imageURLForPhotoDictionary:(NSDictionary *)photoDictionary;

- (BOOL)isAuthorized;

- (void)checkAuthorization;

- (void)beginAuthWithCompletion:(void (^)(NSURL *, NSError *))callback;

- (void)completeAuthWithURL:(NSURL *)url;

- (void)logout;

@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *fullName;

@end
