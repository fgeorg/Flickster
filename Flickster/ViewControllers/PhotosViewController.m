//
//  PhotosViewController.m
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//
//

#import "PhotosViewController.h"
#import "FlickrClient.h"

#define kThumbnailPadding 10
#define kThumbnailsPerRow 3
#define kImagesPerPage 15

@interface PhotosViewController()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL outOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentXIndex;
@property (nonatomic, assign) NSInteger currentYOffset;

@end

@implementation PhotosViewController

- (void)viewDidLoad
{
    self.backButton.layer.cornerRadius = 8;
    [self loadNextPage];
}

- (IBAction)onBackPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addImageToViewWithURL:(NSURL *)url
{
    CGFloat width = (self.scrollView.frame.size.width - (1 + kThumbnailsPerRow) * kThumbnailPadding) / kThumbnailsPerRow;
    CGFloat height = width;
    CGFloat x = kThumbnailPadding + (width + kThumbnailPadding) * self.currentXIndex;
    CGFloat y = self.currentYOffset + kThumbnailPadding;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    imageView.alpha = 0;
    imageView.layer.cornerRadius = 8;
    imageView.clipsToBounds = YES;
    
    [self.scrollView addSubview:imageView];
    
    self.currentXIndex++;
    if (self.currentXIndex >= kThumbnailsPerRow)
    {
        self.currentXIndex = 0;
        self.currentYOffset += height + kThumbnailPadding;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.currentYOffset + 2 * kThumbnailPadding + height);
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         UIImage *image = [[UIImage alloc] initWithData:data];
         [imageView setImage:image];
         [UIView animateWithDuration:.3f animations:^{
             imageView.alpha = 1;
         }];
     }];
    
}

- (void)loadNextPage
{
    if (self.isLoading || self.outOfPages)
    {
        return;
    }
    self.isLoading = YES;
    NSLog(@"loading next page...");
    if ([[FlickrClient sharedInstance] isAuthorized])
    {
        [[FlickrClient sharedInstance] getPhotosAsync:^(NSArray *photos, NSError *error)
        {
            if (error)
            {
                NSLog(@"Error while trying to view photos: %@", error.localizedDescription);
            }
            else
            {
                if ([photos count] < kImagesPerPage)
                {
                    self.outOfPages = YES;
                }
                for (NSURL *url in photos)
                {
                    [self addImageToViewWithURL:url];
                }
                self.currentPage++;
            }
            self.isLoading = NO;
        }  pageSize:kImagesPerPage pageOffset:self.currentPage];
    }
    else
    {
        NSLog(@"Error: Not logged in while viewing photos!");
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollView.contentOffset.y > bottomOffset - 500)
    {
        [self loadNextPage];
    }
}

@end
