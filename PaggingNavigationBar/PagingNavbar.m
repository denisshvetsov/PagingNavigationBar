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

- (void)animatePaging:(UIPanGestureRecognizer *)panGestureRecognizer {
    NSLog(@"animate");
//    [self setContentOffset:[panGestureRecognizer locationInView:self]];
//    [self setContentOffset:CGPointMake(100, 100)];
}

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
            
//            titleLabelFrame.origin.x = (idx * (kXHiPad ? 240 : _width / kXHRadie)) - xOffset / kXHRadie + test;
            
//            titleLabelFrame.origin.x = (idx * (kXHiPad ? 240 : 100)) - 100 * xOffset / _width + test;
            
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
    NSLog(@"scrollViewDidScroll offset = %f", scrollView.contentOffset.x);
    [self setContentOffset:scrollView.contentOffset];
//    CGFloat xOffset = scrollView.contentOffset.x;
//
//    NSLog(@"scrollViewDidScroll offset = %f", xOffset);
//    
//    CGFloat wBounds = self.bounds.size.width;
//    CGFloat hBounds = self.bounds.size.height;
//    CGFloat widthOffset = wBounds / 100;
//    CGFloat offsetPosition = 0 - xOffset/widthOffset;
//
////    ((UILabel *)_titleLabels[0]).frame = CGRectMake(offsetPosition, 8, wBounds, 20);
//    UILabel *label = [_titleLabels objectAtIndex:0];
//    label.frame = CGRectMake(0, 0, 10, 10);
//    ((UILabel *)_titleLabels[1]).frame = CGRectMake(offsetPosition + 100, 8, wBounds, 20);
//    ((UILabel *)_titleLabels[2]).frame = CGRectMake(offsetPosition + 200, 8, wBounds, 20);
//    
//    ((UILabel *)_titleLabels[0]).alpha = 1 - xOffset / wBounds;
//    
//    if (xOffset <= wBounds) {
//        ((UILabel *)_titleLabels[1]).alpha = xOffset / wBounds;
//    } else {
//        ((UILabel *)_titleLabels[1]).alpha = 1 - (xOffset - wBounds) / wBounds;
//    }
//    ((UILabel *)_titleLabels[2]).alpha = (xOffset - wBounds) / wBounds;
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat xOffset = scrollView.contentOffset.x;
//    if (xOffset < 1.0) {
//        self.currentPage = 0;
//    } else if (xOffset < self.bounds.size.width + 1) {
//        self.currentPage = 1;
//    } else {
//        self.currentPage = 2;
//    }
//}

@end
