//
// NavigatinTransition
// STMNavigationResignBottomTransitionAnimator.m
// Created by DouKing (https://github.com/DouKing) on 2018/1/26.
// Copyright © 2018年 DouKing. All rights reserved.

#import "STMNavigationResignBottomTransitionAnimator.h"
#import "UIViewController+STMTransition.h"
#import "UINavigationItem+STMTransition.h"

#define _NAVIGATIONBAR_HEIGHT_ (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + 44)

@implementation STMNavigationResignBottomTransitionAnimator

- (void)pushAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  [containerView addSubview:toVC.view];

  UITabBar *tabBar = toVC.tabBarController.tabBar;
  UIView *snapTabBar = [self snapViewFromView:tabBar];
  snapTabBar.frame = tabBar.frame;
  [tabBar.superview addSubview:snapTabBar];

  [toVC.navigationController setNavigationBarHidden:toVC.stm_prefersNavigationBarHidden animated:YES];

  toVC.view.transform = CGAffineTransformMakeTranslation(0, containerView.bounds.size.height);
  CGFloat alpha = toVC.hidesBottomBarWhenPushed ? 0 : 1;
  tabBar.alpha = alpha;

  [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    toVC.view.transform = CGAffineTransformIdentity;
    snapTabBar.alpha = alpha;
    toVC.navigationItem.stm_barTintView.backgroundColor = toVC.stm_barTintColor;
    fromVC.navigationItem.stm_barTintView.backgroundColor = [UIColor clearColor];
  } completion:^(BOOL finished) {
    tabBar.alpha = 1;
    [snapTabBar removeFromSuperview];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

- (void)popAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  UITabBar *tabBar = toVC.tabBarController.tabBar;
  [containerView addSubview:toVC.view];
  [containerView addSubview:fromVC.view];

  tabBar.alpha = 0;
  [toVC.navigationController setNavigationBarHidden:toVC.stm_prefersNavigationBarHidden animated:YES];

  [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    fromVC.view.transform = CGAffineTransformMakeTranslation(0, containerView.bounds.size.height);
    toVC.navigationItem.stm_barTintView.backgroundColor = toVC.stm_barTintColor;
    fromVC.navigationItem.stm_barTintView.backgroundColor = [UIColor clearColor];
  } completion:^(BOOL finished) {
    tabBar.alpha = 1;
    fromVC.view.transform = CGAffineTransformIdentity;
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

@end

#undef _NAVIGATIONBAR_HEIGHT_
