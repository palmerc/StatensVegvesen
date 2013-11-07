//
//  CLPWebCamera.m
//  StatensVegvesen
//
//  Created by Cameron Palmer on 28.10.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CLPWebCamera.h"



@implementation CLPWebCamera

- (BOOL)isEqualToCamera:(CLPWebCamera *)camera
{
    return [self isEqual:camera];
}

- (BOOL)isEqual:(id)object
{
    BOOL result = NO;
    if ([object isKindOfClass:[CLPWebCamera class]]) {
        CLPWebCamera *otherCamera = object;
        result = [self.identifier isEqualToString:otherCamera.identifier];
    }
    
    return result;
}

- (NSUInteger)hash
{
    return [self.identifier hash];
}

@end
