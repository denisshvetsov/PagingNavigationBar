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

static const CGFloat PagingNavbarTitleLabelsOriginY = -12.f;
static const CGFloat PagingNavbarPageControlOriginY = 14.f;

@interface PagingNavbar ()

@property (nonatomic, assign) CGFloat screenWidth;

@property (nonatomic, assign) CGFloat maxTitleLabelWidth;

@end

@implementation PagingNavbar

#pragma mark - Lifecycle

- (instancetype)init {
    NSAssert(NO, @"-init is not a valid initializer for the class PagingNavbar");
    return nil;
}

- (instancetype)initWithTitles:(NSArray *)titles {
    if (self = [super initWithFrame:CGRectZero]) {
        _titles = titles;
        
        _screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        _maxTitleLabelWidth = 0.f;
        
        [self setupTitleLabels];
        
        [self setupPageControl];
        
    }
    return self;
}

#pragma mark - Setup

//- (void)layoutSubviews {
//
//    _PagingNavbarHorizontalSpace = self.frame.size.width/2;
//    
//    NSLog(@"layoutSubviews frame.width = %f", self.frame.size.width);
//}

- (void)setupTitleLabels {
    _titleLabels = [NSMutableArray array];
    for (NSString *title in _titles) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGRect titleLabelFrame = titleLabel.frame;
        titleLabelFrame.origin.y = PagingNavbarTitleLabelsOriginY;
        titleLabel.frame = titleLabelFrame;
        
        [titleLabel sizeToFit];
        
        if (titleLabel.frame.size.width > _maxTitleLabelWidth) {
            _maxTitleLabelWidth = titleLabel.frame.size.width;
        }
        
        [_titleLabels addObject:titleLabel];
        [self addSubview:titleLabel];
    }
    
    CGRect frame = self.frame;
    NSLog(@"frame.width = %f", frame.size.width);
    NSLog(@"bounds.width = %f", self.bounds.size.width);
    NSLog(@"maxTitleLabelWidth= %f", _maxTitleLabelWidth);
    frame.size.width = _maxTitleLabelWidth;
    self.frame = frame;
}

- (void)setupPageControl {
    _pageControl = [UIPageControl new];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    CGRect pageControlFrame = _pageControl.frame;
    pageControlFrame.origin.y = PagingNavbarPageControlOriginY;
    pageControlFrame.origin.x += self.frame.size.width/2;
    _pageControl.frame = pageControlFrame;
    
    _pageControl.backgroundColor = [UIColor whiteColor];
    _pageControl.numberOfPages = _titles.count;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:_pageControl];
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
//            NSLog(@"frame.width = %f", self.frame.size.width);
            titleLabelFrame.origin.x = self.frame.size.width/2 - titleLabelFrame.size.width/2 + PagingNavbarHorizontalSpace * (idx - xOffset / _screenWidth - _currentPage + 1);
            titleLabel.frame = titleLabelFrame;
            
            // alpha
            CGFloat alpha;
            CGFloat xCenter = titleLabel.frame.origin.x + titleLabelFrame.size.width/2 - self.frame.size.width/2;
            if (xCenter > 0) {
                alpha = -xCenter / PagingNavbarHorizontalSpace + 1;
            } else {
                alpha =  xCenter / PagingNavbarHorizontalSpace + 1;
            }
            titleLabel.alpha = alpha;
        }
    }];
}

@end
