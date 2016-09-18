//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"

@implementation CHTCollectionViewWaterfallCell

#pragma mark - Accessors
- (UIImageView *)imageView {
  if (!_imageView) {
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
  }
  return _imageView;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    
      self.imageURL = [[NSString alloc]init];
      
      [self.contentView addSubview:self.imageView];
      
      UILabel* descriptionLabel = self.descriptionLabel;
      UILabel* priceLabel = self.priceLabel;

      
      [self.contentView addSubview: descriptionLabel];
      [self.contentView bringSubviewToFront: descriptionLabel];
      
      [self.contentView addSubview: priceLabel];
      [self.contentView bringSubviewToFront: priceLabel];
      
      [descriptionLabel sizeToFit]; //added
      descriptionLabel.frame = CGRectMake(0,
                                          self.contentView.bounds.size.height-descriptionLabel.bounds.size.height, self.contentView.bounds.size.width, descriptionLabel.bounds.size.height);
      //[descriptionLabel layoutIfNeeded]; //added
      descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
      descriptionLabel.numberOfLines = 0;
      descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
      //[descriptionLabel setBounds: self.contentView.bounds];
      //[descriptionLabel setCenter:self.contentView.center];
      
      descriptionLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
  }
  return self;
}

- (UILabel*) descriptionLabel {
    if(!_descriptionLabel){
    _descriptionLabel = [[UILabel alloc]init];
    [_descriptionLabel setTextAlignment:NSTextAlignmentCenter];
    [_descriptionLabel setTextColor:[UIColor whiteColor]];
    [_descriptionLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [_descriptionLabel setText:@"Default"];
    
    }
    return _descriptionLabel;
}

- (UILabel*) priceLabel {
    if(!_priceLabel){
        _priceLabel = [[UILabel alloc]init];
        [_priceLabel setTextAlignment:NSTextAlignmentCenter];
        [_priceLabel setTextColor:[UIColor yellowColor]];
        [_priceLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_priceLabel setText:@"Default"];
        
    }
    return _priceLabel;
}


@end
