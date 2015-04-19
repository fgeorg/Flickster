//
//  LoginWebViewController.h
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//
// modified from FKAuthViewController FlickrKitDemo:
//    David Casserly on 03/06/2013.
//    Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//

#import <UIKit/UIKit.h>

@interface LoginWebViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
