//
//  ProductImage.h
//  Products
//
//  Created by Mohamed Ragab on 9/11/16.
//  Copyright © 2016 Mohamed Ragab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductImage : NSObject
@property (nonatomic,retain) NSNumber* productImageWidth;
@property (nonatomic,retain) NSNumber* productImageHeight;
@property (nonatomic,retain) NSString* ProductImageURL;
-(ProductImage*) initWithProductImageParameters:(NSDictionary*)productImageparameters;
@end
