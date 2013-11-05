//
//  CLPWebCameraXML.m
//  StatensVegvesen
//
//  Created by Cameron Palmer on 28.10.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CLPWebCameraXML.h"

NSString *const kWebCameraKey = @"webkamera";
NSString *const kWebCameraIdentifierKey = @"id";
NSString *const kURLKey = @"url";
NSString *const kThumbnailURLKey = @"thumbnail-url";
NSString *const kThumbnailSizeKey = @"thumnailstoerrelse";
NSString *const kPlaceNameKey = @"stedsnavn";
NSString *const kRoadNameKey = @"veg";
NSString *const kRegionKey = @"landsdel";
NSString *const kLongitudeKey = @"lengdegrad";
NSString *const kLatitudeKey = @"breddegrad";
NSString *const kWeatherKey = @"vaervarsel";
NSString *const kInformationKey = @"info";



@interface CLPWebCameraXML ()
@property (weak, nonatomic) id <NSXMLParserDelegate> parent;
@property (strong, nonatomic) NSMutableString * textStorage;
@property (strong, nonatomic) NSDictionary *XMLToSelectorMap;
@property (assign, nonatomic) CLLocationDegrees longitude;
@property (assign, nonatomic) CLLocationDegrees latitude;

@end



@implementation CLPWebCameraXML

- (id)initWithName:(NSString *)elementName attributes:(NSDictionary *)attributes parent:(id)parent children:(NSArray *)children parser:(NSXMLParser *)parser {
    self = [super init];
    if (self != nil) {
        [self initialize];
        
        _parent = parent;
        [parser setDelegate:self];
        
        [self setIdentifier:[attributes objectForKey:kWebCameraIdentifierKey]];
    }
    
    return self;
}

- (void)initialize
{
    _XMLToSelectorMap = @{
                           kURLKey : [NSValue valueWithPointer:@selector(setURLFromString:)],
                           kThumbnailURLKey : [NSValue valueWithPointer:@selector(setThumbnailURLFromString:)],
                           kThumbnailSizeKey : [NSValue valueWithPointer:@selector(setThumnailSizeFromString:)],
                           kPlaceNameKey : [NSValue valueWithPointer:@selector(setPlaceName:)],
                           kRoadNameKey : [NSValue valueWithPointer:@selector(setRoadName:)],
                           kRegionKey : [NSValue valueWithPointer:@selector(setRegion:)],
                           kLongitudeKey : [NSValue valueWithPointer:@selector(setLongitude:)],
                           kLatitudeKey : [NSValue valueWithPointer:@selector(setLatitude:)],
                           kWeatherKey : [NSValue valueWithPointer:@selector(setWeatherURLFromString:)],
                           kInformationKey : [NSValue valueWithPointer:@selector(setInformation:)]
                           };
}



#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    SEL action = [[self.XMLToSelectorMap objectForKey:elementName] pointerValue];
    if (action != NULL && [self respondsToSelector:action]) {
        NSString *argument = self.textStorage;
        argument = [argument stringByRemovingPercentEncoding];
        argument = [argument stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSLog(@"%@%@", NSStringFromSelector(action), argument);
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:action]];
        [invocation setTarget:self];
        [invocation setSelector:action];
        [invocation setArgument:&argument atIndex:2];
        [invocation invoke];
    }
    
    self.textStorage = nil;
    if ([elementName isEqualToString:kWebCameraKey]) {
        [parser setDelegate:self.parent];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.textStorage == nil) {
        NSMutableString *textStorage = [[NSMutableString alloc] initWithString:string];
        self.textStorage = textStorage;
    } else {
        [self.textStorage appendString:string];
    }
}



#pragma mark - Instance methods

- (void)setURLFromString:(NSString *)string
{
    NSURL *URL = [NSURL URLWithString:string];
    self.URL = URL;
}

- (void)setThumbnailURLFromString:(NSString *)string
{
    NSURL *URL = [NSURL URLWithString:string];
    self.thumbnailURL = URL;
}

- (void)setWeatherURLFromString:(NSString *)string
{
    NSURL *URL = [NSURL URLWithString:string];
    self.weatherURL = URL;
}

- (void)setThumnailSizeFromString:(NSString *)string
{
    self.thumbnailSize = [string floatValue];
}

- (CLLocationCoordinate2D)location
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
