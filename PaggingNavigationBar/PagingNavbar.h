//
//  PagingNavbar.h
//  PaggingNavigationBar
//
//  Created by Denis Shvetsov on 16/06/15.
//  Copyright (c) 2015 Denis Shvetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagingNavbar : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *titleLabels;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) CGPoint contentOffset;

- (instancetype)initWithTitles:(NSArray *)titles;

- (void)animatePaging:(UIPanGestureRecognizer *)panGestureRecognizer;

@end
