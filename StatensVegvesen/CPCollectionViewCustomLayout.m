//
//  CPCollectionViewCustomLayout.m
//  StatensVegvesen
//
//  Created by Cameron Palmer on 01.09.13.
//  Copyright (c) 2013 Bird and Bear Studios. All rights reserved.
//

#import "CPCollectionViewCustomLayout.h"
#import "CPViewController.h"



@interface CPCollectionViewCustomLayout ()
@property (assign, nonatomic) CGSize contentSize;
@property (strong, nonatomic) NSDictionary *indexPathToLayoutAttributes;

@end



@implementation CPCollectionViewCustomLayout

- (void)prepareLayout
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSMutableDictionary *mutableIndexPathToLayoutAttributes = [[NSMutableDictionary alloc] init];
    NSDictionary *indexPathMetadata = self.viewController.indexPathMetadata;
    
    NSUInteger sectionCount = 0;
    NSUInteger rowCount = 0;
    CGSize cellSize = CGSizeMake(50.0f, 50.0f);
    
    for (NSInteger section = sectionCount; section < [indexPathMetadata count]; section++) {
        CGFloat x = sectionCount * (cellSize.width + 10.0f);
        NSArray *rows = [indexPathMetadata objectForKey:@(section)];
        
        rowCount = 0;
        for (NSIndexPath *indexPath in rows) {
            CGFloat y = rowCount * (cellSize.height + 10.0f);

            UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            layoutAttributes.frame = CGRectMake(x, y, 50.0f, 50.0f);
            
            NSLog(@"[%d, %d] at (%f, %f)", indexPath.section, indexPath.row, x, y);
            [mutableIndexPathToLayoutAttributes setObject:layoutAttributes forKey:indexPath];
            rowCount++;
        }
        sectionCount++;
    }
    
    self.contentSize = CGSizeMake(sectionCount * (cellSize.width + 10.0f), rowCount * (cellSize.height + 10.0f));

    self.indexPathToLayoutAttributes = [mutableIndexPathToLayoutAttributes copy];
}

- (CGSize)collectionViewContentSize
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGSize cellSize = CGSizeMake(60.0f, 60.0f);
    NSInteger lowerSection = floorf(x / cellSize.width);
    if (lowerSection < 0) {
        lowerSection = 0;
    }
    NSInteger lowerRow = floorf(y / cellSize.height);
    if (lowerRow < 0) {
        lowerRow = 0;
    }
    NSInteger upperSection = ceilf(width / cellSize.width) + lowerSection;
    NSInteger upperRow = ceilf(height / cellSize.height) + lowerRow;
    NSMutableArray *mutableLayoutAttributes = [NSMutableArray array];
    for (NSInteger section = lowerSection; section <= upperSection; section++) {
        for (NSInteger row = lowerRow; row <= upperRow; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UICollectionViewLayoutAttributes *layoutAttributes = [self.indexPathToLayoutAttributes objectForKey:indexPath];
            if (layoutAttributes != nil) {
                [mutableLayoutAttributes addObject:layoutAttributes];
            }            
        }
    }
    
    return [mutableLayoutAttributes copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.indexPathToLayoutAttributes objectForKey:indexPath];
}

@end
