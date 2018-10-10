//
//  UIViewController+STMTransition.h
//  StromFacilitate
//
//  Created by WuYikai on 16/7/21.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMNavigationTransitionStyle.h"

IB_DESIGNABLE
@interface UIViewController (STMTransition)

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger navigationTransitionStyle;
#else
@property (nonatomic, assign) STMNavigationTransitionStyle navigationTransitionStyle;
#endif

@property (nonatomic, assign) IBInspectable BOOL stm_interactivePopDisabled;

@property (nonatomic, assign) IBInspectable CGFloat stm_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@property (nonatomic, assign) IBInspectable BOOL stm_prefersNavigationBarHidden;

//// adapter for `navigationTransitionStyle`, when you want to use `navigationTransitionStyle` in IB, use this.
//@property (nonatomic, assign) IBInspectable NSInteger navigationTransitionStyleAdapter;

@property (nonatomic, strong) IBInspectable UIColor *stm_barTintColor;

@end
