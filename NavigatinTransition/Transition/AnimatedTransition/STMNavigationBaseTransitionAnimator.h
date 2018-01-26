//
//  STMBaseTransitionAnimator.h
//  StromFacilitate
//
//  Created by WuYikai on 16/7/26.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface STMNavigationBaseTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;

- (void)pushAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)popAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

- (UIView *)snapViewFromView:(UIView *)originalView;

@end
