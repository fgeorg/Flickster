//
//  ViewController.m
//  Flickster
//
//  Created by Francesco Georg on 15/04/15.
//  Copyright (c) 2015 Wooga. All rights reserved.
//

#import "ViewController.h"
#import "RestKit.h"
#import "Venue.h"
#import "Photo.h"

#define kFlickrAPIKey @"1676e2e07c9149dbe50447363de1a39a"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureRestKit];
    [self loadVenues];
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

- (void)loadVenues
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
                                                  for (Photo *photo in mappingResult.array)
                                                  {
                                                      NSLog(@"oh my god: %@", photo.title);
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                              }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
