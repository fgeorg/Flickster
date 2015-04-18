//
//  FlickrClient.m
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "FlickrClient.h"
#import "FlickrKit.h"

#define kFlickrAPIKey @"1676e2e07c9149dbe50447363de1a39a"
#define kFlickrAPISecret @"1648b500ed901740"

@implementation FlickrClient
SingletonImplementation

- (void)setup
{
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:kFlickrAPIKey sharedSecret:kFlickrAPISecret];
}

- (void)getPhotosAsync:(void(^)(NSArray *, NSError *))completionBlock
{
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = @"banana";
    search.per_page = @"15";
    [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response) {
                NSMutableArray *photoURLs = [NSMutableArray array];
                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                    [photoURLs addObject:url];
                    NSLog(@"%@\n\n", photoDictionary);
                }
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}


@end
