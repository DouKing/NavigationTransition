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
    style = @(STMNavigationTransitionStyleNone);
    self.navigationTransitionStyle = [style integerValue];
  }
  return [style integerValue];
}

- (void)setNavigationTransitionStyle:(STMNavigationTransitionStyle)navigationTransitionStyle {
  objc_setAssociatedObject(self, @selector(navigationTransitionStyle), @(navigationTransitionStyle), OBJC_ASSOCIATION_RETAIN);
}

@end
