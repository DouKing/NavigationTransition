//
//  UINavigationController+STMTransition.h
//  StromFacilitate
//
//  Created by WuYikai on 16/7/20.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMNavigationTransitionStyle.h"

@interface UINavigationController (STMTransition)

@property (nonatomic, assign) STMNavigationTransitionStyle transitionStyle;

@end
