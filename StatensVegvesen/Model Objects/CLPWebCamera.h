//
//  CLPWebCamera.h
//  StatensVegvesen
//
//  Created by Cameron Palmer on 28.10.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



@interface CLPWebCamera : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *thumbnailImage;
@property (strong, nonatomic) NSString *placeName;
@property (strong, nonatomic) NSString *roadName;
@property (strong, nonatomic) NSString *region;
@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) NSURL *weatherURL;
@property (strong, nonatomic) NSString *information;

- (BOOL)isEqualToCamera:(id)object;

@end
