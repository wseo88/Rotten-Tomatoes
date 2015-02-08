//
//  MovieDetailViewController.m
//  Rotten Tomatoes
//
//  Created by William Seo on 2/4/15.
//  Copyright (c) 2015 William Seo. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, assign) int contentHeight;
@property (nonatomic, assign) bool detailsScrollViewExpanded;
@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self.scrollView setScrollEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewTapped)];
    [self.scrollView addGestureRecognizer:singleTap];
    self.scrollView.frame = CGRectMake(0, 320, 320, 284);
    self.detailsScrollViewExpanded = false;
    [self updateMovieDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMovieDetail {
    [self setAndEnhanceMoviePoster];

    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.movie[@"title"], self.movie[@"mpaa_rating"]];
    self.criticScoreLabel.text =[NSString stringWithFormat:@"%@%%", self.movie[@"ratings"][@"critics_score"]];
    self.audienceScoreLabel.text =[NSString stringWithFormat:@"%@%%", self.movie[@"ratings"][@"audience_score"]];
    [self setRatingIcons:self.criticScoreLabel.text audienceScore:self.audienceScoreLabel.text];
    self.runtimeLabel.text = [NSString stringWithFormat:@"%@ min", self.movie[@"runtime"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"y-LL-d"];
    NSDate *releaseDate = [dateFormatter dateFromString:self.movie[@"release_dates"][@"theater"]];
    [dateFormatter setDateFormat:@"ccc, MMM d, y"];
    self.releaseDateLabel.text = [dateFormatter stringFromDate:releaseDate];

    self.synopsisLabel.text = [NSString stringWithFormat:@"Synopsis: %@", self.movie[@"synopsis"]];
    [self.synopsisLabel sizeToFit];

    self.scrollView.contentSize = CGSizeMake(320, 213 + self.synopsisLabel.frame.size.height);
}

- (void)setAndEnhanceMoviePoster {
    NSString *placeholderURLString = [self.movie valueForKeyPath:@"posters.thumbnail"];
    NSURL  *placeholderUrl = [NSURL URLWithString:placeholderURLString];
    NSData *placeholderUrlData = [NSData dataWithContentsOfURL:placeholderUrl];
    UIImage *placeholderImage=[UIImage imageWithData:placeholderUrlData];
    
     NSString *detailedPosterURLString = [self.movie valueForKeyPath:@"posters.detailed"];
    NSString *detailedPosterUrl = [detailedPosterURLString stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
    [self.posterView setImageWithURL:[NSURL URLWithString:detailedPosterUrl] placeholderImage:placeholderImage];
}

- (void)setRatingIcons:(NSString *)criticsScore audienceScore:(NSString *)audienceScore {
    if ([criticsScore intValue] >= 60) {
        self.criticRatingImageView.image = [UIImage imageNamed:@"like_icon.png"];
    } else {
        self.criticRatingImageView.image = [UIImage imageNamed:@"dislike_icon.png"];
    }
    if ([audienceScore intValue] >= 60) {
        self.audienceRatingImageView.image = [UIImage imageNamed:@"like_icon.png"];
    } else {
        self.audienceRatingImageView.image = [UIImage imageNamed:@"dislike_icon.png"];
    }
}

-(void)handleScrollViewTapped {
    if (self.detailsScrollViewExpanded) {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.frame = CGRectMake(0, 320, 320, 284);
        }];
        self.detailsScrollViewExpanded = false;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.frame = CGRectMake(0, 64, 320, 510);
        }];
        self.detailsScrollViewExpanded = true;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
