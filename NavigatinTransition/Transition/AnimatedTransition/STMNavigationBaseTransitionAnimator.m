//
//  STMBaseTransitionAnimator.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/26.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "STMNavigationBaseTransitionAnimator.h"

@implementation STMNavigationBaseTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  if (UINavigationControllerOperationPush == self.operation) {
    [self pushAnimateTransition:transitionContext];
  } else if (UINavigationControllerOperationPop == self.operation) {
    [self popAnimateTransition:transitionContext];
  } else {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }
}

#pragma mark -

- (void)pushAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  [containerView addSubview:toVC.view];
  toVC.view.transform = CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0);
  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    toVC.view.transform = CGAffineTransformIdentity;
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

- (void)popAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  [containerView addSubview:toVC.view];
  [containerView addSubview:fromVC.view];
  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    fromVC.view.transform = CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0);
  } completion:^(BOOL finished) {
    fromVC.view.transform = CGAffineTransformIdentity;
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}


// iOS10 上系统截图方法失效，以此替代
- (UIView *)snapViewFromView:(UIView *)originalView {
  @autoreleasepool {
    UIView *snapView = [originalView snapshotViewAfterScreenUpdates:NO];
    if (snapView) {
      return snapView;
    }

    UIGraphicsBeginImageContext(originalView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [originalView.layer renderInContext:context];
    UIImage *targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [[UIImageView alloc] initWithImage:targetImage];
  }
}

@end
