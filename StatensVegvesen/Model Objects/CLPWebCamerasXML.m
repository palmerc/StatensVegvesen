//
//  CLPWebCamerasXML.m
//  StatensVegvesen
//
//  Created by Cameron Palmer on 28.10.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CLPWebCamerasXML.h"
#import "CLPWebCameraXML.h"

NSString *const kWebCameras = @"webkameraer";


@interface CLPWebCamerasXML ()
@property (weak, nonatomic) id <NSXMLParserDelegate> parent;

@end


@implementation CLPWebCamerasXML

- (id)initWithName:(NSString *)elementName attributes:(NSDictionary *)attributes parent:(id)parent children:(NSArray *)children parser:(NSXMLParser *)parser {
    self = [super init];
    if (self != nil) {
        [self initialize];
        
        [parser setDelegate:self];
    }
    
    return self;
}

- (void)initialize
{
    
}



#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kWebCameraKey]) {
        CLPWebCameraXML *webCameraXML = [[CLPWebCameraXML alloc] initWithName:elementName attributes:attributeDict parent:self children:nil parser:parser];
        if (self.webCameras == nil) {
            self.webCameras = @[webCameraXML];
        } else {
            self.webCameras = [self.webCameras arrayByAddingObject:webCameraXML];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kWebCameraKey]) {
        NSLog(@"%@", elementName);
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"%@", string);
}

@end
