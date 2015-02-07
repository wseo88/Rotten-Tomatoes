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

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self.scrollView setScrollEnabled:YES];
    [self updateMovieDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMovieDetail {
    NSString *posterUrl = [self.movie valueForKeyPath:@"posters.thumbnail"];
    [self.posterView setImageWithURL:[NSURL URLWithString:posterUrl]];
    [self enhanceMoviePoster:posterUrl];

    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.movie[@"title"], self.movie[@"mpaa_rating"]];
    self.criticScoreLabel.text =[NSString stringWithFormat:@"%@%%", self.movie[@"ratings"][@"critics_score"]];
    self.audienceScoreLabel.text =[NSString stringWithFormat:@"%@%%", self.movie[@"ratings"][@"audience_score"]];
    self.runtimeLabel.text = [NSString stringWithFormat:@"%@ min", self.movie[@"runtime"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"y-LL-d"];
    NSDate *releaseDate = [dateFormatter dateFromString:self.movie[@"release_dates"][@"theater"]];
    [dateFormatter setDateFormat:@"ccc, MMM d, y"];
    self.releaseDateLabel.text = [dateFormatter stringFromDate:releaseDate];

    self.synopsisLabel.text = [NSString stringWithFormat:@"Synopsis: %@", self.movie[@"synopsis"]];
    [self.synopsisLabel sizeToFit];
    self.scrollView.frame = CGRectMake(0, 284, 320, 284);
    self.scrollView.contentSize = CGSizeMake(320, 568);
}

- (void)enhanceMoviePoster:(NSString *)posterUrl {
    NSString *enhancedPosterUrl = [posterUrl stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
    [self.posterView setImageWithURL:[NSURL URLWithString:enhancedPosterUrl]];
}

-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
    if (scrollView.contentOffset.y <= 0) {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.frame = CGRectMake(0, 284, 320, 284);
        }];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    [UIView animateWithDuration:0.25 animations:^{
        scrollView.frame = CGRectMake(0, 142, 320, 426);
    }];
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
