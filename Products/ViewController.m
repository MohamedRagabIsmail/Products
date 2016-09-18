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
#import "ProductImage.h"
#import "Product.h"
#import "AFNetworking.h"


#define CELL_COUNT 50
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic,strong) NSNumber* trackedLoadingCount;
@property (nonatomic,strong) NSNumber* trackedFromID;

@end

@implementation ViewController

#pragma mark - Accessors


-(void)loadNextProductsArray
{
    
    int count = [self.trackedLoadingCount intValue];
    
    int fromID = [self.trackedFromID intValue];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:[NSString stringWithFormat:@"http://grapesnberries.getsandbox.com/products?from=%i&count=%i",fromID,count] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        //NSLog(@"%@",(NSArray*)responseObject);
        
        NSMutableArray* newIndexPathes = [NSMutableArray array];
        
        for(int i = 0 ; i<CELL_COUNT; i++)
        {
            Product* p = [[Product alloc]initWithProductParameters:[(NSArray*)responseObject objectAtIndex:i]];
            NSLog(@"%@",p.productID);

            [self.products addObject:p];
            NSLog(@"%@", ((Product*)[self.products objectAtIndex:i]).productID);
            
            [newIndexPathes addObject:[NSIndexPath indexPathForItem:self.products.count-1 inSection:0]];
        }
        
        [self.collectionView insertItemsAtIndexPaths:newIndexPathes];
        /*
        int sectionToReload = (int)(([self.products count]/CELL_COUNT)-1);
        
        int sectionToInsert = sectionToReload;

        self.numberOfSectionsInCollectionView = [NSNumber numberWithInt:sectionToReload+1];
        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionToInsert]];

        
        //self.numberOfSectionsInCollectionView = [NSNumber numberWithInt:1+[self.numberOfSectionsInCollectionView intValue]];
        //[self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[self.numberOfSectionsInCollectionView intValue]-1]];
        
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionToReload]];
         */
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    self.trackedFromID = [NSNumber numberWithInt: fromID + count];
}



-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0)
    {
        // then we are at the top
        NSLog(@"Top of Scroll detected!!");
        
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        // then we are at the end
        NSLog(@"End of Scroll detected!!");
        
        [self loadNextProductsArray];
        
        //self.numberOfSectionsInCollectionView = [NSNumber numberWithInt:1+[self.numberOfSectionsInCollectionView intValue]];
        //[self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[self.numberOfSectionsInCollectionView intValue]-1]];
        
        

        

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


#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.products = [[NSMutableArray alloc]init];
    self.trackedLoadingCount = [NSNumber numberWithInteger: CELL_COUNT];
    self.trackedFromID = [NSNumber numberWithInteger: 1];


    [self loadNextProductsArray];
    [self.view addSubview:self.collectionView];
    //self.numberOfSectionsInCollectionView = [NSNumber numberWithInt:1];
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
   
    return [self.products count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  
    return 1;
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
    
    Product* p = [self.products objectAtIndex:indexPath.item ];
    
    cell.imageURL = p.productImage.ProductImageURL;
    
    NSLog(@"%@",cell.imageURL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
        
        UIImage* networkImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:p.productImage.ProductImageURL]]];
        
        if(imageView) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(cell.imageURL == p.productImage.ProductImageURL)
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
    
    cell.descriptionLabel.text = p.productDescription;
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@",p.productPrice];
    [cell.descriptionLabel setBounds: cell.contentView.bounds];
    [cell.descriptionLabel setCenter:cell.contentView.center];
    [cell.priceLabel setFrame:CGRectMake(p.cellSize.width - 50, 30, 50, 15)];
    
    
    [cell.descriptionLabel setFrame: CGRectMake(15, [p cellSize].height/2, [p cellSize].width, [p cellSize].height/2)];
    
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
    
    return [[self.products objectAtIndex:indexPath.item] cellSize];
}

@end
