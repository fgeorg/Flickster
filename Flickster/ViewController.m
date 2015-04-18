//
//  ViewController.m
//  Flickster
//
//  Created by Francesco Georg on 15/04/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "ViewController.h"
#import "FlickrClient.h"
#import "FlickrKit.h"
#import "Photo.h"
#import "FKAuthViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *loginStateLabel;

@end

@implementation ViewController

- (IBAction)onLoginPressed:(id)sender
{
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        [[FlickrKit sharedFlickrKit] logout];
        [self userLoggedOut];
    } else {
        [self performSegueWithIdentifier:@"showLoginView" sender:nil];
    }
}

#pragma mark - Auth

- (void) userAuthenticateCallback:(NSNotification *)notification {
    NSURL *callbackURL = notification.object;
    [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void) userLoggedIn:(NSString *)username userID:(NSString *)userID
{
    [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    self.loginStateLabel.text = [NSString stringWithFormat:@"You are logged in as %@", username];
}

- (void) userLoggedOut {
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginStateLabel.text = @"Login to flickr";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticateCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
//    [[FlickrClient sharedInstance] getPhotosAsync:^(NSArray *photos, NSError *error)
//    {
//        for (Photo *photo in photos)
//        {
//            NSLog(@"%@", photo.title);
//        }
//    }];
//    
    // Check if there is a stored token
    // You should do this once on app launch
    [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
            } else {
                [self userLoggedOut];
            }
        });		
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
