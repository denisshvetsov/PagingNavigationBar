//
//  PagingNavbar.h
//  PaggingNavigationBar
//
//  Created by Denis Shvetsov on 16/06/15.
//  Copyright (c) 2015 Denis Shvetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Rules:
 * 1. Use `initWithTitles:` or `initWithTitles:horizontalSpace:` initializers
 * 2. horizontalSpace is space between centers of Labels, default value is 100
 * 3. Add as titleView of your UINavigationItem
 * 4. Set currentPage on `pageViewController:didFinishAnimating:previousViewControllers:transitionCompleted:`
 *    method of your UIPageViewControllerDelegate
 * 5. Set contentOffset on `scrollViewDidScroll:` method on your UIScrollViewDelegate of your UIPageViewController
 */
@interface PagingNavbar : UIView

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) CGPoint contentOffset;

@property (nonatomic, readonly) NSMutableArray *titleLabels;

@property (nonatomic, readonly) UIPageControl *pageControl;

- (instancetype)init NS_UNAVAILABLE; 

- (instancetype)initWithTitles:(NSArray *)titles;

- (instancetype)initWithTitles:(NSArray *)titles horizontalSpace:(CGFloat)space;

@end
