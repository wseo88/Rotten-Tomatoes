//
//  MovieCell.h
//  Rotten Tomatoes
//
//  Created by William Seo on 2/4/15.
//  Copyright (c) 2015 William Seo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@end
