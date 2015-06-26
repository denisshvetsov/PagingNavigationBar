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

@interface PageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

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
    
    [self setupPagingNavbar];
    
    [self setupScrollViewDelegate];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidLayoutSubviews width = %f", self.navigationItem.titleView.frame.size.width);
}

#pragma mark - Setup

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

- (void)setupPagingNavbar {
    NSArray *titles = @[@"Red", @"Yellow", @"Green", @"Purple", @"Gray", @"Orange", @"Cyan", @"Brown", @"Blue"];

    _pagingNavbar = [[PagingNavbar alloc] initWithTitles:titles horizontalSpace:50];
    self.navigationItem.titleView = _pagingNavbar;
}

- (void)setupScrollViewDelegate {
    for (UIView *view in _pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            scrollView.delegate = self;
        }
    }
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pagingNavbar.contentOffset = scrollView.contentOffset;
}

@end
