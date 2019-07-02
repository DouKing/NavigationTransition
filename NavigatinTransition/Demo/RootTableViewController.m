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

@interface RootTableViewController ()<UINavigationControllerDelegate>

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
  if ([segue.identifier isEqualToString:@"Image"]) {
    self.navigationController.delegate = self;
  } else {
    self.navigationController.delegate = nil;
  }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
  CustomTransition *transition = [[CustomTransition alloc] init];
  transition.operation = operation;
  return transition;
}

#pragma mark - Private methods

- (void)_handleRightBarButtonItemAction:(UIBarButtonItem *)sender {
  DemoViewController *vc = [[DemoViewController alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:STMNavigationBar.class toolbarClass:nil];
  nav.viewControllers = @[vc];
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
