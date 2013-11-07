//
//  CLPCameraViewController.m
//  StatensVegvesen
//
//  Created by Cameron Palmer on 07.11.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CLPCameraViewController.h"

#import "CLPWebCamera.h"



@interface CLPCameraViewController ()

@end



@implementation CLPCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = self.camera.image;
    [self.imageView sizeToFit];
}

@end
