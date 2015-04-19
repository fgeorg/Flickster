//
//  LoginWebViewController.m
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//
// modified from FKAuthViewController FlickrKitDemo:
//    David Casserly on 03/06/2013.
//    Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//

#import "LoginWebViewController.h"
#import "FlickrClient.h"

@interface LoginWebViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation LoginWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(navBarFrame.origin.y + navBarFrame.size.height, 0, 0, 0);
    self.webView.alpha = 0;

    // Begin the authentication process
    [[FlickrClient sharedInstance] beginAuthWithCompletion:^(NSURL *flickrLoginPageURL, NSError *error) {
        if (!error)
        {
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:flickrLoginPageURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:30];
            [self.webView loadRequest:urlRequest];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginCompleted) name:@"FlickrUserLoggedIn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginCompleted) name:@"FlickrUserLoggedOut" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // wait a bit before showing the webview because it looks really ugly when it's loading
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            self.webView.alpha = 1;
        }];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlickrUserLoggedIn" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlickrUserLoggedOut" object:nil];
}

- (void)onLoginCompleted
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Web View

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"])
    {
        if ([[UIApplication sharedApplication]canOpenURL:url])
        {
            // this is a "flickster://auth" call. open it using the AppDelegate
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    return YES;
}

@end
