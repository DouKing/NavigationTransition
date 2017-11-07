//
//  ViewController.m
//  NavigatinTransition
//
//  Created by WuYikai on 16/8/4.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+STM.h"
#import "UIViewController+STMTransition.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = UIColor.stm_randomColor;
  UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
  btn.backgroundColor = [UIColor whiteColor];
  btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
  btn.layer.borderWidth = 1;
  btn.layer.cornerRadius = 5;
  btn.clipsToBounds = YES;
  [btn addTarget:self action:@selector(_pushAction) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn];
  btn.center = self.view.center;
}

- (BOOL)stm_prefersNavigationBarHidden {
  if (self.navigationController.viewControllers.count % 2) {
    return YES;
  }
  return NO;
}

- (void)_pushAction {
  ViewController *vc = [[ViewController alloc] init];
  vc.hidesBottomBarWhenPushed = YES;
  vc.navigationTransitionStyle = self.navigationTransitionStyle;
  [self.navigationController pushViewController:vc animated:YES];
}

@end
