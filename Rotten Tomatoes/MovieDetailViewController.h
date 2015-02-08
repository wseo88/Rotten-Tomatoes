//
//  MovieDetailViewController.h
//  Rotten Tomatoes
//
//  Created by William Seo on 2/4/15.
//  Copyright (c) 2015 William Seo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) NSDictionary *movie;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *criticScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *audienceScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *criticRatingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *audienceRatingImageView;
@end
