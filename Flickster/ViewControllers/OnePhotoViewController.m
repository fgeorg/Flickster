//
//  OnePhotoViewController.m
//  Flickster
//
//  Created by Francesco Georg on 19/04/15.
//
//

#import "OnePhotoViewController.h"
#import "PhotoThumbnail.h"
#import "FlickrClient.h"


@implementation OnePhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURLRequest *request = [NSURLRequest requestWithURL:[[FlickrClient sharedInstance] imageURLForPhotoDictionary:self.photoDictionary]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         UIImage *image = [[UIImage alloc] initWithData:data];
         [self.imageView setImage:image];
         [UIView animateWithDuration:.3f animations:^{
             self.imageView.alpha = 1;
         }];
     }];
}

@end
