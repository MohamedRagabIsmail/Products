//
//  Product.m
//  Products
//
//  Created by Mohamed Ragab on 9/11/16.
//  Copyright © 2016 Mohamed Ragab. All rights reserved.
//

#import "Product.h"

#import "AFNetworking.h"

@implementation Product

-(CGSize) cellSize
{
    return CGSizeMake([self.productImage.productImageWidth floatValue], [self.productImage.productImageHeight floatValue]);
}

-(Product*)initWithProductParameters: (NSDictionary*)productParameters
{
    self = [super init];
    if(self)
    {
        
        self.productImage = [[ProductImage alloc] initWithProductImageParameters:productParameters[@"image"]];
        
        self.productPrice = [productParameters[@"price"] isKindOfClass:[NSNull class]] ? [NSNumber numberWithInt:0]
        : productParameters[@"price"];
        
        self.productID = [productParameters[@"id"] isKindOfClass:[NSNull class]] ? @"No ID"
        : productParameters[@"id"];
        
        self.productDescription = [productParameters[@"productDescription"] isKindOfClass:[NSNull class]] ? @""
        : productParameters[@"productDescription"];
        
    }
    return self;
}

+(void)PrintProductDataofCount:(int)count from:(int) fromID
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://grapesnberries.getsandbox.com/products?from=%i&count=%i",fromID,count] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        
        Product* myProduct = [[Product alloc]initWithProductParameters:[(NSArray*)responseObject objectAtIndex:0]];
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[myProduct productPrice]]);
        NSLog(@"%@",[myProduct productDescription]);
        NSLog(@"%@",[myProduct productID]);
        
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[myProduct.productImage productImageWidth]]);
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[myProduct.productImage productImageHeight]]);
        NSLog(@"%@",[myProduct.productImage ProductImageURL]);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

@end
