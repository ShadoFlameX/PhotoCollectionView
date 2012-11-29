//
//  UIColor+CollectionViewTutorial.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "UIColor+CollectionViewTutorial.h"

@implementation UIColor (CollectionViewTutorial)

+ (UIColor *)bh_albumBrowserBackgroundColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall"]];
}

+ (UIColor *)bh_photoBackgroundColor
{
    return [UIColor colorWithWhite:0.85f alpha:1.0f];
}

+ (UIColor *)bh_photoBorderColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)bh_albumTitleColor
{
    return [UIColor colorWithWhite:1.0f alpha:1.0f];
}

+ (UIColor *)bh_albumTitleShadowColor
{
    return [UIColor colorWithWhite:0.0f alpha:0.3f];
}

@end
