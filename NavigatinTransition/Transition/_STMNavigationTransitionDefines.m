//
// NavigatinTransition
// _STMNavigationTransitionDefines.m
// Created by DouKing (https://github.com/DouKing) on 2019/1/31.
// Copyright © 2019 DouKing. All rights reserved.

#import "_STMNavigationTransitionDefines.h"

void STMNavigationTransitionSwizzMethod(Class aClass, SEL originSelector, SEL swizzSelector) {
  Method systemMethod = class_getInstanceMethod(aClass, originSelector);
  Method swizzMethod = class_getInstanceMethod(aClass, swizzSelector);
  BOOL isAdd = class_addMethod(aClass,
                               originSelector,
                               method_getImplementation(swizzMethod),
                               method_getTypeEncoding(swizzMethod));
  if (isAdd) {
    class_replaceMethod(aClass,
                        swizzSelector,
                        method_getImplementation(systemMethod),
                        method_getTypeEncoding(systemMethod));
  } else {
    method_exchangeImplementations(systemMethod, swizzMethod);
  }
}
