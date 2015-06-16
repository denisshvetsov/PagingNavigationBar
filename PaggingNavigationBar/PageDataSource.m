//
//  PageDataSource.m
//  PaggingNavigationBar
//
//  Created by Denis Shvetsov on 16/06/15.
//  Copyright (c) 2015 Denis Shvetsov. All rights reserved.
//

#import "PageDataSource.h"

@implementation PageDataSource

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor redColor];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor blueColor];
    return vc;
}

@end
