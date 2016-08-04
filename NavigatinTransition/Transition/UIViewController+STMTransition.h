//
//  UIViewController+STMTransition.h
//  StromFacilitate
//
//  Created by WuYikai on 16/7/21.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMNavigationTransitionStyle.h"

@interface UIViewController (STMTransition)

@property (nonatomic, assign) STMNavigationTransitionStyle navigationTransitionStyle;

@end
