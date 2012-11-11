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

static NSInteger const PhotoCount = 25;

@interface BHCollectionViewController ()

@property (nonatomic, strong) IBOutlet BHPhotoAlbumLayout *photoAlbumLayout;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@end

@implementation BHCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall"]];
    
    self.albums = [NSMutableArray array];

    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
	
    NSInteger photoIndex = 0;
    
    for (int a=0; a<12; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %d",a + 1];

        for (int p=0; p<arc4random()%4 + 2; p++) {
            NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg",photoIndex % PhotoCount];
            BHPhoto *photo = [BHPhoto photoWithImageURL:[urlPrefix URLByAppendingPathComponent:photoFilename]];
            [album addPhoto:photo];
            
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
    
    [self.collectionView registerClass:[BHAlbumPhotoCell class] forCellWithReuseIdentifier:BHPhotoAlbumLayoutPhotoCellIdentifier];
    [self.collectionView registerClass:[BHAlbumTitleReusableView class] forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleIdentifier withReuseIdentifier:BHPhotoAlbumLayoutAlbumTitleIdentifier];
    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
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
    
    __weak BHCollectionViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [photo image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                BHAlbumPhotoCell *cell = (BHAlbumPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
        });
    }];
    
    operation.queuePriority = (indexPath.row == 0) ?
        NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumbnailQueue addOperation:operation];

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
