//
//  UINavigationController+STMTransition.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/20.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "UINavigationController+STMTransition.h"
#import "STMObjectRuntime.h"
#import "STMNavigationResignLeftTransitionAnimator.h"

@interface STMPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@interface STMTransitionProxy : NSProxy<UINavigationControllerDelegate>

@property (nonatomic, weak) id<UINavigationControllerDelegate> delegate;
@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, strong) STMNavigationBaseTransitionAnimator *baseTransitionAnimator;
@property (nonatomic, strong) STMNavigationResignLeftTransitionAnimator *resignLeftTransitionAnimator;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic, assign) BOOL interacting;

- (instancetype)init;
- (void)_handleInteractionPopGesture:(UIScreenEdgePanGestureRecognizer *)gesture;

@end

@interface UINavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) STMTransitionProxy *proxy;
@property (nonatomic, strong) UIPanGestureRecognizer *screenPan;
@property (nonatomic, strong) STMPopGestureRecognizerDelegate *popGestureDelegate;

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
  [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.stm_fullscreenInteractivePopGestureRecognizer];
  [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.screenPan];
  self.interactivePopGestureRecognizer.enabled = NO;
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

- (UIPanGestureRecognizer *)screenPan {
  UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, _cmd);
  if (!gesture) {
    gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.proxy action:@selector(_handleInteractionPopGesture:)];
    gesture.delegate = self.popGestureDelegate;
    self.screenPan = gesture;
  }
  return gesture;
}

- (void)setScreenPan:(UIPanGestureRecognizer *)screenPan {
  objc_setAssociatedObject(self, @selector(screenPan), screenPan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer *)stm_fullscreenInteractivePopGestureRecognizer {
  UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, _cmd);
  if (!gesture) {
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    gesture = [[UIPanGestureRecognizer alloc] initWithTarget:internalTarget action:internalAction];
    gesture.delegate = self.popGestureDelegate;

    objc_setAssociatedObject(self, _cmd, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return gesture;
}

- (void)setPopGestureDelegate:(STMPopGestureRecognizerDelegate *)popGestureDelegate {
  objc_setAssociatedObject(self, @selector(popGestureDelegate), popGestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (STMPopGestureRecognizerDelegate *)popGestureDelegate {
  STMPopGestureRecognizerDelegate *popGestureDelegate = objc_getAssociatedObject(self, _cmd);
  if (!popGestureDelegate) {
    popGestureDelegate = [[STMPopGestureRecognizerDelegate alloc] init];
    popGestureDelegate.navigationController = self;
    self.popGestureDelegate = popGestureDelegate;
  }
  return popGestureDelegate;
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
  if (  sel_isEqual(aSelector, @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:))
     || sel_isEqual(aSelector, @selector(navigationController:interactionControllerForAnimationController:))) {
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

- (void)_useSystemAnimatorOrNot:(BOOL)use {
  if (use) {
    self.navigationController.screenPan.enabled = NO;
    self.navigationController.stm_fullscreenInteractivePopGestureRecognizer.enabled = YES;
  } else {
    self.navigationController.screenPan.enabled = YES;
    self.navigationController.stm_fullscreenInteractivePopGestureRecognizer.enabled = NO;
  }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
  if ([self.delegate respondsToSelector:_cmd]) {
    return [self.delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
  }
  return self.interacting ? self.interactionController : nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
  if ([self.delegate respondsToSelector:_cmd]) {
    id<UIViewControllerAnimatedTransitioning> animator = [self.delegate navigationController:navigationController
                                                             animationControllerForOperation:operation
                                                                          fromViewController:fromVC
                                                                            toViewController:toVC];
    [self _useSystemAnimatorOrNot:animator == nil];
    return animator;
  }

  UIViewController *transitionVC = (UINavigationControllerOperationPush == operation) ? toVC : fromVC;
  STMNavigationTransitionStyle transitionStyle = transitionVC.navigationTransitionStyle;
  if (STMNavigationTransitionStyleNone == transitionStyle) {
    transitionStyle = self.navigationController.navigationTransitionStyle;
  }
  STMNavigationBaseTransitionAnimator *animator = [self _animatorForTransitionStyle:transitionStyle];
  animator.operation = operation;
  [self _useSystemAnimatorOrNot:animator == nil];
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

@end


@implementation STMPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
  // Ignore when no view controller is pushed into the navigation stack.
  if (self.navigationController.viewControllers.count <= 1) {
    return NO;
  }

  // Ignore when the active view controller doesn't allow interactive pop.
  UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
  if (topViewController.stm_interactivePopDisabled) {
    return NO;
  }

  // Ignore when the beginning location is beyond max allowed initial distance to left edge.
  CGFloat maxAllowedInitialDistance = topViewController.stm_interactivePopMaxAllowedInitialDistanceToLeftEdge;
  if (maxAllowedInitialDistance > 0) {
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (beginningLocation.x > maxAllowedInitialDistance) {
      return NO;
    }
  }

  // Ignore pan gesture when the navigation controller is currently in transition.
  if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
    return NO;
  }

  // Prevent calling the handler when the gesture begins in an opposite direction.
  CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
  BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
  CGFloat multiplier = isLeftToRight ? 1 : - 1;
  if ((translation.x * multiplier) <= 0) {
    return NO;
  }

  return YES;
}

@end
