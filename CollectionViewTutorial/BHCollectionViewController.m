//
//  BHViewController.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHCollectionViewController.h"
#import "BHAlbum.h"
#import "BHPhoto.h"

@interface BHCollectionViewController ()

@end

@implementation BHCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    for (int a=0; a<10; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        
        for (int p=0; p<10; p++) {
            BHPhoto *photo = [BHPhoto photoWithImageURL:nil];
            [album addPhoto:photo];
        }
        
        [self.albums addObject:album];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
