//
//  PagingNavbar.m
//  PaggingNavigationBar
//
//  Created by Denis Shvetsov on 16/06/15.
//  Copyright (c) 2015 Denis Shvetsov. All rights reserved.
//

#import "PagingNavbar.h"

static const CGFloat PagingNavbarDefaultOffset = 100.f;

@interface PagingNavbar ()

@property (nonatomic, assign) CGFloat width;

@end

@implementation PagingNavbar

#pragma mark - Lifecycle

- (instancetype)initWithTitles:(NSArray *)titles {
    if (self = [super init]) {
        _titles = titles;
        
        _width = [[UIScreen mainScreen] bounds].size.width;
        
        [self setupTitleLabels];
        
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)setupTitleLabels {
    for (NSString *title in _titles) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, 8, _width, 20);
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabels addObject:titleLabel];
        [self addSubview:titleLabel];
    }
}

#pragma mark - Getters

- (UIPageControl *)pageControl {
    if (!_pageControl) {
//        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(_width/2, 35, 0, 0)];
        _pageControl = [UIPageControl new];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _pageControl.frame = (CGRect){_width/2, 25, CGRectGetWidth(self.bounds), 20};
        _pageControl.backgroundColor = [UIColor whiteColor];
        _pageControl.numberOfPages = _titles.count;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageControl;
}

- (NSMutableArray *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    _pageControl.currentPage = currentPage;
}

#pragma mark - Animate

- (void)setContentOffset:(CGPoint)contentOffset {
    _contentOffset = contentOffset;
    
    CGFloat xOffset = contentOffset.x;
    
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *titleLabel, NSUInteger idx, BOOL *stop) {
        if ([titleLabel isKindOfClass:[UILabel class]]) {
            
            // frame
            CGRect titleLabelFrame = titleLabel.frame;
            titleLabelFrame.origin.x = PagingNavbarDefaultOffset * (idx - xOffset / _width - _currentPage + 1);
            titleLabel.frame = titleLabelFrame;
            NSLog(@"origin.x = %f", titleLabelFrame.origin.x);
            
            // alpha
            CGFloat alpha;
            CGFloat x = titleLabel.frame.origin.x;
            if (x > 0) {
                alpha = -x / PagingNavbarDefaultOffset + 1;
            } else {
                alpha =  x / PagingNavbarDefaultOffset + 1;
            }
            titleLabel.alpha = alpha;
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"offset = %f", scrollView.contentOffset.x);
    [self setContentOffset:scrollView.contentOffset];
}


@end
