//
//  CPCameraService.m
//  StatensVegvesen
//
//  Created by Cameron Palmer on 12.02.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CPCameraService.h"



static NSString *const kXMLMetadata = @"http://webkamera.vegvesen.no/metadata.xml";

@interface CPCameraService ()
- (void)downloadCameraData;
@end

@implementation CPCameraService

- (id)init {
    self = [super init];
    if (self != nil) {
        [self downloadCameraData];
    }
    
    return self;
}



- (void)downloadCameraData {
    NSURL *url = [NSURL URLWithString:kXMLMetadata];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed.");
}


#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    NSLog(@"Bytes Written: %lld of %lld", totalBytesWritten, expectedTotalBytes);
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL {
    NSLog(@"File is located: %@", destinationURL);
        
    NSData *data = [NSData dataWithContentsOfURL:destinationURL];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end
