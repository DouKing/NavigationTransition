//
//  RootTableViewController.m
//  NavigatinTransition
//
//  Created by WuYikai on 2017/11/6.
//  Copyright © 2017年 DouKing. All rights reserved.
//

#import "RootTableViewController.h"
#import "CustomTransition.h"

@interface RootTableViewController ()<UINavigationControllerDelegate>

@end

@implementation RootTableViewController

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

@end
