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
 * 1. Use only `initWithTitles:pageViewController:` initializer
 * 2. Add as subview to your NavigationBar
 * 3. Set currentPage on `pageViewController:didFinishAnimating:previousViewControllers:transitionCompleted:`
 *    method of your UIPageViewControllerDelegate
 * 4. Set contentOffset on `scrollViewDidScroll:` method on your UIScrollViewDelegate of your UIPageViewController
 */
@interface PagingNavbar : UIView

/**
 * Need to set on pageViewController:didFinishAnimating:previousViewControllers:transitionCompleted:
 * method of your UIPageViewControllerDelegate
 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) CGPoint contentOffset;

@property (nonatomic, readonly) NSMutableArray *titleLabels;

@property (nonatomic, readonly) UIPageControl *pageControl;

- (instancetype)init NS_UNAVAILABLE; 

- (instancetype)initWithTitles:(NSArray *)titles;

@end
