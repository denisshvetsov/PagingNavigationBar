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
    
    [self setupViewControllers];
    
    [self setupPageViewController];
    
    NSArray *titles = @[@"Red", @"Yellow", @"Green", @"Purple", @"Gray", @"Orange", @"Cyan", @"Brown", @"Blue"];
    
    // Setup PagingNavbar
    _pagingNavbar = [[PagingNavbar alloc] initWithTitles:titles
                                      pageViewController:_pageViewController];
    [self.navigationController.navigationBar addSubview:_pagingNavbar];
}

#pragma mark - setupViewControllers

- (void)setupViewControllers {
    _contentViewControllers = @[
                                [[PageContentViewController alloc] initWithColor:[UIColor redColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor yellowColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor greenColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor purpleColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor lightGrayColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor orangeColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor cyanColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor brownColor]],
                                [[PageContentViewController alloc] initWithColor:[UIColor blueColor]]
                               ];
}

#pragma mark - setupPageViewController

- (void)setupPageViewController {
    _pageViewController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options:nil];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
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
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [_contentViewControllers indexOfObject:(PageContentViewController *)viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {

    NSUInteger index = [_contentViewControllers indexOfObject:(PageContentViewController *)viewController];

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

#pragma mark - UIPageViewControllerDelegate

// Set currentPage for PagingNavbar
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (completed) {
        PageContentViewController *currentController =
            (PageContentViewController *)[self.pageViewController.viewControllers firstObject];
        _pagingNavbar.currentPage = [_contentViewControllers indexOfObject:currentController];
    }
}

@end
