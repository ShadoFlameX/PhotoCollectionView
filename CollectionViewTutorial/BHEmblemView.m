//
//  BHEmblemView.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/6/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHEmblemView.h"

static NSString * const BHEmblemViewImageName = @"emblem";

@implementation BHEmblemView

+ (CGSize)defaultSize
{
    return [UIImage imageNamed:BHEmblemViewImageName].size;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:BHEmblemViewImageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        
        [self addSubview:imageView];
    }
    return self;
}

@end
