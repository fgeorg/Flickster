//
//  FlickrRestClient.m
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "FlickrRestClient.h"
#import "RestKit.h"
#import "Photo.h"

#define kFlickrAPIKey @"1676e2e07c9149dbe50447363de1a39a"

@implementation FlickrRestClient
SingletonImplementation

- (void)setup
{
    [self configureRestKit];
}

- (void)getPhotosAsync:(void(^)(NSArray *, NSError *))completionBlock
{
    
    NSDictionary *queryParams = @{
                                  @"api_key" : kFlickrAPIKey,
                                  @"format" : @"json",
                                  @"method" : @"flickr.photos.search",
                                  @"nojsoncallback" : @"1",
                                  @"text" : @"banana"
                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/services/rest"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  completionBlock([mappingResult.array copy], nil);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  completionBlock(nil, error);
                                              }];
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.flickr.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *photoMapping = [RKObjectMapping mappingForClass:[Photo class]];
    [photoMapping addAttributeMappingsFromArray:@[@"title"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:photoMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/services/rest"
                                                keyPath:@"photos.photo"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

@end
