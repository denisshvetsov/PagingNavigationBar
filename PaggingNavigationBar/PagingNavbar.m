//
//  PagingNavbar.m
//  PaggingNavigationBar
//
//  Created by Denis Shvetsov on 16/06/15.
//  Copyright (c) 2015 Denis Shvetsov. All rights reserved.
//

#import "PagingNavbar.h"

static const CGFloat PagingNavbarDefaultTitleLabelsHorizontalSpace = 100.f;
static const CGFloat PagingNavbarTitleLabelsOriginY = -12.f;
static const CGFloat PagingNavbarPageControlOriginY = 14.f;

@interface PagingNavbar ()

@property (nonatomic, assign) CGFloat screenWidth;

@property (nonatomic, assign) CGFloat titleLabelsHorizontalSpace;

@end

@implementation PagingNavbar

#pragma mark - Lifecycle

- (instancetype)init {
    NSAssert(NO, @"-init is not a valid initializer for the class PagingNavbar");
    return nil;
}

- (instancetype)initWithTitles:(NSArray *)titles {
    return [self initWithTitles:titles horizontalSpace:PagingNavbarDefaultTitleLabelsHorizontalSpace];
}


- (instancetype)initWithTitles:(NSArray *)titles horizontalSpace:(CGFloat)space {
    if (self = [super initWithFrame:CGRectZero]) {
        _titles = titles;
        
        _screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        _titleLabelsHorizontalSpace = space;
        
        [self setupTitleLabels];
        
        [self setupPageControl];
    }
    return self;
}

#pragma mark - Setup

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
        
        [_titleLabels addObject:titleLabel];
        [self addSubview:titleLabel];
    }
}

- (void)setupPageControl {
    _pageControl = [UIPageControl new];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    CGRect pageControlFrame = _pageControl.frame;
    pageControlFrame.origin.y = PagingNavbarPageControlOriginY;
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
            titleLabelFrame.origin.x = - titleLabelFrame.size.width/2 + _titleLabelsHorizontalSpace * (idx - xOffset / _screenWidth - _currentPage + 1);
            titleLabel.frame = titleLabelFrame;
            
            // alpha
            CGFloat alpha;
            CGFloat xCenter = titleLabel.frame.origin.x + titleLabelFrame.size.width/2 - self.frame.size.width/2;
            if (xCenter > 0) {
                alpha = -xCenter / _titleLabelsHorizontalSpace + 1;
            } else {
                alpha =  xCenter / _titleLabelsHorizontalSpace + 1;
            }
            titleLabel.alpha = alpha;
        }
    }];
}

@end
