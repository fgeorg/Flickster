//
//  PhotoThumbnail.m
//  Flickster
//
//  Created by Francesco Georg on 19/04/15.
//
//

#import "PhotoThumbnail.h"
#import "FlickrClient.h"

@implementation PhotoThumbnail

+ (instancetype)photoThumbnailWithFrame:(CGRect)frame photoDictionary:(NSDictionary *)photoDictionary
{
    PhotoThumbnail *photoThumbnail = [PhotoThumbnail buttonWithType:UIButtonTypeCustom];
    photoThumbnail.photoDictionary = photoDictionary;
    photoThumbnail.frame = frame;
    photoThumbnail.alpha = 0;
    photoThumbnail.layer.cornerRadius = 8;
    photoThumbnail.clipsToBounds = YES;
    
    return photoThumbnail;
}

- (void)downloadImage
{
    NSURL *url = [[FlickrClient sharedInstance] thumbnailURLForPhotoDictionary:self.photoDictionary];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:4.0];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (!data)
         {
             NSLog(@"Error: No data when downloading thumbnail. %@", [error localizedDescription]);
             // try again after 1 second
             [self performSelector:@selector(downloadImage) withObject:nil afterDelay:1.0f];
         }
         else
         {
             UIImage *image = [[UIImage alloc] initWithData:data];
             [self setImage:image forState:UIControlStateNormal];
             [UIView animateWithDuration:.3f animations:^{
                 self.alpha = 1;
             }];
         }
     }];
}

@end
