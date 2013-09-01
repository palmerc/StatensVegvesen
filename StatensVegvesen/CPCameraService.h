//
//  CPCameraService.h
//  StatensVegvesen
//
//  Created by Cameron Palmer on 12.02.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPCameraService : NSObject <NSURLConnectionDelegate, NSURLConnectionDownloadDelegate> {
    NSData *_xmlData;
}

@end
