//
//  BHReusableImageView.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/6/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHReusableImageView.h"

@interface BHReusableImageView ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation BHReusableImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)prepareForReuse
{
    self.imageView.image = nil;
}

@end
