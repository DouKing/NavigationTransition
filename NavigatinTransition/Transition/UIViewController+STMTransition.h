//
//  UIViewController+STMTransition.h
//  StromFacilitate
//
//  Created by WuYikai on 16/7/21.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMNavigationBaseTransitionAnimator.h"

IB_DESIGNABLE
@interface UIViewController (STMTransition)

/// if nil, use system animation
@property (nonatomic, strong) __kindof STMNavigationBaseTransitionAnimator *stm_animator;

@property (nonatomic, assign) IBInspectable BOOL stm_interactivePopDisabled;

@property (nonatomic, assign) IBInspectable CGFloat stm_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@property (nonatomic, assign) IBInspectable BOOL stm_prefersNavigationBarHidden;

@property (nonatomic, strong) IBInspectable UIColor *stm_barTintColor;

@end
