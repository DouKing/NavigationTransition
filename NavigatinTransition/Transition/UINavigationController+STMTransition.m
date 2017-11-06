//
//  UINavigationController+STMTransition.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/20.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "UINavigationController+STMTransition.h"
#import "STMObjectRuntime.h"
#import "STMNavigationResignLeftTransitionAnimator.h"

@interface STMTransitionProxy : NSProxy<UINavigationControllerDelegate>

@property (nonatomic, weak) id<UINavigationControllerDelegate> delegate;
@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, strong) STMNavigationBaseTransitionAnimator *baseTransitionAnimator;
@property (nonatomic, strong) STMNavigationResignLeftTransitionAnimator *resignLeftTransitionAnimator;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic, assign) BOOL interacting;
@property (nonatomic, assign) BOOL gestureEnable;

- (instancetype)init;
- (void)_handleInteractionPopGesture:(UIScreenEdgePanGestureRecognizer *)gesture;

@end

@interface UINavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) STMTransitionProxy *proxy;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenPan;

@end

#pragma mark -

@implementation UINavigationController (STMTransition)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];
    NSArray *originalSelectors = @[@"viewDidLoad", @"delegate", @"setDelegate:"];
    NSArray *swizzledSelectors = @[@"stm_viewDidLoad", @"stm_delegate", @"stm_setDelegate:"];
    for (NSInteger i = 0; i < [originalSelectors count]; ++i) {
      SEL originalSel = NSSelectorFromString(originalSelectors[i]);
      SEL swizzledSel = NSSelectorFromString(swizzledSelectors[i]);
      STMSwizzMethod(class, originalSel, swizzledSel);
    }
  });
}

- (void)stm_viewDidLoad {
  [self stm_viewDidLoad];
  self.delegate = self.delegate;
  self.interactivePopGestureRecognizer.delegate = self;
  [self.view addGestureRecognizer:self.screenPan];
}

#pragma mark - setter & getter

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
    proxy.navigationController = self;
    self.proxy = proxy;
  }
  return proxy;
}

- (void)setProxy:(STMTransitionProxy *)proxy {
  objc_setAssociatedObject(self, @selector(proxy), proxy, OBJC_ASSOCIATION_RETAIN);
}

- (UIScreenEdgePanGestureRecognizer *)screenPan {
  UIScreenEdgePanGestureRecognizer *gesture = objc_getAssociatedObject(self, _cmd);
  if (!gesture) {
    gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.proxy action:@selector(_handleInteractionPopGesture:)];
    gesture.edges = UIRectEdgeLeft;
    self.screenPan = gesture;
  }
  return gesture;
}

- (void)setScreenPan:(UIScreenEdgePanGestureRecognizer *)screenPan {
  objc_setAssociatedObject(self, @selector(screenPan), screenPan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark -

@implementation STMTransitionProxy

- (instancetype)init {
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

- (void)_handleInteractionPopGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
  UIView *view = gesture.view;
  CGFloat x = [gesture translationInView:view].x;
  CGFloat percent = fmin(fmax((x / CGRectGetWidth(view.bounds)), 0.0), 1.0);
  switch (gesture.state) {
    case UIGestureRecognizerStateBegan: {
      self.interacting = YES;
      [self.navigationController popViewControllerAnimated:YES];
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

- (STMNavigationBaseTransitionAnimator *)_animatorForTransitionStyle:(STMNavigationTransitionStyle)transitionStyle {
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
  if ([self.delegate respondsToSelector:_cmd]) {
    return [self.delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
  }
  return self.interacting ? self.interactionController : nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
  if ([self.delegate respondsToSelector:_cmd]) {
    id<UIViewControllerAnimatedTransitioning> animator = [self.delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    self.gestureEnable = (animator != nil);
    return animator;
  }
  
  STMNavigationTransitionStyle transitionStyle = (UINavigationControllerOperationPush == operation) ? toVC.navigationTransitionStyle : fromVC.navigationTransitionStyle;
  if (STMNavigationTransitionStyleNone == transitionStyle) {
    transitionStyle = self.navigationController.navigationTransitionStyle;
  }
  STMNavigationBaseTransitionAnimator *animator = [self _animatorForTransitionStyle:transitionStyle];
  animator.operation = operation;
  self.gestureEnable = (animator != nil);
  return animator;
}

#pragma mark - setter & getter

- (UIPercentDrivenInteractiveTransition *)interactionController {
  if (!_interactionController) {
    _interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
  }
  return _interactionController;
}

- (STMNavigationResignLeftTransitionAnimator *)resignLeftTransitionAnimator {
  if (!_resignLeftTransitionAnimator) {
    _resignLeftTransitionAnimator = [[STMNavigationResignLeftTransitionAnimator alloc] init];
  }
  return _resignLeftTransitionAnimator;
}

- (STMNavigationBaseTransitionAnimator *)baseTransitionAnimator {
  if (!_baseTransitionAnimator) {
    _baseTransitionAnimator = [[STMNavigationBaseTransitionAnimator alloc] init];
  }
  return _baseTransitionAnimator;
}

- (void)setGestureEnable:(BOOL)gestureEnable {
  _gestureEnable = gestureEnable;
  if (gestureEnable) {
    [self.navigationController.view addGestureRecognizer:self.navigationController.screenPan];
  } else {
    [self.navigationController.view removeGestureRecognizer:self.navigationController.screenPan];
  }
}

@end
