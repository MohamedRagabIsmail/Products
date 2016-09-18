//
//  Product.h
//  Products
//
//  Created by Mohamed Ragab on 9/11/16.
//  Copyright © 2016 Mohamed Ragab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductImage.h"
#import "AFNetworking.h"



@interface Product : NSObject
@property (nonatomic,retain) NSNumber* productPrice;
@property (nonatomic,retain) NSString* productDescription;
@property (nonatomic, retain) ProductImage* productImage;
@property (nonatomic,retain) NSString* productID;
-(Product*)initWithProductParameters: (NSDictionary*)productParameters;
+(void)PrintProductDataofCount:(int)count from:(int) fromID;
@property (nonatomic,readonly) CGSize cellSize;
@end
