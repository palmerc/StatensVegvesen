//
//  CPCameraService.h
//  StatensVegvesen
//
//  Created by Cameron Palmer on 12.02.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLPWebCamera;
@protocol CLPCameraServiceDelegate;



@interface CLPCameraService : NSObject

@property (strong, nonatomic, readonly) NSArray *cameras;

+ (instancetype)sharedService;

- (void)addObserver:(id<CLPCameraServiceDelegate>)observer;
- (void)addObserver:(id<CLPCameraServiceDelegate>)observer forCamera:(CLPWebCamera *)camera;
- (void)removeObserver:(id<CLPCameraServiceDelegate>)observer;
- (void)removeObserver:(id<CLPCameraServiceDelegate>)observer forCamera:(CLPWebCamera *)camera;

@end



@protocol CLPCameraServiceDelegate <NSObject>
@optional
- (void)didUpdateCamera:(CLPWebCamera *)camera;
@end