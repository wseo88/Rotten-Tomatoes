//
//  DVDViewController.m
//  Rotten Tomatoes
//
//  Created by William Seo on 2/7/15.
//  Copyright (c) 2015 William Seo. All rights reserved.
//

#import "DVDViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"

@interface DVDViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) NSArray *displayedMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation DVDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.movieSearchBar.delegate = self;
    self.tableView.rowHeight = 100;
    
    self.title = @"DVD";
    self.networkErrorImageView.image = [UIImage imageNamed:@"warning_icon.png"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:1];
    
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
    [self hideNetworkErrorStatusBar];
    NSString *apiKey = @"ed4tymgz3u9m72rq6tvg3y6p";
    NSString *rottenTomatoesURLString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=%@", apiKey];
    NSURL *url = [NSURL URLWithString:rottenTomatoesURLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    if (hasProgressHUD) {
        [SVProgressHUD showWithStatus:(NSString *)@"Loading..."];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = responseDictionary[@"movies"];
            self.displayedMovies = self.movies;
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
        self.networkErrorView.frame = CGRectMake(0,[UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height, 320, 44);
    }];
}

- (void)handleOtherError {
    NSLog(@"Other Error");
}

-(void)hideNetworkErrorStatusBar {
    [UIView animateWithDuration:0.25 animations:^{
        self.networkErrorView.frame = CGRectMake(0, 0, 320, 44);
    }];
}

#pragma mark - Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayedMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.displayedMovies[indexPath.row];
    
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

    [self setRatingIcons:cell criticsScore:cell.criticsRatingLabel.text audienceScore:cell.audienceRatingLabel.text];

    NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:url]];
    [cell.posterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage: nil
        success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
            if (request) {
                [UIView transitionWithView:cell.posterView
                                  duration:0.5f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    [cell.posterView setImage:image];
                                } completion:nil];
                }
            }
        failure:nil
    ];
    return cell;
}

- (void)setRatingIcons:(MovieCell *)cell criticsScore:(NSString *)criticsScore audienceScore:(NSString *)audienceScore {
    if ([criticsScore intValue] >= 60) {
        cell.criticsRatingImageView.image = [UIImage imageNamed:@"like_icon.png"];
    } else {
        cell.criticsRatingImageView.image = [UIImage imageNamed:@"dislike_icon.png"];
    }
    if ([audienceScore intValue] >= 60) {
        cell.audienceRatingImageView.image = [UIImage imageNamed:@"like_icon.png"];
    } else {
        cell.audienceRatingImageView.image = [UIImage imageNamed:@"dislike_icon.png"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    vc.movie = self.displayedMovies[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Search Methods
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        self.displayedMovies = self.movies;
    } else {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", searchText];
        self.displayedMovies = [self.movies filteredArrayUsingPredicate:searchPredicate];
    }
    [self.tableView reloadData];
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
