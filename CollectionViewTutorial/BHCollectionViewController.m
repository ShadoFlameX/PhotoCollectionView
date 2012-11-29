//
//  BHViewController.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHCollectionViewController.h"
#import "BHAlbumPhotoCell.h"
#import "BHPhotoAlbumLayout.h"
#import "BHAlbum.h"
#import "BHPhoto.h"
#import "BHAlbumTitleReusableView.h"
#import "UIColor+CollectionViewTutorial.h"

static NSInteger const PhotoCount = 25;

@interface BHCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) IBOutlet BHPhotoAlbumLayout *photoAlbumLayout;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@end

@implementation BHCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor bh_albumBrowserBackgroundColor];
    
    self.albums = [NSMutableArray array];

    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
	
    NSInteger photoIndex = 0;
    
    for (NSUInteger a = 0; a < 12; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %d",a + 1];
        
        NSUInteger photoCount = arc4random()%4 + 2;
        for (NSUInteger p = 0; p < photoCount; p++) {
            // there are up to 25 photos available to load from the code repository
            NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg",photoIndex % 25];
            NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            [album addPhoto:photo];
            
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
    
    [self.collectionView registerClass:[BHAlbumPhotoCell class]
            forCellWithReuseIdentifier:BHPhotoAlbumLayoutPhotoCellIdentifier];
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleIdentifier
                   withReuseIdentifier:BHPhotoAlbumLayoutAlbumTitleIdentifier];
    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.photoAlbumLayout.numberOfColumns = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
                            45.0f : 25.0f;
        
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    } else {
        self.photoAlbumLayout.numberOfColumns = 2;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((BHAlbum *)self.albums[section]).photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHAlbumPhotoCell *photoCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:BHPhotoAlbumLayoutPhotoCellIdentifier
                                                  forIndexPath:indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    BHPhoto *photo = album.photos[indexPath.item];
    
    // load photo images in the background
    __weak BHCollectionViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [photo image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                BHAlbumPhotoCell *cell =
                    (BHAlbumPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
        });
    }];
    
    operation.queuePriority = (indexPath.item == 0) ?
        NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumbnailQueue addOperation:operation];

    return photoCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    BHAlbumTitleReusableView *titleView =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:BHPhotoAlbumLayoutAlbumTitleIdentifier
                                                  forIndexPath:indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    
    titleView.titleLabel.text = album.name;
    
    return titleView;
}

@end
