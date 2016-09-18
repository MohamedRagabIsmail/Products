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
      
      [self.contentView addSubview: descriptionLabel];
      [self.contentView bringSubviewToFront: descriptionLabel];
      
      [descriptionLabel sizeToFit]; //added
      //[descriptionLabel layoutIfNeeded]; //added
      descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
      descriptionLabel.numberOfLines = 0;
      //[descriptionLabel setBounds: self.contentView.bounds];
      //[descriptionLabel setCenter:self.contentView.center];
  }
  return self;
}

- (UILabel*) descriptionLabel {
    if(!_descriptionLabel){
    _descriptionLabel = [[UILabel alloc]init];
    [_descriptionLabel setTextAlignment:NSTextAlignmentCenter];
    [_descriptionLabel setTextColor:[UIColor yellowColor]];
    [_descriptionLabel setFont:[UIFont boldSystemFontOfSize:10]];
        [_descriptionLabel setText:@"Default"];
    
    }
    return _descriptionLabel;
}

@end
