//
//  PagingNavbar.h
//  PaggingNavigationBar
//
//  Created by Denis Shvetsov on 16/06/15.
//  Copyright (c) 2015 Denis Shvetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Add as subview to your NavigationBar
 */
@interface PagingNavbar : UIView <UIScrollViewDelegate>

/**
 * Need to set on pageViewController:didFinishAnimating:previousViewControllers:transitionCompleted:
 * method of your UIPageViewControllerDelegate
 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) CGPoint contentOffset;

@property (nonatomic, readonly) NSMutableArray *titleLabels;

@property (nonatomic, readonly) UIPageControl *pageControl;

- (instancetype)initWithTitles:(NSArray *)titles
            pageViewController:(UIPageViewController *)pageViewController;

@end
