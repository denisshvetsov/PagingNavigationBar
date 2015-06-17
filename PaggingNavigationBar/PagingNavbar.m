//
//  PagingNavbar.m
//  PaggingNavigationBar
//
//  Created by Denis Shvetsov on 16/06/15.
//  Copyright (c) 2015 Denis Shvetsov. All rights reserved.
//

#import "PagingNavbar.h"

// Расстояние между центром NavigationBar и точкой из которой будет появлятся Label
// Offset between NavigationBar center and begin present point of Label
// Space between titleLabels
static const CGFloat PagingNavbarDefaultHorOffset = 100.f;

@interface PagingNavbar ()

@property (nonatomic, assign) CGFloat screenWidth;

@property (nonatomic, weak) NSArray *contentViewControllers;

@end

@implementation PagingNavbar

#pragma mark - Setup

- (instancetype)init {
    return [self initWithTitles:@[] pageViewController:nil];
}

- (instancetype)initWithTitles:(NSArray *)titles
            pageViewController:(UIPageViewController *)pageViewController {
    if (self = [super init]) {
        _titles = titles;
        
        _screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        [self setupTitleLabels];
        
        [self setupPageControl];
        
        [self setupScrollViewDelegateForPageViewController:pageViewController];
    }
    return self;
}

//- (instancetype)initWithTitles:(NSArray *)titles
//            pageViewController:(UIPageViewController *)pageViewController
//        contentViewControllers:(NSArray *)contentViewControllers {
//    if (self = [super init]) {
//        _titles = titles;
//        
//        _contentViewControllers = contentViewControllers;
//        pageViewController.delegate = self;
//        
//        _screenWidth = [[UIScreen mainScreen] bounds].size.width;
//        
//        [self setupTitleLabels];
//        
//        [self setupPageControl];
//        
//        [self setupScrollViewDelegateForPageViewController:pageViewController];
//    }
//    return self;
//}

- (void)setupTitleLabels {
    _titleLabels = [NSMutableArray array];
    for (NSString *title in _titles) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, 8, _screenWidth, 20);
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabels addObject:titleLabel];
        [self addSubview:titleLabel];
    }
}

- (void)setupPageControl {
    _pageControl = [UIPageControl new];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _pageControl.frame = CGRectMake(_screenWidth/2, 25, CGRectGetWidth(self.bounds), 20);
    _pageControl.backgroundColor = [UIColor whiteColor];
    _pageControl.numberOfPages = _titles.count;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:_pageControl];
}

- (void)setupScrollViewDelegateForPageViewController:(UIPageViewController *)pageViewController {
    for (UIView *view in pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            scrollView.delegate = self;
        }
    }
}

#pragma mark - Setters

- (void)setCurrentPage:(NSInteger)currentPage {
    NSLog(@"currentPage = %lu", (unsigned long) currentPage);
    _currentPage = currentPage;
    _pageControl.currentPage = currentPage;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    _contentOffset = contentOffset;
    
    CGFloat xOffset = contentOffset.x;
    
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *titleLabel, NSUInteger idx, BOOL *stop) {
        if ([titleLabel isKindOfClass:[UILabel class]]) {
            
            // frame
            CGRect titleLabelFrame = titleLabel.frame;
            titleLabelFrame.origin.x = PagingNavbarDefaultHorOffset * (idx - xOffset / _screenWidth - _currentPage + 1);
            titleLabel.frame = titleLabelFrame;
//            NSLog(@"origin.x = %f", titleLabelFrame.origin.x);
            
            // alpha
            CGFloat alpha;
            CGFloat x = titleLabel.frame.origin.x;
            if (x > 0) {
                alpha = -x / PagingNavbarDefaultHorOffset + 1;
            } else {
                alpha =  x / PagingNavbarDefaultHorOffset + 1;
            }
            titleLabel.alpha = alpha;
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"offset = %f", scrollView.contentOffset.x);
    [self setContentOffset:scrollView.contentOffset];
}

//#pragma mark - UIPageViewControllerDelegate
//
//- (void)pageViewController:(UIPageViewController *)pageViewController
//        didFinishAnimating:(BOOL)finished
//   previousViewControllers:(NSArray *)previousViewControllers
//       transitionCompleted:(BOOL)completed {
//    if (completed) {
//        UIViewController *currentController =
//        (UIViewController *)[pageViewController.viewControllers firstObject];
//        self.currentPage = [_contentViewControllers indexOfObject:currentController];
//    }
//}

@end
