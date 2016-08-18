//
//  STMNavigatonController.m
//  NavigatinTransition
//
//  Created by WuYikai on 16/8/18.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "STMNavigationController.h"
#import "STMBaseTransitionAnimator.h"
#import "STMResignLeftTransitionAnimator.h"

@interface STMNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) STMBaseTransitionAnimator *baseTransitionAnimator;
@property (nonatomic, strong) STMResignLeftTransitionAnimator *resignLeftTransitionAnimator;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic, assign) BOOL interacting;

@end

@implementation STMNavigationController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleInteractionPopGesture:)];
  gesture.edges = UIRectEdgeLeft;
  [self.view addGestureRecognizer:gesture];
}

- (STMBaseTransitionAnimator *)_animatorForTransitionStyle:(STMNavigationTransitionStyle)transitionStyle {
  switch (transitionStyle) {
    case STMNavigationTransitionStyleSystem: {
      return nil;
      break;
    }
    case STMNavigationTransitionStyleResignLeft: {
      return self.resignLeftTransitionAnimator;
      break;
    }
    case STMNavigationTransitionStyleNone: {
      return self.baseTransitionAnimator;
      break;
    }
  }
}

- (void)_handleInteractionPopGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
  UIView *view = gesture.view;
  CGFloat x = [gesture translationInView:view].x;
  CGFloat percent = fmin(fmax((x / CGRectGetWidth(view.bounds)), 0.0), 1.0);
  switch (gesture.state) {
    case UIGestureRecognizerStateBegan: {
      self.interacting = YES;
      [self popViewControllerAnimated:YES];
      break;
    }
    case UIGestureRecognizerStateChanged: {
      [self.interactionController updateInteractiveTransition:percent];
      break;
    }
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled: {
      if (self.interacting) {
        if (percent > 0.5) {
          [self.interactionController finishInteractiveTransition];
        } else {
          [self.interactionController cancelInteractiveTransition];
        }
        self.interacting = NO;
      }
      break;
    }
    default:
      break;
  }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
  return self.interacting ? self.interactionController : nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
  STMNavigationTransitionStyle transitionStyle = (UINavigationControllerOperationPush == operation) ? toVC.navigationTransitionStyle : fromVC.navigationTransitionStyle;
  STMBaseTransitionAnimator *animator = [self _animatorForTransitionStyle:transitionStyle];
  animator.operation = operation;
  return animator;
}

#pragma mark - setter & getter

- (UIPercentDrivenInteractiveTransition *)interactionController {
  if (!_interactionController) {
    _interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
  }
  return _interactionController;
}

- (STMResignLeftTransitionAnimator *)resignLeftTransitionAnimator {
  if (!_resignLeftTransitionAnimator) {
    _resignLeftTransitionAnimator = [[STMResignLeftTransitionAnimator alloc] init];
  }
  return _resignLeftTransitionAnimator;
}

- (STMBaseTransitionAnimator *)baseTransitionAnimator {
  if (!_baseTransitionAnimator) {
    _baseTransitionAnimator = [[STMBaseTransitionAnimator alloc] init];
  }
  return _baseTransitionAnimator;
}

@end
