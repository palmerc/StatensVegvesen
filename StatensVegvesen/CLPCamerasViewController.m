//
//  CLPViewController.m
//  StatensVegvesen
//
//  Created by Cameron Palmer on 12.02.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CLPCamerasViewController.h"

#import "CLPCameraViewCell.h"
#import "CLPCameraService.h"
#import "CLPWebCamera.h"
#import "CLPCameraViewController.h"

static NSString *const kCollectionViewReusableCellIdentifier = @"CollectionViewReusableCellIdentifier";



@interface CLPCamerasViewController ()
@property (strong, nonatomic) NSArray *webCameras;

@end



@implementation CLPCamerasViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [[CLPCameraService sharedService] addObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FullScreenSegue"]) {
        CLPWebCamera *camera = sender;
        CLPCameraViewController *cameraViewController = segue.destinationViewController;
        cameraViewController.camera = camera;
    }
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
    CLPCameraViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    NSInteger row = indexPath.row;
    CLPWebCamera *webCamera = [self.webCameras objectAtIndex:row];
    
    NSString *cameraNameText = [NSString stringWithFormat:@"%@, %@, %@", webCamera.placeName, webCamera.roadName, webCamera.region];
    tableViewCell.cameraName.text = cameraNameText;
    
    UIImage *thumbnailImage = webCamera.thumbnailImage;
    tableViewCell.cameraThumbnailImageView.image = thumbnailImage;
    
    CGSize thumbnailSize = thumbnailImage.size;
    CGRect thumbnailFrame = CGRectMake(0.0f, 0.0f, thumbnailSize.width, thumbnailSize.height);
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
    UIImage *thumbnailImage = webCamera.thumbnailImage;
    CGSize thumbnailSize = thumbnailImage.size;
    CGFloat thumbnailHeight = thumbnailSize.height;
    
    return thumbnailHeight;
}


#pragma mark - CLPCameraServiceDelegate

- (void)didUpdateCamera:(CLPWebCamera *)aCamera
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    BOOL firstTime = YES;
    for (CLPWebCamera *camera in self.webCameras) {
        if ([camera isEqualToCamera:aCamera]) {
            UIImage *image = aCamera.image;
            if (image != nil) {
                camera.image = aCamera.image;
            }
            UIImage *thumbnailImage = aCamera.thumbnailImage;
            if (thumbnailImage != nil) {
                camera.thumbnailImage = thumbnailImage;
            }
            
            firstTime = NO;
        }
    }
    
    if (firstTime) {
        self.webCameras = [self.webCameras arrayByAddingObject:aCamera];
    }
    
    [self.tableView reloadData];
}

- (NSArray *)webCameras
{
    if (_webCameras == nil) {
        _webCameras = @[];
    }
    
    return _webCameras;
}

@end
