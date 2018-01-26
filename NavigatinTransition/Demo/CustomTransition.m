//
// NavigatinTransition
// CustomTransition.m
// Created by DouKing (https://github.com/DouKing) on 2018/1/26.
// Copyright © 2018年 DouKing. All rights reserved.

#import "CustomTransition.h"
#import "RootTableViewController.h"
#import "ViewController.h"

@implementation CustomTransition

- (void)pushAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  RootTableViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  ViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [transitionContext containerView];

  toVC.view.frame = containerView.bounds;
  [containerView addSubview:toVC.view];

  UIImageView *fromImageView = fromVC.imageView;
  CGRect fromFrame = [fromImageView.superview convertRect:fromImageView.frame toView:containerView];
  UIImageView *toImageView = toVC.imageView;
  CGRect toFrame = [toImageView.superview convertRect:toImageView.frame toView:containerView];

  UIImageView *animatedImageView = [[UIImageView alloc] initWithImage:fromImageView.image];
  animatedImageView.frame = fromFrame;
  [containerView addSubview:animatedImageView];

  fromImageView.alpha = 0;
  toImageView.alpha = 0;
  toVC.view.alpha = 0;

  [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    animatedImageView.frame = toFrame;
    animatedImageView.center = containerView.center;
    toVC.view.alpha = 1;
  } completion:^(BOOL finished) {
    fromImageView.alpha = 1;
    toImageView.alpha = 1;
    [animatedImageView removeFromSuperview];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

- (void)popAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  ViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  RootTableViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = [transitionContext containerView];

  [containerView addSubview:toVC.view];
  [containerView addSubview:fromVC.view];

  UIImageView *fromImageView = fromVC.imageView;
  CGRect fromFrame = [fromImageView.superview convertRect:fromImageView.frame toView:containerView];
  UIImageView *toImageView = toVC.imageView;
  CGRect toFrame = [toImageView.superview convertRect:toImageView.frame toView:containerView];

  UIImageView *animatedImageView = [[UIImageView alloc] initWithImage:fromImageView.image];
  animatedImageView.frame = fromFrame;
  [containerView addSubview:animatedImageView];

  fromImageView.alpha = 0;
  toImageView.alpha = 0;

  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    fromVC.view.alpha = 0;
    animatedImageView.frame = toFrame;
  } completion:^(BOOL finished) {
    BOOL completed = ![transitionContext transitionWasCancelled];
    if (completed) {
      toImageView.alpha = 1;
      [animatedImageView removeFromSuperview];
    }
    [transitionContext completeTransition:completed];
  }];
}

@end
