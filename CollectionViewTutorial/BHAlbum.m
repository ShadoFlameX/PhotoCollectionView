//
//  BHAlbum.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHAlbum.h"
#import "BHPhoto.h"

@interface BHAlbum ()

@property (nonatomic, strong) NSMutableArray *mutablePhotos;

@end

@implementation BHAlbum

#pragma mark - Properties

- (NSArray *)photos
{
    return [self.mutablePhotos copy];
}


#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        self.mutablePhotos = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Photos

- (void)addPhoto:(BHPhoto *)photo
{
    [self.mutablePhotos addObject:photo];
}

- (BOOL)removePhoto:(BHPhoto *)photo
{
    if ([self.mutablePhotos indexOfObject:photo] == NSNotFound) {
        return NO;
    }
    
    [self.mutablePhotos removeObject:photo];
    
    return YES;
}



@end
