//
//  OnePhotoViewController.h
//  Flickster
//
//  Created by Francesco Georg on 19/04/15.
//
//

#import <UIKit/UIKit.h>

@interface OnePhotoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet NSDictionary *photoDictionary;

@end
