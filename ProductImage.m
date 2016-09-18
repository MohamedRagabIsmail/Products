//
//  ProductImage.m
//  Products
//
//  Created by Mohamed Ragab on 9/11/16.
//  Copyright © 2016 Mohamed Ragab. All rights reserved.
//

#import "ProductImage.h"

@implementation ProductImage

-(ProductImage*) initWithProductImageParameters:(NSDictionary*)productImageParameters
{
    self = [super init];
    if(self)
    {
        self.productImageWidth = [productImageParameters[@"width"] isKindOfClass:[NSNull class]] ? [NSNumber numberWithInt:0]
        : productImageParameters[@"width"];
        
        self.productImageHeight = [productImageParameters[@"height"] isKindOfClass:[NSNull class]] ? [NSNumber numberWithInt:0]
        : productImageParameters[@"height"];
        
        self.ProductImageURL = [productImageParameters[@"url"] isKindOfClass:[NSNull class]] ? @""
        : productImageParameters[@"url"];
    }
    return self;
}


@end
