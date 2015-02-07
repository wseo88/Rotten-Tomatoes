//
//  MoviesViewController.m
//  Rotten Tomatoes
//
//  Created by William Seo on 2/3/15.
//  Copyright (c) 2015 William Seo. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 100;

    self.title = @"Movies";

    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    [self reloadMovies:(Boolean *)TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRefresh {
    [self reloadMovies:(Boolean *)FALSE];
}

- (void)reloadMovies:(Boolean *)hasProgressHUD{
    NSString *apiKey = @"ed4tymgz3u9m72rq6tvg3y6p";
    NSString *rottenTomatoesURLString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=%@", apiKey];
    NSURL *url = [NSURL URLWithString:rottenTomatoesURLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    if (hasProgressHUD) {
        [SVProgressHUD showWithStatus:(NSString *)@"Loading..."];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            [self hideNetworkErrorStatusBar];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = responseDictionary[@"movies"];
            [self.tableView reloadData];
        } else {
            if (error) {
                [self handleNetworkError];
            } else {
                [self handleOtherError];
            }
        }
        if(hasProgressHUD) {
            [SVProgressHUD dismiss];
        } else {
            // No need to dismiss
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)handleNetworkError {
    [UIView animateWithDuration:0.25 animations:^{
        self.networkErrorView.frame = CGRectMake(0,[UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height, 320, 35);
    }];
}

- (void)handleOtherError {
    NSLog(@"Other Error");
}

-(void)hideNetworkErrorStatusBar {
    [UIView animateWithDuration:0.25 animations:^{
        self.networkErrorView.frame = CGRectMake(0, -35, 320, 35);
    }];
}

#pragma mark - Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"y-LL-d"];
    NSDate *releaseDate = [dateFormatter dateFromString:movie[@"release_dates"][@"theater"]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = movie[@"title"];
    cell.runtimeLabel.text = [NSString stringWithFormat:@"%@ min", movie[@"runtime"]];
    [dateFormatter setDateFormat:@"ccc, MMM d, y"];
    cell.releaseDateLabel.text = [dateFormatter stringFromDate:releaseDate];
    cell.criticsRatingLabel.text = [NSString stringWithFormat:@"%@%%", movie[@"ratings"][@"critics_score"]];
    cell.audienceRatingLabel.text = [NSString stringWithFormat:@"%@%% ", movie[@"ratings"][@"audience_score"]];
    NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:url]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
