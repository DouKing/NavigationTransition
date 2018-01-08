//
//  UIViewController+STMTransition.h
//  StromFacilitate
//
//  Created by WuYikai on 16/7/21.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMNavigationTransitionStyle.h"

@interface UIViewController (STMTransition)

@property (nonatomic, assign) STMNavigationTransitionStyle navigationTransitionStyle;

@property (nonatomic, assign) BOOL stm_interactivePopDisabled;

@property (nonatomic, assign) CGFloat stm_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@property (nonatomic, assign) BOOL stm_prefersNavigationBarHidden;

@end
