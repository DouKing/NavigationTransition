//
//  RootTableViewController.h
//  NavigatinTransition
//
//  Created by WuYikai on 2017/11/6.
//  Copyright © 2017年 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


typedef NS_ENUM(NSInteger, STMNavigationTransitionStyle) {
  STMNavigationTransitionStyleSystem,
  STMNavigationTransitionStyleResignLeft,
  STMNavigationTransitionStyleResignBottom,
};

IB_DESIGNABLE
@interface UIViewController (Demo)
#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger navigationTransitionStyle;
#else
@property (nonatomic, assign) STMNavigationTransitionStyle navigationTransitionStyle;
#endif
@end

