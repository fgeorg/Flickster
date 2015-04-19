//
//  PhotosViewController.m
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//
//

#import "PhotosViewController.h"
#import "FlickrClient.h"

#define kPadding 10;

@interface PhotosViewController()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (nonatomic, assign) BOOL didPullDown;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation PhotosViewController

- (void)viewDidLoad
{
    self.backButton.layer.cornerRadius = 8;
    self.loadingLabel.hidden = YES;
    [self loadNextPage];
}

- (IBAction)onBackPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) addImageToView:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat width = 150;//CGRectGetWidth(self.scrollView.frame);
    CGFloat imageRatio = image.size.width / image.size.height;
    CGFloat height = width / imageRatio;
    CGFloat x = kPadding;
    CGFloat y = self.scrollView.contentSize.height + kPadding;
    
    imageView.frame = CGRectMake(x, y, width, height);
    imageView.layer.cornerRadius = 8;
    imageView.clipsToBounds = YES;
    CGFloat newHeight = self.scrollView.contentSize.height + height + kPadding;
    self.scrollView.contentSize = CGSizeMake(320, newHeight);
    
    [self.scrollView addSubview:imageView];
    
}

- (void)loadNextPage
{
    if ([[FlickrClient sharedInstance] isAuthorized])
    {
        [[FlickrClient sharedInstance] getPhotosAsync:^(NSArray *photos, NSError *error) {
            self.didPullDown = NO;
            self.loadingLabel.hidden = YES;
            if (error)
            {
                NSLog(@"Error while trying to view photos: %@", error.localizedDescription);
            }
            else
            {
                for (NSURL *url in photos)
                {
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                    {
                        UIImage *image = [[UIImage alloc] initWithData:data];
                        [self addImageToView:image];
                    }];
                }
                self.currentPage++;
            }
        } page:self.currentPage];
    }
    else
    {
        NSLog(@"Error: Not logged in while viewing photos!");
    }
    
    self.loadingLabel.hidden = NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (!self.didPullDown && scrollView.contentOffset.y > bottomOffset + 50)
    {
        self.didPullDown = YES;
        [self loadNextPage];
    }
}

@end
