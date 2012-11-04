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
    return [UIColor colorWithWhite:0.5f alpha:1.0f];
}

+ (UIColor *)photoBackgroundColor
{
    return [UIColor colorWithWhite:0.85f alpha:1.0f];
}

+ (UIColor *)photoBorderColor
{
    return [UIColor whiteColor];
}

@end
