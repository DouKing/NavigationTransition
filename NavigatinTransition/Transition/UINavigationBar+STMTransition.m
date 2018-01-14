//
//  UINavigationBar+STMTransition.m
//  NavigatinTransition
//
//  Created by WuYikai on 2018/1/8.
//  Copyright © 2018年 DouKing. All rights reserved.
//

#import "UINavigationBar+STMTransition.h"
#import <STMObjectRuntime.h>

@interface UINavigationBar ()

@property (nonatomic, strong) UIView *stm_barTintBackgroundView;
@property (nonatomic, strong) UIView *stm_barBackgroundView;

@end

@implementation UINavigationBar (STMTransition)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL originalSel = @selector(layoutSubviews);
    SEL swizzledSel = @selector(stm_layoutSubviews);
    STMSwizzMethod(self, originalSel, swizzledSel);
  });
}

- (void)stm_layoutSubviews {
  [self stm_layoutSubviews];
  self.stm_barTintBackgroundView.frame = self.stm_barBackgroundView.frame;
  if (!self.stm_barTintBackgroundView.superview) {
    [self.stm_barBackgroundView.superview insertSubview:self.stm_barTintBackgroundView
                                           aboveSubview:self.stm_barBackgroundView];
  }
}

- (UIView *)stm_barBackgroundView {
  __block UIView *bgView = objc_getAssociatedObject(self, _cmd);
  if (!bgView) {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
        bgView = obj;
        self.stm_barBackgroundView = obj;
        *stop = YES;
        return;
      }
    }];
  }
  return bgView;
}

- (void)setStm_barBackgroundView:(UIView *)stm_barBackgroundView {
  objc_setAssociatedObject(self, @selector(stm_barBackgroundView), stm_barBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)stm_barTintBackgroundView {
  UIView *barTintBackgroundView = objc_getAssociatedObject(self, _cmd);
  if (!barTintBackgroundView) {
    barTintBackgroundView = [[UIView alloc] initWithFrame:self.stm_barBackgroundView.frame];
    barTintBackgroundView.backgroundColor = [UIColor redColor];
    self.stm_barTintBackgroundView = barTintBackgroundView;
  }
  return barTintBackgroundView;
}

- (void)setStm_barTintBackgroundView:(UIView *)stm_barTintBackgroundView {
  objc_setAssociatedObject(self,
                           @selector(stm_barTintBackgroundView),
                           stm_barTintBackgroundView,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
