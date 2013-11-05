//
//  CLPViewController.m
//  StatensVegvesen
//
//  Created by Cameron Palmer on 12.02.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CLPViewController.h"

#import <AFNetworking/AFNetworking.h>
#import "CLPCameraViewCell.h"
#import "CLPCameraService.h"
#import "CLPWebCamera.h"
#import "CLPWebCamerasXML.h"

static NSString *const kStatensVegvesenMetadata = @"http://webkamera.vegvesen.no/metadata.xml";
static NSString *const kCollectionViewReusableCellIdentifier = @"CollectionViewReusableCellIdentifier";



@interface CLPViewController ()
@end



@implementation CLPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [manager GET:kStatensVegvesenMetadata parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *parser = responseObject;
        CLPWebCameras *webCameras = [[CLPWebCamerasXML alloc] initWithName:nil attributes:nil parent:nil children:nil parser:parser];
        [parser parse];
        self.webCameras = [webCameras webCameras];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self webCameras] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    CLPCameraViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    NSInteger row = indexPath.row;
    CLPWebCamera *webCamera = [self.webCameras objectAtIndex:row];
    
    NSString *cameraNameText = [NSString stringWithFormat:@"%@, %@, %@", webCamera.placeName, webCamera.roadName, webCamera.region];
    tableViewCell.cameraName.text = cameraNameText;
    
    NSData *imageData = [NSData dataWithContentsOfURL:webCamera.thumbnailURL];
    UIImage *cameraThumbnailImage = [UIImage imageWithData:imageData];
    tableViewCell.cameraThumbnailImageView.image = cameraThumbnailImage;
    
    CGRect thumbnailFrame = CGRectMake(0.0f, 0.0f, webCamera.thumbnailSize, webCamera.thumbnailSize);
    tableViewCell.cameraThumbnailImageView.bounds = thumbnailFrame;
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLPWebCamera *webCamera = [self.webCameras objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"FullScreenSegue" sender:webCamera];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLPWebCamera *webCamera = [self.webCameras objectAtIndex:indexPath.row];
    CGFloat thumbnailSize = webCamera.thumbnailSize;
    
    return thumbnailSize;
}

@end
