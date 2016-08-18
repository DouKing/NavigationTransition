//
//  ViewController.m
//  NavigatinTransition
//
//  Created by WuYikai on 16/8/4.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+STM.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.view.backgroundColor = [UIColor stm_randomColor];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(_pushAction)];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)_pushAction {
  ViewController *vc = [[ViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
