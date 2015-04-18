//
//  ViewController.m
//  Flickster
//
//  Created by Francesco Georg on 15/04/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "ViewController.h"
#import "FlickrClient.h"
#import "Photo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[FlickrClient sharedInstance] getPhotosAsync:^(NSArray *photos, NSError *error)
    {
        for (Photo *photo in photos)
        {
            NSLog(@"%@", photo.title);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
