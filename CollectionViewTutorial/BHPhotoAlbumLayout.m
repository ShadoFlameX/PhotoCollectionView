//
//  BHPhotoAlbumLayout.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHPhotoAlbumLayout.h"

static NSUInteger const AlbumTitleZIndex = 0;
static NSUInteger const PhotoCellBaseZIndex = 100;

static NSUInteger const RotationCount = 32;
static NSUInteger const RotationStride = 3;

@interface BHPhotoAlbumLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic, strong) NSArray *rotations;

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (CATransform3D)transformForAlbumPhotoAtIndex:(NSIndexPath *)indexPath;
- (CGRect)frameForAlbumTitleAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BHPhotoAlbumLayout

#pragma mark - Properties

- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;
    
    _itemInsets = itemInsets;
    
    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, itemSize)) return;
    
    _itemSize = itemSize;
    
    [self invalidateLayout];
}

- (void)setInterItemSpacingY:(CGFloat)interItemSpacingY
{
    if (_interItemSpacingY == interItemSpacingY) return;
    
    _interItemSpacingY = interItemSpacingY;
    
    [self invalidateLayout];
}

- (void)setTitleHeight:(CGFloat)titleHeight
{
    if (_titleHeight == titleHeight) return;
    
    _titleHeight = titleHeight;
    
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
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.interItemSpacingY = 14.0f;
    self.titleHeight = 30.0f;
    self.numberOfColumns = 2;
    
    // create rotations at load so that they are consistent during prepareLayout
    NSMutableArray *rotations = [NSMutableArray arrayWithCapacity:RotationCount];
    
    CGFloat percentage = 0.0f;
    for (int i=0; i<RotationCount; i++) {
        // ensure that each angle is different enough to be seen
        CGFloat newPercentage = 0.0f;
        do {
            newPercentage = ((CGFloat)(arc4random() % 200) - 100) * 0.0001f;
        } while (fabsf(percentage - newPercentage) < 0.008);
        percentage = newPercentage;
        
        CGFloat angle = 2 * M_PI * (1.0f + percentage);
        CATransform3D transform = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
        
        [rotations addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    self.rotations = rotations;
}


#pragma mark - Layout

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    // make sure we count a row if we only have 1 section
    if ([self.collectionView numberOfSections] == 1) rowCount = 1;

    CGFloat height = self.itemInsets.top +
                     rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY +
                     rowCount * self.titleHeight +
                     self.itemInsets.bottom;
    
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (int section=0; section<sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];

        for (int item=0; item<itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
            itemAttributes.zIndex = PhotoCellBaseZIndex + itemCount - indexPath.row;
            itemAttributes.transform3D = [self transformForAlbumPhotoAtIndex:indexPath];
            
            [cellLayoutInfo setObject:itemAttributes forKey:indexPath];
            
            if (indexPath.item == 0) {
                UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleIdentifier withIndexPath:indexPath];
                titleAttributes.frame = [self frameForAlbumTitleAtIndexPath:indexPath];
                titleAttributes.zIndex = AlbumTitleZIndex;
                
                [titleLayoutInfo setObject:titleAttributes forKey:indexPath];
            }
        }
    }
    
    [newLayoutInfo setObject:cellLayoutInfo forKey:BHPhotoAlbumLayoutPhotoCellIdentifier];
    [newLayoutInfo setObject:titleLayoutInfo forKey:BHPhotoAlbumLayoutAlbumTitleIdentifier];
    
    self.layoutInfo = newLayoutInfo;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    __block NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier, NSDictionary *elementsInfo, BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];

    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.layoutInfo objectForKey:BHPhotoAlbumLayoutPhotoCellIdentifier] objectForKey:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [[self.layoutInfo objectForKey:BHPhotoAlbumLayoutAlbumTitleIdentifier] objectForKey:indexPath];
}


#pragma mark - Private

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
    
    CGFloat spacing = self.collectionView.bounds.size.width -
                      self.itemInsets.left -
                      self.itemInsets.right -
                      (self.numberOfColumns * self.itemSize.width);
    
    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacing) * column);
    
    CGFloat originY = self.itemInsets.top + (self.itemSize.height + self.titleHeight + self.interItemSpacingY) * row;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.width);
}

- (CGRect)frameForAlbumTitleAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
    frame.origin.y += frame.size.height;
    frame.size.height = self.titleHeight;
    
    return frame;
}

- (CATransform3D)transformForAlbumPhotoAtIndex:(NSIndexPath *)indexPath
{
    return [[self.rotations objectAtIndex:(indexPath.section * RotationStride + indexPath.row) % RotationCount] CATransform3DValue];
}

@end
