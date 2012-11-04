//
//  BHPhotoAlbumLayout.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHPhotoAlbumLayout.h"

@interface BHPhotoAlbumLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation BHPhotoAlbumLayout

#pragma mark - Properties

- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;
    
    _itemInsets = itemInsets;
    
    [self invalidateLayout];
}

#pragma mark - Layout

- (CGSize)collectionViewContentSize
{
    // TODO: calculate size we need for our items
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

- (void)prepareLayout
{
    NSLog(@"prepareLayout");

    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (int section=0; section<sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];

        for (int item=0; item<itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = [self frameForAlbumPhotoAtIndex:indexPath];
            
            [newLayoutInfo setObject:attributes forKey:indexPath];
        }
    }
    
    self.layoutInfo = newLayoutInfo;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];

    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {

        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];

    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.layoutInfo objectForKey:indexPath];
}



- (CGRect)frameForAlbumPhotoAtIndex:(NSIndexPath *)indexPath
{
    return CGRectMake(self.itemInsets.left, self.itemInsets.top, self.itemSize.width, self.itemSize.width);
}

@end
