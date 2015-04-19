//
//  PhotosViewController.m
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//
//

#import "PhotosViewController.h"
#import "FlickrClient.h"

@interface PhotosViewController()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation PhotosViewController

- (void)viewDidLoad
{
    self.backButton.layer.cornerRadius = 8;

    if ([[FlickrClient sharedInstance] isAuthorized])
    {
        [[FlickrClient sharedInstance] getPhotosAsync:^(NSArray *photos, NSError *error) {
            if (error)
            {
                NSLog(@"Error while trying to view photos: %@", error.localizedDescription);
            }
            else
            {
                for (NSURL *url in photos) {
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

                        UIImage *image = [[UIImage alloc] initWithData:data];
                        [self addImageToView:image];

                    }];
                }
            }
        }];
    }
    else
    {
        NSLog(@"Error: Not logged in while viewing photos!");
    }
}

- (IBAction)onBackPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) addImageToView:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat imageRatio = image.size.width / image.size.height;
    CGFloat height = width / imageRatio;
    CGFloat x = 0;
    CGFloat y = self.scrollView.contentSize.height;
    
    imageView.frame = CGRectMake(x, y, width, height);
    
    CGFloat newHeight = self.scrollView.contentSize.height + height;
    self.scrollView.contentSize = CGSizeMake(320, newHeight);
    
    [self.scrollView addSubview:imageView];
    
}

@end
