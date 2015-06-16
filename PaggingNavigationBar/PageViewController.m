//
//  PageViewController.m
//  PaggingNavigationBar
//
//  Created by Denis Shvetsov on 16/06/15.
//  Copyright (c) 2015 Denis Shvetsov. All rights reserved.
//

#import "PageViewController.h"
#import "PageContentViewController.h"
#import "PagingNavbar.h"

@interface PageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *contentViewControllers;

@property (nonatomic, strong) PagingNavbar *pagingNavbar;

@end

@implementation PageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[@"Recent", @"Day", @"Week", @"Month"];
    _pagingNavbar = [[PagingNavbar alloc] initWithTitles:titles];
    [self.navigationController.navigationBar addSubview:_pagingNavbar];
    
    [self setupViewControllers];
    
    [self setupPageViewController];
    
    // Because Apple doesn't provide access to UIPanGestureRecognizer from UIPageViewController when transition style is Scroll
    for (UIView *view in _pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            scrollView.delegate = _pagingNavbar;
        }
    }
}

#pragma mark - setupViewControllers

- (void)setupViewControllers {
    _contentViewControllers = @[
                                [[PageContentViewController alloc] initWithColor:[UIColor redColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor yellowColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor greenColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor purpleColor]]
                               ];
}

#pragma mark - setupPageViewController

- (void)setupPageViewController {
//    NSDictionary* options = @{UIPageViewControllerOptionInterPageSpacingKey : [NSNumber numberWithFloat:10.0f]};
    _pageViewController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options:nil];
    _pageViewController.dataSource = self;
    _pageViewController.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *startViewController = @[_contentViewControllers[0]];
    [_pageViewController setViewControllers:startViewController
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [_contentViewControllers indexOfObject:(PageContentViewController *)viewController];
    
    _pagingNavbar.currentPage = index;
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;

    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {

    NSUInteger index = [_contentViewControllers indexOfObject:(PageContentViewController *)viewController];
    
    _pagingNavbar.currentPage = index;
    
    if (index + 1 == _contentViewControllers.count || index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (_contentViewControllers.count == 0 || index >= _contentViewControllers.count) {
        return nil;
    }
    return _contentViewControllers[index];
}

@end
