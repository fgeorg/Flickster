//
//  FlickrRestClient.h
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface FlickrRestClient : NSObject<Singleton>

- (void)setup;

- (void)getPhotosAsync:(void(^)(NSArray *, NSError *))completionBlock;

@end
