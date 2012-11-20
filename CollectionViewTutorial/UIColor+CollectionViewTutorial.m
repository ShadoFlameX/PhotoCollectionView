//
//  UIColor+CollectionViewTutorial.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "UIColor+CollectionViewTutorial.h"

@implementation UIColor (CollectionViewTutorial)

+ (UIColor *)albumBrowserBackgroundColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall"]];
}

+ (UIColor *)photoBackgroundColor
{
    return [UIColor colorWithWhite:0.85f alpha:1.0f];
}

+ (UIColor *)photoBorderColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)albumTitleColor
{
    return [UIColor colorWithWhite:1.0f alpha:1.0f];
}

+ (UIColor *)albumTitleShadowColor
{
    return [UIColor colorWithWhite:0.0f alpha:0.3f];
}

@end
