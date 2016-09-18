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

@end
