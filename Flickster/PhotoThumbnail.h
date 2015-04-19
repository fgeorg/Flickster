//
//  PhotoThumbnail.h
//  Flickster
//
//  Created by Francesco Georg on 19/04/15.
//
//

#import <UIKit/UIKit.h>

@interface PhotoThumbnail : UIButton

@property (nonatomic, strong) NSDictionary *photoDictionary;

+ (instancetype)photoThumbnailWithFrame:(CGRect)frame photoDictionary:(NSDictionary *)photoDictionary;

- (void)downloadImage;

@end
