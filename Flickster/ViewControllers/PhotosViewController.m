//
//  PhotosViewController.m
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//
//

#import "PhotosViewController.h"
#import "FlickrClient.h"
#import "PhotoThumbnail.h"
#import "OnePhotoViewController.h"

#define kThumbnailPadding 10
#define kThumbnailsPerRow 3
#define kImagesPerPage 15

@interface PhotosViewController()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL outOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentXIndex;
@property (nonatomic, assign) NSInteger currentYOffset;

@end

@implementation PhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    self.scrollView.contentInset = UIEdgeInsetsMake(navBarFrame.origin.y + navBarFrame.size.height, 0, 0, 0);
    
    [self loadNextPage];
}

- (void)addThumbnailToViewWithPhotoDictionary:(NSDictionary *)photoDictionary
{
    CGFloat width = (self.scrollView.frame.size.width - (1 + kThumbnailsPerRow) * kThumbnailPadding) / kThumbnailsPerRow;
    CGFloat height = width;
    CGFloat x = kThumbnailPadding + (width + kThumbnailPadding) * self.currentXIndex;
    CGFloat y = self.currentYOffset + kThumbnailPadding;
    
    PhotoThumbnail *photoThumbnail = [PhotoThumbnail photoThumbnailWithFrame:CGRectMake(x, y, width, height) photoDictionary:photoDictionary];
    
    [photoThumbnail addTarget:self
                       action:@selector(onThumbnailPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:photoThumbnail];
    
    self.currentXIndex++;
    if (self.currentXIndex >= kThumbnailsPerRow)
    {
        self.currentXIndex = 0;
        self.currentYOffset += height + kThumbnailPadding;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.currentYOffset + 2 * kThumbnailPadding + height);
    }
}

- (void)onThumbnailPressed:(PhotoThumbnail *)photoThumbnail
{
    [self performSegueWithIdentifier:@"ViewPhoto" sender:photoThumbnail];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(PhotoThumbnail *)photoThumbnail
{
    OnePhotoViewController *onePhotoVC = segue.destinationViewController;
    onePhotoVC.photoDictionary = photoThumbnail.photoDictionary;
}

- (void)loadNextPage
{
    if (self.isLoading || self.outOfPages)
    {
        return;
    }
    self.isLoading = YES;

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
            for (NSDictionary *dictionary in photos)
            {
                [self addThumbnailToViewWithPhotoDictionary:dictionary];
            }
            self.currentPage++;
        }
        self.isLoading = NO;
    }  pageSize:kImagesPerPage pageOffset:self.currentPage];
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
