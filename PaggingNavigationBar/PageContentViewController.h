//
//  PageContentViewController.h
//  PaggingNavigationBar
//
//  Created by Denis Shvetsov on 16/06/15.
//  Copyright (c) 2015 Denis Shvetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithColor:(UIColor *)color;

@end
