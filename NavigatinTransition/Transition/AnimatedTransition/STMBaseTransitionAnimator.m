//
//  STMBaseTransitionAnimator.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/26.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "STMBaseTransitionAnimator.h"

@implementation STMBaseTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  if (UINavigationControllerOperationPush == self.operation) {
    [containerView addSubview:toVC.view];
    toVC.view.transform = CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
      toVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
  } else if (UINavigationControllerOperationPop == self.operation) {
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
      fromVC.view.transform = CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0);
    } completion:^(BOOL finished) {
      fromVC.view.transform = CGAffineTransformIdentity;
      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
  } else {
    [containerView addSubview:toVC.view];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }
}

@end
