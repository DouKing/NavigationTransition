//
//  STMResignLeftTransitionAnimator.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/25.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "STMNavigationResignLeftTransitionAnimator.h"
#import "STMTransitionSnapshot.h"
#import "UIViewController+STMTransition.h"
#import "UINavigationItem+STMTransition.h"
#import "STMNavigationBar.h"

static NSInteger const kSTMSnapshotViewTag = 19999;

@interface STMNavigationResignLeftTransitionAnimator ()

@property (nonatomic, strong) NSMutableArray<STMTransitionSnapshot *> *cachedSnapShotViews;

@end

@implementation STMNavigationResignLeftTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.25;
}

- (void)pushAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

  UIView *maskView = [[UIView alloc] initWithFrame:containerView.bounds];
  maskView.backgroundColor = [UIColor blackColor];

  UIView *snapShotView = [self snapViewFromView:keyWindow];
  snapShotView.frame = maskView.bounds;
  snapShotView.tag = kSTMSnapshotViewTag;
  [maskView addSubview:snapShotView];

  UIView *layoutView = fromViewController.navigationController.navigationBar.superview;
  [containerView addSubview:maskView];
  if (toViewController.stm_prefersNavigationBarHidden) {
    [layoutView addSubview:toViewController.view];
  } else {
    [containerView addSubview:toViewController.view];
  }
  toViewController.view.transform = CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0);
  toViewController.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0);

  if (toViewController.hidesBottomBarWhenPushed) {
    fromViewController.tabBarController.tabBar.alpha = 0;
  } else {
    fromViewController.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0);
  }

  [toViewController.navigationController setNavigationBarHidden:toViewController.stm_prefersNavigationBarHidden animated:YES];
  toViewController.navigationItem.stm_barTintView.backgroundColor = toViewController.stm_barTintColor;

  [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    toViewController.view.transform = CGAffineTransformIdentity;
    toViewController.navigationController.navigationBar.transform = CGAffineTransformIdentity;
    if (!toViewController.hidesBottomBarWhenPushed) {
      toViewController.tabBarController.tabBar.transform = CGAffineTransformIdentity;
    }
    snapShotView.transform = CGAffineTransformMakeScale(0.95, 0.95);
  } completion:^(BOOL finished) {
    [containerView addSubview:toViewController.view];

    STMTransitionSnapshot *snapshot = [[STMTransitionSnapshot alloc] init];
    snapshot.snapshotView = maskView;
    snapshot.viewController = fromViewController;
    [self.cachedSnapShotViews addObject:snapshot];

    [maskView removeFromSuperview];
    fromViewController.tabBarController.tabBar.alpha = 1;
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

- (void)popAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

  STMTransitionSnapshot *cachedSnapshot = nil;
  UIView *cachedView = nil;
  for (STMTransitionSnapshot *snapshot in self.cachedSnapShotViews) {
    if ([snapshot.viewController isEqual:toViewController]) {
      cachedSnapshot = snapshot;
      cachedView = snapshot.snapshotView;
      cachedView.frame = keyWindow.bounds;
      break;
    }
  }
  if (cachedView) {
    UINavigationBar *navBar = fromViewController.navigationController.navigationBar;
    UIView *snapBarBgView = nil;
    UIView *snapNavBar = nil;
    if ([navBar isKindOfClass:STMNavigationBar.class]) {
      UIView *navBarBgView = [navBar valueForKey:@"barTintBackgroundView"];
      snapBarBgView = [self snapViewFromView:navBarBgView];
      snapBarBgView.frame = navBarBgView.frame;
      [navBar addSubview:snapBarBgView];
      snapNavBar = [self snapViewFromView:navBar];
      snapNavBar.frame = navBar.bounds;
      [navBar addSubview:snapNavBar];
    }

    fromViewController.navigationController.navigationBarHidden = fromViewController.stm_prefersNavigationBarHidden;
    toViewController.tabBarController.tabBar.alpha = 0;
    UIView *tabBar = nil;
    if (fromViewController.tabBarController.tabBar && !fromViewController.hidesBottomBarWhenPushed) {
      tabBar = [keyWindow snapshotViewAfterScreenUpdates:NO];
      tabBar.frame = fromViewController.view.bounds;
      [fromViewController.view addSubview:tabBar];
    }
    [containerView addSubview:cachedView];
    [containerView addSubview:fromViewController.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
      fromViewController.view.transform = CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0);
      fromViewController.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0);
      [cachedView viewWithTag:kSTMSnapshotViewTag].transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
      [snapBarBgView removeFromSuperview];
      [snapNavBar removeFromSuperview];
      toViewController.navigationController.navigationBar.transform = CGAffineTransformIdentity;
      toViewController.tabBarController.tabBar.alpha = 1;
      [cachedView removeFromSuperview];
      [tabBar removeFromSuperview];
      if (![transitionContext transitionWasCancelled]) {
        [self.cachedSnapShotViews removeObject:cachedSnapshot];
      }
      [containerView addSubview:toViewController.view];
      BOOL complete = ![transitionContext transitionWasCancelled];
      if (complete) {
        toViewController.navigationController.navigationBarHidden = toViewController.stm_prefersNavigationBarHidden;
        [fromViewController.navigationItem.stm_barTintView removeFromSuperview];
      } else {
        fromViewController.navigationController.navigationBarHidden = fromViewController.stm_prefersNavigationBarHidden;
      }
      [transitionContext completeTransition:complete];
    }];
  } else {
    [super popAnimateTransition:transitionContext];
  }
}

#pragma mark -

- (NSMutableArray<STMTransitionSnapshot *> *)cachedSnapShotViews {
  if (!_cachedSnapShotViews) {
    _cachedSnapShotViews = [NSMutableArray array];
  }
  return _cachedSnapShotViews;
}

@end
