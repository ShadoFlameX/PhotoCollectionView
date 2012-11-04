//
//  BHPhotoAlbumLayout.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const BHPhotoAlbumLayoutPhotoCellIdentifier = @"PhotoCell";
static NSString * const BHPhotoAlbumLayoutAlbumTitleIdentifier = @"AlbumTitle";

@interface BHPhotoAlbumLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) CGFloat titleHeight;
@property (nonatomic) NSInteger numberOfColumns;

@end
