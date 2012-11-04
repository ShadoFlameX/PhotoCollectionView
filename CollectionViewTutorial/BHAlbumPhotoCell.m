//
//  BHAlbumPhotoCell.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHAlbumPhotoCell.h"
#import "UIColor+CollectionViewTutorial.h"
#import "UIColor+CollectionViewTutorial.h"
#import <QuartzCore/QuartzCore.h>

@interface BHAlbumPhotoCell ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation BHAlbumPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor albumPhotoBackgroundColor];
        
        self.layer.borderColor = [UIColor photoBorderColor].CGColor;
        self.layer.borderWidth = 3.0f;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        
        [self addSubview:self.imageView];
    }

    return self;
}

@end
