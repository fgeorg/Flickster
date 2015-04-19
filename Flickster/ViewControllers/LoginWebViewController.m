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
#import "FlickrKit.h"

@interface LoginWebViewController ()

@property (nonatomic, retain) FKDUNetworkOperation *authOp;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation LoginWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton.layer.cornerRadius = 8;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0, 0, 0);
    self.webView.alpha = 0;
    // This must be defined in your Info.plist
    // Flickr will call this back. Ensure you configure your flickr app as a web app
    NSString *callbackURLString = @"flickster://auth";
    
    // Begin the authentication process
    self.authOp = [[FlickrKit sharedFlickrKit] beginAuthWithCallbackURL:[NSURL URLWithString:callbackURLString] permission:FKPermissionDelete completion:^(NSURL *flickrLoginPageURL, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error)
            {
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:flickrLoginPageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
                [self.webView loadRequest:urlRequest];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        });		
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
    // wait a bit before showing the webview because it looks really ugly when it's loading
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.5 animations:^{
            self.webView.alpha = 1;
        }];
    });

}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlickrUserLoggedIn" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlickrUserLoggedOut" object:nil];
}

- (void)onLoginCompleted
{
    [self dismissViewControllerAnimated:YES completion:nil];   
}

- (IBAction)onBackPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.authOp cancel];
    [super viewWillDisappear:animated];
}

#pragma mark - Web View

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // If they click NO DONT AUTHORIZE, this is where it takes you by default... maybe take them to my own web site, or show something else

    NSURL *url = [request URL];
    NSLog(@"url: %@ %@", url, request.HTTPMethod);
	// If it's the callback url, then lets trigger that
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    return YES;
}

@end
