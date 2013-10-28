//
//  CPViewController.h
//  StatensVegvesen
//
//  Created by Cameron Palmer on 12.02.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPCollectionViewCustomLayout;



@interface CPViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSDictionary *indexPathMetadata;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet CPCollectionViewCustomLayout *customLayout;

@property (assign, nonatomic) CGSize cellSize;

@end
