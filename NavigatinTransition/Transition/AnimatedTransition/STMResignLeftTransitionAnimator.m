//
//  STMResignLeftTransitionAnimator.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/25.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "STMResignLeftTransitionAnimator.h"
#import "STMTransitionSnapshot.h"

static NSInteger const kSTMSnapshotViewTag = 19999;

@interface STMResignLeftTransitionAnimator ()

@property (nonatomic, strong) NSMutableArray<STMTransitionSnapshot *> *cachedSnapShotViews;

@end

@implementation STMResignLeftTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
  UIView *destinationView = [[keyWindow subviews] firstObject];
  if (UINavigationControllerOperationPush == self.operation) {
    UIView *snapShotView = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:NO];
    [containerView addSubview:toViewController.view];
    
    UIView *maskView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    [keyWindow addSubview:maskView];
    
    snapShotView.frame = maskView.bounds;
    snapShotView.tag = kSTMSnapshotViewTag;
    [maskView addSubview:snapShotView];
    
    [keyWindow bringSubviewToFront:destinationView];
    destinationView.transform = CGAffineTransformMakeTranslation(keyWindow.bounds.size.width, 0);
    
    if (toViewController.hidesBottomBarWhenPushed) {
      fromViewController.tabBarController.tabBar.alpha = 0;
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
      destinationView.transform = CGAffineTransformIdentity;
      snapShotView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
      STMTransitionSnapshot *snapshot = [[STMTransitionSnapshot alloc] init];
      snapshot.snapshotView = maskView;
      snapshot.viewController = fromViewController;
      [self.cachedSnapShotViews addObject:snapshot];
      
      [maskView removeFromSuperview];
      fromViewController.tabBarController.tabBar.alpha = 1;
      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
  } else if (UINavigationControllerOperationPop == self.operation) {
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
      [keyWindow addSubview:cachedView];
      UIView *snapshotView = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:NO];
      snapshotView.frame = keyWindow.bounds;
      [keyWindow addSubview:snapshotView];
      
      [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapshotView.transform = CGAffineTransformMakeTranslation(keyWindow.bounds.size.width, 0);
        [cachedView viewWithTag:kSTMSnapshotViewTag].transform = CGAffineTransformIdentity;
      } completion:^(BOOL finished) {
        [cachedView removeFromSuperview];
        [self.cachedSnapShotViews removeObject:cachedSnapshot];
        [snapshotView removeFromSuperview];
        [containerView addSubview:toViewController.view];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
      }];
    } else {
      [super animateTransition:transitionContext];
    }
    
  } else {
    [super animateTransition:transitionContext];
  }
}

- (NSMutableArray<STMTransitionSnapshot *> *)cachedSnapShotViews {
  if (!_cachedSnapShotViews) {
    _cachedSnapShotViews = [NSMutableArray array];
  }
  return _cachedSnapShotViews;
}

@end
