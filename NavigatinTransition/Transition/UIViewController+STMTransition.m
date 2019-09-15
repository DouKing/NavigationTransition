//
//  UIViewController+STMTransition.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/21.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "UIViewController+STMTransition.h"
#import "_STMNavigationTransitionDefines.h"
#import "UINavigationItem+STMTransition.h"
#import "UINavigationController+STMTransition.h"

@implementation UIViewController (STMTransition)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL originalSel = @selector(viewWillAppear:);
    SEL swizzledSel = @selector(stm_viewWillAppear:);
    STMNavigationTransitionSwizzMethod(self, originalSel, swizzledSel);

    originalSel = @selector(viewDidAppear:);
    swizzledSel = @selector(stm_viewDidAppear:);
    STMNavigationTransitionSwizzMethod(self, originalSel, swizzledSel);

    originalSel = @selector(viewWillDisappear:);
    swizzledSel = @selector(stm_viewWillDisappear:);
    STMNavigationTransitionSwizzMethod(self, originalSel, swizzledSel);
  });
}

- (void)stm_viewWillAppear:(BOOL)animated {
  [self stm_viewWillAppear:animated];

  if ([self _autoChangeNavigationBar]) {
    [self.navigationController setNavigationBarHidden:self.stm_prefersNavigationBarHidden animated:animated];
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
      self.navigationItem.stm_barTintView.backgroundColor = self.stm_barTintColor ?: [UIColor clearColor];
      self.navigationItem.stm_barTintView.alpha = 1;
    } completion:nil];
  }
}

- (void)stm_viewDidAppear:(BOOL)animated {
  [self stm_viewDidAppear:animated];

  if ([self _autoChangeNavigationBar]) {
    self.navigationController.navigationBarHidden = self.stm_prefersNavigationBarHidden;
  }
}

- (void)stm_viewWillDisappear:(BOOL)animated {
  [self stm_viewWillDisappear:animated];

  if ([self _autoChangeNavigationBar]) {
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
      self.navigationItem.stm_barTintView.backgroundColor = [UIColor clearColor];
      self.navigationItem.stm_barTintView.alpha = 0;
    } completion:nil];
  }
}

- (BOOL)_autoChangeNavigationBar {
  return !self.stm_animator;//使用系统动画
}

- (STMNavigationBaseTransitionAnimator *)stm_animator {
  STMNavigationBaseTransitionAnimator *animator = objc_getAssociatedObject(self, _cmd);
  if (!animator) {
    return self.navigationController.stm_animator;
  }
  return animator;
}

- (void)setStm_animator:(__kindof STMNavigationBaseTransitionAnimator *)stm_animator {
  objc_setAssociatedObject(self, @selector(stm_animator), stm_animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)stm_interactivePopDisabled {
  return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setStm_interactivePopDisabled:(BOOL)stm_interactivePopDisabled {
  objc_setAssociatedObject(self, @selector(stm_interactivePopDisabled), @(stm_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)stm_interactivePopMaxAllowedInitialDistanceToLeftEdge {
#if CGFLOAT_IS_DOUBLE
  return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
  return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setStm_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance {
  SEL key = @selector(stm_interactivePopMaxAllowedInitialDistanceToLeftEdge);
  objc_setAssociatedObject(self, key, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)stm_prefersNavigationBarHidden {
  return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setStm_prefersNavigationBarHidden:(BOOL)hidden {
  objc_setAssociatedObject(self, @selector(stm_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setStm_barTintColor:(UIColor *)stm_barTintColor {
  objc_setAssociatedObject(self, @selector(stm_barTintColor), stm_barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)stm_barTintColor {
  return objc_getAssociatedObject(self, _cmd);
}

@end
