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

//<webkamera id="100115">
@property (strong, nonatomic) NSString *identifier;

//<url>http://webkamera.vegvesen.no/kamera?id=100115</url>
@property (strong, nonatomic) NSURL *URL;

//<thumbnail-url>http://webkamera.vegvesen.no/thumbnail?id=100115</thumbnail-url>
@property (strong, nonatomic) NSURL *thumbnailURL;

//<thumnailstoerrelse>200</thumnailstoerrelse>
@property (assign, nonatomic) CGFloat thumbnailSize;

//<stedsnavn>Aarbergsdalen</stedsnavn>
@property (strong, nonatomic) NSString *placeName;

//<veg>E39</veg>
@property (strong, nonatomic) NSString *roadName;

//<landsdel>Vest-Norge</landsdel>
@property (strong, nonatomic) NSString *region;

//<lengdegrad>5.826541</lengdegrad>
//<breddegrad>61.291967</breddegrad>
@property (assign, nonatomic) CLLocationCoordinate2D location;

//<vaervarsel>
//http://www.yr.no/sted/Norge/Sogn_og_Fjordane/Gaular/%c3%85rbergsdalen/
//</vaervarsel>
@property (strong, nonatomic) NSURL *weatherURL;

//<info/>
@property (strong, nonatomic) NSString *information;

@end
