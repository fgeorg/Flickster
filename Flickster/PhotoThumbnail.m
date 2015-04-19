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
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[[FlickrClient sharedInstance] thumbnailURLForPhotoDictionary:photoDictionary]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         UIImage *image = [[UIImage alloc] initWithData:data];
         [photoThumbnail setImage:image forState:UIControlStateNormal];
         [UIView animateWithDuration:.3f animations:^{
             photoThumbnail.alpha = 1;
         }];
     }];
    
    return photoThumbnail;
}


@end
