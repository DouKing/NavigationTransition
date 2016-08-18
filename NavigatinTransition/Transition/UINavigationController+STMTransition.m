//
//  UINavigationController+STMTransition.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/20.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "UINavigationController+STMTransition.h"
#import "STMObjectRuntime.h"
#import "UIViewController+STMTransition.h"
#import "STMResignLeftTransitionAnimator.h"
#import "STMInteractionController.h"

@interface STMTransitionProxy : NSObject<UINavigationControllerDelegate>

@property (nonatomic, assign) STMNavigationTransitionStyle transitionStyle;
@property (nonatomic, strong) STMBaseTransitionAnimator *baseTransitionAnimator;
@property (nonatomic, strong) STMResignLeftTransitionAnimator *resignLeftTransitionAnimator;
@property (nonatomic, strong) STMInteractionController *interactionController;

@end

@implementation STMTransitionProxy

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

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  [self.interactionController wireToViewController:viewController];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
  return self.interactionController.interacting ? self.interactionController : nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
  STMNavigationTransitionStyle transitionStyle = (UINavigationControllerOperationPush == operation) ? toVC.navigationTransitionStyle : fromVC.navigationTransitionStyle;
  if (STMNavigationTransitionStyleNone == transitionStyle) {
    transitionStyle = self.transitionStyle;
  }
  STMBaseTransitionAnimator *animator = [self _animatorForTransitionStyle:transitionStyle];
  animator.operation = operation;
  return animator;
}

#pragma mark - setter & getter

- (STMInteractionController *)interactionController {
  if (!_interactionController) {
    _interactionController = [[STMInteractionController alloc] init];
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

#pragma mark -
#pragma mark -

@interface UINavigationController ()

@property (nonatomic, strong) STMTransitionProxy *proxy;

@end

@implementation UINavigationController (STMTransition)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];
    NSArray *originalSelectors = @[@"viewDidLoad"];
    NSArray *swizzledSelectors = @[@"stm_viewDidLoad"];
    for (NSInteger i = 0; i < [originalSelectors count]; ++i) {
      SEL originalSel = NSSelectorFromString(originalSelectors[i]);
      SEL swizzledSel = NSSelectorFromString(swizzledSelectors[i]);
      STMSwizzMethod(class, originalSel, swizzledSel);
    }
  });
}

- (void)stm_viewDidLoad {
  self.delegate = self.proxy;
  [self stm_viewDidLoad];
}

- (STMTransitionProxy *)proxy {
  STMTransitionProxy *proxy = objc_getAssociatedObject(self, @selector(proxy));
  if (!proxy) {
    proxy = [[STMTransitionProxy alloc] init];
    self.proxy = proxy;
  }
  return proxy;
}

- (void)setProxy:(STMTransitionProxy *)proxy {
  objc_setAssociatedObject(self, @selector(proxy), proxy, OBJC_ASSOCIATION_RETAIN);
}

- (STMNavigationTransitionStyle)transitionStyle {
  return self.proxy.transitionStyle;
}

- (void)setTransitionStyle:(STMNavigationTransitionStyle)transitionStyle {
  if (transitionStyle == STMNavigationTransitionStyleNone) {
    transitionStyle = STMNavigationTransitionStyleSystem;
  }
  self.proxy.transitionStyle = transitionStyle;
}

@end
