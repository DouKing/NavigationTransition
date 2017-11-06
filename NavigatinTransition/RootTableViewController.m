//
//  RootTableViewController.m
//  NavigatinTransition
//
//  Created by WuYikai on 2017/11/6.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import "RootTableViewController.h"
#import "UIViewController+STMTransition.h"

@interface RootTableViewController ()

@end

@implementation RootTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController *vc = segue.destinationViewController;
  UITableViewCell *cell = sender;
  NSString *animationName = cell.textLabel.text;
  if ([animationName isEqualToString:@"System"]) {
    vc.navigationTransitionStyle = STMNavigationTransitionStyleSystem;
  } else if ([animationName isEqualToString:@"ResignLeft"]) {
    vc.navigationTransitionStyle = STMNavigationTransitionStyleResignLeft;
  }
}

@end
