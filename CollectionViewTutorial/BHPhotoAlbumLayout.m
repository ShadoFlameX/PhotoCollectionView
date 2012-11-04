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

- (void)setInterItemSpacing:(CGFloat)interItemSpacing
{
    if (_interItemSpacing == interItemSpacing) return;
    
    _interItemSpacing = interItemSpacing;
    
    [self invalidateLayout];
}

- (void)setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (_numberOfColumns == numberOfColumns) return;
    
    _numberOfColumns = numberOfColumns;
    
    [self invalidateLayout];
}


#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(23.0f, 23.0f, 23.0f, 23.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.interItemSpacing = 24.0f;
    self.numberOfColumns = 2;
}


#pragma mark - Layout

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / 2;
    
    CGFloat width = self.itemInsets.left +
                    self.numberOfColumns * self.itemSize.width + (self.numberOfColumns - 1) * self.interItemSpacing +
                    self.itemInsets.right;
    
    CGFloat height = self.itemInsets.top +
                     rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacing +
                     self.itemInsets.bottom;
    
    return CGSizeMake(width, height);
}

- (void)prepareLayout
{
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
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
    
    CGFloat originX = self.itemInsets.left + (self.itemSize.width + self.interItemSpacing) * column;
    CGFloat originY = self.itemInsets.top + (self.itemSize.height + self.interItemSpacing) * row;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.width);
}

@end
