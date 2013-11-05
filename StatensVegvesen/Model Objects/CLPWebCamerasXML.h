//
//  CLPWebCamerasXML.h
//  StatensVegvesen
//
//  Created by Cameron Palmer on 28.10.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CLPWebCameras.h"

extern NSString *const kWebCameras;



@interface CLPWebCamerasXML : CLPWebCameras <NSXMLParserDelegate>

@property (strong, nonatomic) NSXMLParser *parser;

- (id)initWithName:(NSString *)elementName attributes:(NSDictionary *)attributes parent:(id)parent children:(NSArray *)children parser:(NSXMLParser *)parser;

@end
