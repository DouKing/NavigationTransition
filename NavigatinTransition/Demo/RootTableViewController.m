//
//  RootTableViewController.m
//  NavigatinTransition
//
//  Created by WuYikai on 2017/11/6.
//  Copyright © 2017年 DouKing. All rights reserved.
//

#import "RootTableViewController.h"
#import "DemoViewController.h"
#import "STMNavigationBar.h"
#import "UIViewController+STMTransition.h"
#import "CustomTransition.h"
#import "UINavigationItem+STMTransition.h"

@interface RootTableViewController ()

@end

@implementation RootTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_handleRightBarButtonItemAction:)];
  self.navigationItem.rightBarButtonItem = rightBarButtonItem;

  UIView *progressView = [[UIView alloc] init];
  progressView.backgroundColor = [UIColor yellowColor];
  progressView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.navigationItem.stm_barTintView addSubview:progressView];
  [progressView.leadingAnchor constraintEqualToAnchor:progressView.superview.leadingAnchor].active = YES;
  [progressView.trailingAnchor constraintEqualToAnchor:progressView.superview.trailingAnchor].active = YES;
  [progressView.bottomAnchor constraintEqualToAnchor:progressView.superview.bottomAnchor].active = YES;
  [progressView.heightAnchor constraintEqualToConstant:2].active = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController *vc = segue.destinationViewController;
  if ([segue.identifier isEqualToString:@"Image"]) {
    vc.stm_animator = [[CustomTransition alloc] init];
  }
}

#pragma mark - Private methods

- (void)_handleRightBarButtonItemAction:(UIBarButtonItem *)sender {
  DemoViewController *vc = [[DemoViewController alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:STMNavigationBar.class toolbarClass:nil];
  nav.viewControllers = @[vc];
  nav.modalPresentationStyle = UIModalPresentationFullScreen;
  // 设置整个导航栈的转场动画
  nav.navigationTransitionStyle = STMNavigationTransitionStyleSystem;
  [self presentViewController:nav animated:YES completion:nil];

  UIBarButtonItem *dismissBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_dismiss)];
  vc.navigationItem.leftBarButtonItem = dismissBarButtonItem;
}

- (void)_dismiss {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end

#import <objc/runtime.h>
#import "STMNavigationResignLeftTransitionAnimator.h"
#import "STMNavigationResignBottomTransitionAnimator.h"

@implementation UIViewController (Demo)

- (STMNavigationBaseTransitionAnimator *)_animatorForTransitionStyle:(STMNavigationTransitionStyle)transitionStyle {
  switch (transitionStyle) {
    case STMNavigationTransitionStyleSystem: {
      return nil;
      break;
    }
    case STMNavigationTransitionStyleResignLeft: {
      return self.resignLeftTransitionAnimator;
      break;
    }
    case STMNavigationTransitionStyleResignBottom: {
      return self.resignBottomTransitionAnimator;
      break;
    }
  }
}

- (STMNavigationResignLeftTransitionAnimator *)resignLeftTransitionAnimator {
  return [[STMNavigationResignLeftTransitionAnimator alloc] init];
}

- (STMNavigationResignBottomTransitionAnimator *)resignBottomTransitionAnimator {
  return [[STMNavigationResignBottomTransitionAnimator alloc] init];
}

- (STMNavigationBaseTransitionAnimator *)baseTransitionAnimator {
  return [[STMNavigationBaseTransitionAnimator alloc] init];
}

- (STMNavigationTransitionStyle)navigationTransitionStyle {
  NSNumber *style = objc_getAssociatedObject(self, @selector(navigationTransitionStyle));
  return [style integerValue];
}

- (void)setNavigationTransitionStyle:(STMNavigationTransitionStyle)navigationTransitionStyle {
  objc_setAssociatedObject(self, @selector(navigationTransitionStyle), @(navigationTransitionStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  self.stm_animator = [self _animatorForTransitionStyle:navigationTransitionStyle];
}

@end

