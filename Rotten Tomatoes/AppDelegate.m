//
//  AppDelegate.m
//  Rotten Tomatoes
//
//  Created by William Seo on 2/2/15.
//  Copyright (c) 2015 William Seo. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"
#import "DVDViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    MoviesViewController *moviesVC = [[MoviesViewController alloc] init];
    DVDViewController *dvdVC = [[DVDViewController alloc] init];
    
    UINavigationController *moviesNVC = [[UINavigationController alloc] initWithRootViewController:moviesVC];
    UINavigationController *dvdNVC = [[UINavigationController alloc] initWithRootViewController:dvdVC];
    
    moviesNVC.tabBarItem.title = @"Movie";
    moviesNVC.tabBarItem.image = [UIImage imageNamed:@"movie_icon.png"];
    [moviesNVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    dvdNVC.tabBarItem.title = @"DVD";
    dvdNVC.tabBarItem.image = [UIImage imageNamed:@"dvd_icon.png"];
    [dvdNVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];

    NSArray* controllers = [NSArray arrayWithObjects:moviesNVC, dvdNVC, nil];
    tbc.viewControllers = controllers;
    
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
