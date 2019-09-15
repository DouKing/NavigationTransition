//
// NavigatinTransition
// DemoViewController.m
// Created by DouKing (https://github.com/DouKing) on 2018/9/10.
// Copyright © 2018 DouKing. All rights reserved.

#import "DemoViewController.h"
#import "UIViewController+STMTransition.h"
#import "STMNavigationResignLeftTransitionAnimator.h"

@interface DemoViewController ()

@property (nullable, nonatomic, strong) UIButton *btn;

@end

@implementation DemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.title = @(self.navigationController.viewControllers.count).description;

  [self.view addSubview:self.btn];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  self.btn.center = self.view.center;
}

- (void)_push {
  DemoViewController *vc = [[DemoViewController alloc] init];
  if (self.navigationController.viewControllers.count == 3) {
    // 针对单个 view controller 设置转场动画
    vc.stm_animator = [[STMNavigationResignLeftTransitionAnimator alloc] init];
  }
  [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)btn {
  if (!_btn) {
    _btn = [UIButton buttonWithType:UIButtonTypeSystem];
    _btn.bounds = CGRectMake(0, 0, 100, 50);
    _btn.backgroundColor = [UIColor grayColor];
    _btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btn.layer.borderWidth = 1;
    _btn.layer.cornerRadius = 10;
    [_btn setTitle:@"push" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(_push) forControlEvents:UIControlEventTouchUpInside];
  }
  return _btn;
}

@end
