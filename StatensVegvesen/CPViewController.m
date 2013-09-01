//
//  CPViewController.m
//  StatensVegvesen
//
//  Created by Cameron Palmer on 12.02.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CPViewController.h"

#import "CPCollectionViewCustomLayout.h"
#import "CPCameraViewCell.h"
#import "CPCameraService.h"

static NSString *const kCollectionViewReusableCellIdentifier = @"CollectionViewReusableCellIdentifier";

@interface CPViewController ()

@end



@implementation CPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.customLayout.viewController = self;
    
    NSMutableDictionary *indexPathMetadata = [[NSMutableDictionary alloc] init];
    
    for (int section = 0; section < 100; section++) {
        for (int row = 0; row < 100; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            NSArray *rows = [indexPathMetadata objectForKey:@(section)];
            if (rows == nil) {
                rows = [NSArray arrayWithObject:indexPath];
            } else {
                NSMutableArray *mutableRows = [rows mutableCopy];
                [mutableRows addObject:indexPath];
                rows = [mutableRows copy];
            }
            
            [indexPathMetadata setObject:rows forKey:@(section)];
        }
    }
    
    self.indexPathMetadata = [indexPathMetadata copy];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    return [[self.indexPathMetadata allKeys] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSInteger items = [[self.indexPathMetadata objectForKey:@(section)] count];
    
    return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    CPCameraViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewReusableCellIdentifier forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [collectionViewCell.textLabel setText:[NSString stringWithFormat:@"%d, %d", section, row]];
    
    return collectionViewCell;
}

@end
