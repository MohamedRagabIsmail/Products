//
//  ViewController.m
//  Products
//
//  Created by Mohamed Ragab on 9/18/16.
//  Copyright © 2016 Mohamed Ragab. All rights reserved.
//

#import "ViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
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
@property (nonatomic,strong) NSCache* imagesCache;

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
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    self.trackedFromID = [NSNumber numberWithInt: fromID + count];
}



-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    // check if the last cell is visibile
    if( [self.collectionView cellForItemAtIndexPath:
         [NSIndexPath indexPathForItem:self.trackedFromID.integerValue-2 inSection:0]])
    {
        // the last cell is visible, load the next items
        [self loadNextProductsArray];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
       // layout.headerHeight = 10;
        layout.footerHeight = 10;
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
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
    self.imagesCache = [[NSCache alloc]init];
    self.trackedLoadingCount = @(CELL_COUNT);
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
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 3 : 4;

    }
    else
    {
        layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
 
    }
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
    
    cell.imageView.image = [self.imagesCache objectForKey:p.productImage.ProductImageURL];
    
    if(cell.imageView.image == nil)
    {
        
        NSLog(@"%@",cell.imageURL);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
            
            UIImage* networkImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:p.productImage.ProductImageURL]]];
            
            if(imageView) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(cell.imageURL == p.productImage.ProductImageURL)
                    {
                        imageView.image = networkImage;
                        [self.imagesCache setObject:imageView.image forKey:p.productImage.ProductImageURL];

                    }
                });
            }
        });
    }
    
    cell.descriptionLabel.text = p.productDescription;
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@",p.productPrice];
    [cell.descriptionLabel setBounds: cell.contentView.bounds];
    [cell.descriptionLabel setCenter:cell.contentView.center];
    [cell.priceLabel setFrame:CGRectMake(p.cellSize.width - 50, 30, 50, 15)];
    
    [cell.descriptionLabel sizeToFit];
    
    [cell.descriptionLabel setFrame: CGRectMake(0, cell.contentView.bounds.size.height - cell.descriptionLabel.bounds.size.height, cell.contentView.bounds.size.width, cell.descriptionLabel.bounds.size.height)];
    
    cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0;
    return cell;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[self.products objectAtIndex:indexPath.item] cellSize];
}

@end
