//
// NavigatinTransition
// STMNavigationBar.m
// Created by DouKing (https://github.com/DouKing) on 2018/7/29.

#import "STMNavigationBar.h"
#import "UINavigationItem+STMTransition.h"

@interface STMNavigationBar ()

@property (nonatomic, strong) UIView *barBackgroundView;
@property (nonatomic, strong) UIView *barTintBackgroundView;

@end


@implementation STMNavigationBar

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.items enumerateObjectsUsingBlock:^(UINavigationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.barTintBackgroundView.subviews containsObject:obj.stm_barTintView]) {
            [self.barTintBackgroundView addSubview:obj.stm_barTintView];
        }
    }];
}

- (void)pushNavigationItem:(UINavigationItem *)item animated:(BOOL)animated {
  [super pushNavigationItem:item animated:animated];
  [self.barTintBackgroundView addSubview:item.stm_barTintView];
}

- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated {
  UINavigationItem *item = [super popNavigationItemAnimated:animated];
  [item.stm_barTintView removeFromSuperview];
  return item;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.barTintBackgroundView.frame = self.barBackgroundView.frame;
  if (!self.barTintBackgroundView.superview) {
    [self.barBackgroundView.superview insertSubview:self.barTintBackgroundView
                                       aboveSubview:self.barBackgroundView];
  }
}

- (UIView *)barBackgroundView {
  if (!_barBackgroundView) {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
        _barBackgroundView = obj;
        *stop = YES;
        return;
      }
    }];
  }
  return _barBackgroundView;
}

- (UIView *)barTintBackgroundView {
  if (!_barTintBackgroundView) {
    _barTintBackgroundView = [[UIView alloc] init];
  }
  return _barTintBackgroundView;
}

@end
