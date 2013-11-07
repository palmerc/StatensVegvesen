//
//  CLPWebCameraXML.h
//  StatensVegvesen
//
//  Created by Cameron Palmer on 28.10.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CLPWebCamera.h"

extern NSString *const kWebCameraKey;
extern NSString *const kURLKey;
extern NSString *const kThumbnailURLKey;
extern NSString *const kThumbnailSizeKey;
extern NSString *const kPlaceNameKey;
extern NSString *const kRoadNameKey;
extern NSString *const kRegionKey;
extern NSString *const kLongitudeKey;
extern NSString *const kLatitudeKey;
extern NSString *const kWeatherKey;
extern NSString *const kInformationKey;



@interface CLPWebCameraXML : CLPWebCamera <NSXMLParserDelegate>

@property (strong, nonatomic, readonly) NSURL *URL;
@property (strong, nonatomic, readonly) NSURL *thumbnailURL;

- (id)initWithName:(NSString *)elementName attributes:(NSDictionary *)attributes parent:(id)parent children:(NSArray *)children parser:(NSXMLParser *)parser;

@end
