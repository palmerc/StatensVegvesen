//
//  CPCameraService.m
//  StatensVegvesen
//
//  Created by Cameron Palmer on 12.02.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CLPCameraService.h"

#import <AFNetworking/AFNetworking.h>
#import "CLPWebCameraXML.h"
#import "CLPWebCamerasXML.h"

static NSString *const kStatensVegvesenMetadata = @"http://webkamera.vegvesen.no/metadata.xml";



@interface CLPCameraService ()
@property (strong, nonatomic, readwrite) NSArray *cameras;
@property (strong, nonatomic) NSArray *observers;
@property (assign, nonatomic, getter = hasStarted) BOOL start;

@end



@implementation CLPCameraService

+ (instancetype)sharedService
{
    static CLPCameraService *sharedCameraService = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCameraService = [[CLPCameraService alloc] init];
    });
    
    return sharedCameraService;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _start = NO;
    }
    
    return self;
}

- (void)addObserver:(id<CLPCameraServiceDelegate>)observer
{
    [self addObserver:observer forCamera:nil];
}

- (void)addObserver:(id<CLPCameraServiceDelegate>)observer forCamera:(CLPWebCamera *)camera
{
    if (!self.hasStarted) {
        [self refreshCameraDatabase];
    }
    
    if (self.observers == nil) {
        self.observers = @[observer];
    } else {
        self.observers = [self.observers arrayByAddingObject:observer];
    }
}

- (void)removeObserver:(id<CLPCameraServiceDelegate>)observer
{
    [self addObserver:observer forCamera:nil];
}

- (void)removeObserver:(id<CLPCameraServiceDelegate>)observer forCamera:(CLPWebCamera *)camera
{
    
}

- (void)refreshCameraDatabase
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [manager GET:kStatensVegvesenMetadata parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *parser = responseObject;
        NSDictionary *responseHeadersDictionary = [operation.response allHeaderFields];
        NSString *dateString = [responseHeadersDictionary objectForKey:@"Expires"];
        //Thu, 07 Nov 2013 20:12:07 GMT
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        NSDate *expiryDate = [formatter dateFromString:dateString];
        [self scheduleDatabaseRefresh:expiryDate];
        
        CLPWebCameras *cameras = [[CLPWebCamerasXML alloc] initWithName:nil attributes:nil parent:nil children:nil parser:parser];
        [parser parse];
        
        self.cameras = [cameras webCameras];
        [self scheduleCameraRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogError(@"%@", error);
    }];
}

- (void)scheduleDatabaseRefresh:(NSDate *)date
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    static NSTimer *timer = nil;
    
    if (date == nil) {
        NSTimeInterval timeInterval = 300;
        DDLogVerbose(@"Date was nil. Specifying %f seconds in the future.", timeInterval);
        date = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    } else {
        DDLogVerbose(@"Scheduling next database refresh at %@", date);
    }
    
    if ([timer isValid]) {
        [timer invalidate];
    }
    
    timer = [[NSTimer alloc] initWithFireDate:date interval:0 target:self selector:@selector(refreshCameraDatabase) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)scheduleCameraRefresh
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    for (CLPWebCameraXML *camera in self.cameras) {
        DDLogInfo(@"Download images for %@", camera.placeName);
        
        [self downloadThumbnailForCamera:camera];
        [self downloadImageForCamera:camera];
    }
}

- (void)downloadThumbnailForCamera:(CLPWebCameraXML *)camera
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURLRequest *request = [NSURLRequest requestWithURL:camera.thumbnailURL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        return [documentsDirectoryPath URLByAppendingPathComponent:[targetPath lastPathComponent]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        DDLogInfo(@"File downloaded to: %@", [[filePath absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        NSData *imageData = [NSData dataWithContentsOfURL:filePath];
        UIImage *image = [UIImage imageWithData:imageData];
        camera.thumbnailImage = image;
        
        [self notifyObserversForCamera:camera];
    }];
    
    [downloadTask resume];
}

- (void)downloadImageForCamera:(CLPWebCameraXML *)camera
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURLRequest *request = [NSURLRequest requestWithURL:camera.URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        return [documentsDirectoryPath URLByAppendingPathComponent:[targetPath lastPathComponent]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        DDLogInfo(@"File downloaded to: %@", [[filePath absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        NSData *imageData = [NSData dataWithContentsOfURL:filePath];
        UIImage *image = [UIImage imageWithData:imageData];
        camera.image = image;
        
        [self notifyObserversForCamera:camera];
    }];
    
    [downloadTask resume];
}

- (void)notifyObserversForCamera:(CLPWebCamera *)camera
{
    for (id<CLPCameraServiceDelegate>delegate in self.observers) {
        if ([delegate respondsToSelector:@selector(didUpdateCamera:)]) {
            [delegate didUpdateCamera:camera];
        }
    }
}

@end
