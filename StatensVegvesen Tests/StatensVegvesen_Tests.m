//
//  StatensVegvesen_Tests.m
//  StatensVegvesen Tests
//
//  Created by Cameron Palmer on 28.10.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <AFNetworking/AFNetworking.h>
#import "CLPWebCamerasXML.h"
#import "CLPWebCamera.h"

static NSString *const kStatensVegvesenMetadata = @"http://webkamera.vegvesen.no/metadata.xml";



@interface StatensVegvesen_Tests : XCTestCase

@end



@implementation StatensVegvesen_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    __block BOOL shouldKeepRunning = YES;        // global

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [manager GET:kStatensVegvesenMetadata parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *parser = responseObject;
        CLPWebCameras *webCameras = [[CLPWebCamerasXML alloc] initWithName:nil attributes:nil parent:nil children:nil parser:parser];
        [parser parse];
        
        shouldKeepRunning = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        shouldKeepRunning = NO;
    }];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    while (shouldKeepRunning && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

@end
