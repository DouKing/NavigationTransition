//
//  UIViewController+STMTransition.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/21.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "UIViewController+STMTransition.h"
#import <objc/runtime.h>

@implementation UIViewController (STMTransition)

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

@end
