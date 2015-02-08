//
//  DVDViewController.h
//  Rotten Tomatoes
//
//  Created by William Seo on 2/7/15.
//  Copyright (c) 2015 William Seo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;
@property (weak, nonatomic) IBOutlet UIImageView *networkErrorImageView;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;
@end
