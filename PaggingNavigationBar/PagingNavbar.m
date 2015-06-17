//
//  PagingNavbar.m
//  PaggingNavigationBar
//
//  Created by Denis Shvetsov on 16/06/15.
//  Copyright (c) 2015 Denis Shvetsov. All rights reserved.
//

#import "PagingNavbar.h"

// Horizontal space between titleLabels in points
static const CGFloat PagingNavbarHorizontalSpace = 100.f;

@interface PagingNavbar ()

@property (nonatomic, assign) CGFloat screenWidth;

@end

@implementation PagingNavbar

#pragma mark - Lifecycle

- (instancetype)init {
    NSAssert(NO, @"-init is not a valid initializer for the class PagingNavbar");
    return nil;
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

#pragma mark - Setup

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
            titleLabelFrame.origin.x = PagingNavbarHorizontalSpace * (idx - xOffset / _screenWidth - _currentPage + 1);
            titleLabel.frame = titleLabelFrame;
            
            // alpha
            CGFloat alpha;
            CGFloat x = titleLabel.frame.origin.x;
            if (x > 0) {
                alpha = -x / PagingNavbarHorizontalSpace + 1;
            } else {
                alpha =  x / PagingNavbarHorizontalSpace + 1;
            }
            titleLabel.alpha = alpha;
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self setContentOffset:scrollView.contentOffset];
}

@end
