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
#import "BHAlbumPhotoCell.h"
#import "BHAlbumTitleReusableView.h"
#import "BHPhotoAlbumLayout.h"
#import "UIColor+CollectionViewTutorial.h"

static dispatch_queue_t PhotoLoadQueue = NULL;

@interface BHCollectionViewController ()

@property (nonatomic, strong) IBOutlet BHPhotoAlbumLayout *photoAlbumLayout;

@end

@implementation BHCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor albumBrowserBackgroundColor];
    
    self.albums = [NSMutableArray array];

    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
	
    for (int a=0; a<20; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"My Album %d",a + 1];

        for (int p=0; p<3; p++) {
            NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg",1]; //TODO: load some other photos
            
            BHPhoto *photo = [BHPhoto photoWithImageURL:[urlPrefix URLByAppendingPathComponent:photoFilename]];
            [album addPhoto:photo];
        }
        
        [self.albums addObject:album];
    }
    
    [self.collectionView registerClass:[BHAlbumPhotoCell class] forCellWithReuseIdentifier:BHPhotoAlbumLayoutPhotoCellIdentifier];
    [self.collectionView registerClass:[BHAlbumTitleReusableView class] forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleIdentifier withReuseIdentifier:BHPhotoAlbumLayoutAlbumTitleIdentifier];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PhotoLoadQueue = dispatch_queue_create("com.skeuo.photo_load_queue", DISPATCH_QUEUE_SERIAL);
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((BHAlbum *)[self.albums objectAtIndex:section]).photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHAlbumPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:BHPhotoAlbumLayoutPhotoCellIdentifier forIndexPath:indexPath];
    
    BHAlbum *album = [self.albums objectAtIndex:indexPath.section];
    BHPhoto *photo = [album.photos objectAtIndex:indexPath.item];
    
    if (indexPath.row == 0) {
        __weak BHCollectionViewController *weakSelf = self;
        dispatch_async(PhotoLoadQueue, ^{
            UIImage *image = [photo image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                    BHAlbumPhotoCell *cell = (BHAlbumPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                    cell.imageView.image = image;
                }
            });
        });
    }

    return photoCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    BHAlbumTitleReusableView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BHPhotoAlbumLayoutAlbumTitleIdentifier forIndexPath:indexPath];
    
    BHAlbum *album = [self.albums objectAtIndex:indexPath.section];
    
    titleView.titleLabel.text = album.name;
    
    return titleView;
}



@end
