//
//  UINavigationItem+STMTransition.m
//  NavigatinTransition
//
//  Created by WuYikai on 2018/1/8.
//  Copyright © 2018年 DouKing. All rights reserved.
//

#import "UINavigationItem+STMTransition.h"
#import <objc/runtime.h>

@implementation UINavigationItem (STMTransition)

- (UIView *)stm_barTintView {
  UIView *barTintView = objc_getAssociatedObject(self, _cmd);
  if (!barTintView) {
    CGRect f = [[UIApplication sharedApplication] statusBarFrame];
    barTintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(f), CGRectGetHeight(f) + 44.0f)];
    self.stm_barTintView = barTintView;
  }
  return barTintView;
}

- (void)setStm_barTintView:(UIView *)stm_barTintView {
  objc_setAssociatedObject(self, @selector(stm_barTintView), stm_barTintView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
