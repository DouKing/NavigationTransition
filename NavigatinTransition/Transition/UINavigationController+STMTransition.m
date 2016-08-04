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

@interface STMTransitionProxy : NSProxy<UINavigationControllerDelegate>

@property (nonatomic, assign) STMNavigationTransitionStyle transitionStyle;
@property (nonatomic, weak) id<UINavigationControllerDelegate> delegate;
@property (nonatomic, strong) STMBaseTransitionAnimator *baseTransitionAnimator;
@property (nonatomic, strong) STMResignLeftTransitionAnimator *resignLeftTransitionAnimator;

@end

@implementation STMTransitionProxy

- (instancetype)init {
  _transitionStyle = STMNavigationTransitionStyleSystem;
  _delegate = nil;
  return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
  [invocation setTarget:self.delegate];
  [invocation invoke];
  return;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
  return [(id)self.delegate methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  if (sel_isEqual(aSelector, @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)) || sel_isEqual(aSelector, @selector(navigationController:interactionControllerForAnimationController:))) {
    return YES;
  }
  return [self.delegate respondsToSelector:aSelector];
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

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
  return nil;
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
    NSArray *originalSelectors = @[@"viewDidLoad", @"setDelegate:", @"delegate"];
    NSArray *swizzledSelectors = @[@"stm_viewDidLoad", @"stm_setDelegate:", @"stm_delegate"];
    for (NSInteger i = 0; i < [originalSelectors count]; ++i) {
      SEL originalSel = NSSelectorFromString(originalSelectors[i]);
      SEL swizzledSel = NSSelectorFromString(swizzledSelectors[i]);
      STMSwizzMethod(class, originalSel, swizzledSel);
    }
  });
}

- (void)stm_viewDidLoad {
  self.delegate = self.delegate;
  [self stm_viewDidLoad];
}

- (void)stm_setDelegate:(id<UINavigationControllerDelegate>)delegate {
  self.proxy.delegate = delegate;
  [self stm_setDelegate:self.proxy];
}

- (id<UINavigationControllerDelegate>)stm_delegate {
  return self.proxy.delegate;
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
