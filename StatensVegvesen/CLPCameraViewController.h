//
//  CLPCameraViewController.h
//  StatensVegvesen
//
//  Created by Cameron Palmer on 07.11.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLPWebCamera;



@interface CLPCameraViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) CLPWebCamera *camera;

@end
