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
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)_pushAction {
  ViewController *vc = [[ViewController alloc] init];
  vc.hidesBottomBarWhenPushed = YES;
  vc.navigationTransitionStyle = self.navigationTransitionStyle;
  [self.navigationController pushViewController:vc animated:YES];
}

@end
