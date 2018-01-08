//
//  UIViewController+STMTransition.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/21.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "UIViewController+STMTransition.h"
#import <StromFacilitate/STMObjectRuntime.h>

@implementation UIViewController (STMTransition)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL originalSel = @selector(viewWillAppear:);
    SEL swizzledSel = @selector(stm_viewWillAppear:);
    STMSwizzMethod(self, originalSel, swizzledSel);

    originalSel = @selector(viewDidAppear:);
    swizzledSel = @selector(stm_viewDidAppear:);
    STMSwizzMethod(self, originalSel, swizzledSel);
  });
}

- (void)stm_viewWillAppear:(BOOL)animated {
  [self stm_viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:self.stm_prefersNavigationBarHidden animated:animated];
}

- (void)stm_viewDidAppear:(BOOL)animated {
  [self stm_viewDidAppear:animated];
  self.navigationController.navigationBarHidden = self.stm_prefersNavigationBarHidden;
}

- (STMNavigationTransitionStyle)navigationTransitionStyle {
  NSNumber *style = objc_getAssociatedObject(self, @selector(navigationTransitionStyle));
  if (!style) {
    if ([self isKindOfClass:[UINavigationController class]]) {
      style = @(STMNavigationTransitionStyleSystem);
    } else {
      style = @(STMNavigationTransitionStyleNone);
    }
    self.navigationTransitionStyle = [style integerValue];
  }
  return [style integerValue];
}

- (void)setNavigationTransitionStyle:(STMNavigationTransitionStyle)navigationTransitionStyle {
  if (   [self isKindOfClass:[UINavigationController class]]
      && (STMNavigationTransitionStyleNone == navigationTransitionStyle)) {
    navigationTransitionStyle = STMNavigationTransitionStyleSystem;
  }
  objc_setAssociatedObject(self, @selector(navigationTransitionStyle), @(navigationTransitionStyle), OBJC_ASSOCIATION_RETAIN);
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

@end
