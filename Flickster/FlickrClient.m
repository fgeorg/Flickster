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


- (void)completeAuthWithURL:(NSURL *)url
{
    [[FlickrKit sharedFlickrKit] completeAuthWithURL:url completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error)
            {
                self.userName = userName;
                self.userId = userId;
                self.fullName = fullName;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FlickrUserLoggedIn" object:nil userInfo:nil];
            } else
            {
                NSLog(@"Error occured during authentication: %@", error.localizedDescription);
                
                NSString *errorMessage = error.localizedDescription;
                if ([errorMessage isEqualToString:@"oauth_problem=token_rejected"])
                {
                    errorMessage = @"Login failed temporarily because of a bad access token. It should work if you try again.";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];                
                [self logout];
            }
        });
    }];
}

- (void)checkAuthorization
{
    [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error)
            {
                self.userName = userName;
                self.userId = userId;
                self.fullName = fullName;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FlickrUserLoggedIn" object:nil userInfo:nil];
            } else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FlickrUserLoggedOut" object:nil userInfo:nil];
            }
        });
    }];
}

- (BOOL)isAuthorized
{
    return [[FlickrKit sharedFlickrKit] isAuthorized];
}

- (void)logout
{
    [[FlickrKit sharedFlickrKit] logout];
    self.userName = nil;
    self.userId = nil;
    self.fullName = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlickrUserLoggedOut" object:nil userInfo:nil];
}

@end
