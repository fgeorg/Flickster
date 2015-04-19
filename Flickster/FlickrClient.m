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

@interface FlickrClient()
@property (nonatomic, copy, readwrite) NSString *userName;
@property (nonatomic, copy, readwrite) NSString *userId;
@property (nonatomic, copy, readwrite) NSString *fullName;
@end

@implementation FlickrClient
SingletonImplementation

- (void)setup
{
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:kFlickrAPIKey sharedSecret:kFlickrAPISecret];
}

- (void)getPhotosAsync:(void(^)(NSArray *, NSError *))completionBlock pageSize:(NSInteger)pageSize pageOffset:(NSInteger)pageOffset
{
    NSDictionary *args = @{@"user_id": self.userId,
                           @"per_page": [NSString stringWithFormat:@"%zi", pageSize],
                           @"page": [NSString stringWithFormat:@"%zi", pageOffset + 1]
    };
    [[FlickrKit sharedFlickrKit] call:@"flickr.photos.search" args:args maxCacheAge:FKDUMaxAgeNeverCache completion:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response)
            {
                NSMutableArray *photoURLs = [NSMutableArray array];
                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"])
                {
                    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeLargeSquare150 fromPhotoDictionary:photoDictionary];
                    [photoURLs addObject:url];
                }
                completionBlock(photoURLs, nil);
            }
            else
            {
                completionBlock(nil, error);
                
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
