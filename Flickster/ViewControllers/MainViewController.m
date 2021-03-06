//
//  MainViewController.m
//  Flickster
//
//  Created by Francesco Georg on 15/04/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "MainViewController.h"
#import "FlickrClient.h"


@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *myPhotosButton;
@property (weak, nonatomic) IBOutlet UILabel *loginStateLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginButton.layer.cornerRadius = 8;
    self.myPhotosButton.layer.cornerRadius = 8;

    [[FlickrClient sharedInstance] checkAuthorization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn) name:@"FlickrUserLoggedIn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedOut) name:@"FlickrUserLoggedOut" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
        [self.loginButton setTitle:@"logout" forState:UIControlStateNormal];
        self.loginStateLabel.text = [NSString stringWithFormat:@"logged in as %@", [FlickrClient sharedInstance].userName];
        self.self.myPhotosButton.hidden = NO;
    }
    else
    {
        [self.loginButton setTitle:@"flickr login" forState:UIControlStateNormal];
        self.loginStateLabel.text = @"";
        self.self.myPhotosButton.hidden = YES;
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
