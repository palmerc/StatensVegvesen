//
//  CLPViewController.h
//  StatensVegvesen
//
//  Created by Cameron Palmer on 12.02.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPCameraService.h"



@interface CLPCamerasViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLPCameraServiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
