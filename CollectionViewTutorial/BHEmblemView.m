//
//  BHEmblemView.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/6/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHEmblemView.h"

@interface BHEmblemView ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation BHEmblemView

+ (CGSize)defaultSize
{
    return [UIImage imageNamed:@"emblem"].size;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"emblem"];
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
        
        [self addSubview:self.imageView];
    }
    return self;
}

@end
