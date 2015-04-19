//
//  ViewController.m
//  Flickster
//
//  Created by Francesco Georg on 15/04/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "ViewController.h"
#import "FlickrClient.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *loginStateLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[FlickrClient sharedInstance] checkAuthorization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn) name:@"FlickrUserLoggedIn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedOut) name:@"FlickrUserLoggedOut" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlickrUserLoggedIn" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlickrUserLoggedOut" object:nil];
}

- (IBAction)onLoginPressed:(id)sender
{
    if ([[FlickrClient sharedInstance] isAuthorized])
    {
        [[FlickrClient sharedInstance] logout];
    }
    else
    {
        [self performSegueWithIdentifier:@"showLoginView" sender:nil];
    }
}

- (void)updateView
{
    if ([[FlickrClient sharedInstance] isAuthorized])
    {
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        self.loginStateLabel.text = [NSString stringWithFormat:@"You are logged in as %@", [FlickrClient sharedInstance].userName];
    }
    else
    {
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        self.loginStateLabel.text = @"";
    }
}

#pragma mark - Auth

- (void) userLoggedIn
{
    [self updateView];

}

- (void) userLoggedOut
{
    [self updateView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
