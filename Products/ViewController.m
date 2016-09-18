//
//  ViewController.m
//  Products
//
//  Created by Mohamed Ragab on 9/18/16.
//  Copyright © 2016 Mohamed Ragab. All rights reserved.
//

#import "ViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface ViewController ()
@property (nonatomic, strong) NSArray *cellSizes;
@property (nonatomic, strong) NSArray *cats;
@property (nonatomic, strong) NSNumber* scrollViewDidScroll;
@property (nonatomic, strong) NSNumber* numberOfSectionsInCollectionView;

@end

@implementation ViewController

#pragma mark - Accessors

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0)
    {
        // then we are at the top
        NSLog(@"Top of Scroll detected!!");
        //[scrollView setContentOffset:CGPointMake(scrollOffset-scrollViewHeight, 0)];
        
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        // then we are at the end
        NSLog(@"End of Scroll detected!!");
        //[scrollView setContentOffset:CGPointMake(scrollOffset+scrollViewHeight, 0)];
        self.numberOfSectionsInCollectionView = [NSNumber numberWithInt:1+[self.numberOfSectionsInCollectionView intValue]];
        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[self.numberOfSectionsInCollectionView intValue]-1]];
        
        
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 15;
        layout.footerHeight = 10;
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 30;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

- (NSArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = @[
                       /*[NSValue valueWithCGSize:CGSizeMake(400, 550)],
                        [NSValue valueWithCGSize:CGSizeMake(1000, 665)],
                        [NSValue valueWithCGSize:CGSizeMake(1024, 689)],
                        [NSValue valueWithCGSize:CGSizeMake(640, 427)]
                        */
                       [NSValue valueWithCGSize:CGSizeMake(150, 372)],
                       [NSValue valueWithCGSize:CGSizeMake(150, 468)],
                       [NSValue valueWithCGSize:CGSizeMake(150, 367)],
                       [NSValue valueWithCGSize:CGSizeMake(150, 321)]
                       ];
    }
    return _cellSizes;
}

- (NSArray *)cats {
    if (!_cats) {
        //_cats = @[@"cat1.jpg", @"cat2.jpg", @"cat3.jpg", @"cat4.jpg"];
        _cats = @[@"http://lorempixel.com/150/372/city/id-1", @"http://lorempixel.com/150/468/city/id-2", @"http://lorempixel.com/150/367/city/id-3", @"http://lorempixel.com/150/321/city/id-4"];
    }
    return _cats;
}

#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.scrollViewDidScroll = [NSNumber numberWithBool:false];
    self.numberOfSectionsInCollectionView = [NSNumber numberWithInt:2];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return CELL_COUNT;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    /*
     if(self.scrollViewDidScroll)
     {
     int value = [self.numberOfSectionsInCollectionView intValue];
     self.numberOfSectionsInCollectionView = [NSNumber numberWithInt:value + 1];
     return [self.numberOfSectionsInCollectionView intValue];
     }*/
    return [self.numberOfSectionsInCollectionView intValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.imageView.image = nil;
    //cell.imageView.image = [UIImage imageNamed:self.cats[indexPath.item % 4]];
    
    __weak UIImageView* imageView = cell.imageView;
    cell.imageURL = self.cats[indexPath.item % 4];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
        
        UIImage* networkImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.cats[indexPath.item % 4]]]];
        
        if(imageView) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(cell.imageURL == self.cats[indexPath.item % 4])
                {
                    imageView.image = networkImage;
                }
            });
        }
    });
    
    /*
     UIImage* cellImage = [[UIImage alloc]init];
     NSArray* passedArgumentsArray = [NSArray arrayWithObjects:indexPath,cellImage,nil];
     [self performSelectorInBackground:@selector(downloadCellImage:) withObject:passedArgumentsArray];
     cell.imageView.image = [passedArgumentsArray objectAtIndex:1];
     */
    
    cell.descriptionLabel.text = @"A lot of more text for test!! A lot of more text for test!!";
    //[cell.descriptionLabel setBounds: cell.contentView.bounds];
    //[cell.descriptionLabel setCenter:cell.contentView.center];
    
    
    [cell.descriptionLabel setFrame: CGRectMake(0, [self.cellSizes[indexPath.item % 4] CGSizeValue].height/2, [self.cellSizes[indexPath.item % 4] CGSizeValue].width, [self.cellSizes[indexPath.item % 4] CGSizeValue].height/2)];
    
    return cell;
}
/*
 -(void)downloadCellImage:(NSArray*)arg
 {
 NSIndexPath* indexPath = [arg objectAtIndex:0];
 UIImage* returnedImage = [arg objectAtIndex:1];
 returnedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.cats[indexPath.item % 4]]]];
 }
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.item % 4] CGSizeValue];
}

@end
