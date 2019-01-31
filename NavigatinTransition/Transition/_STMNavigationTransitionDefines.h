//
// NavigatinTransition
// _STMNavigationTransitionDefines.h
// Created by DouKing (https://github.com/DouKing) on 2019/1/31.
// Copyright © 2019 DouKing. All rights reserved.

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT void STMNavigationTransitionSwizzMethod(Class aClass, SEL originSelector, SEL swizzSelector);

NS_ASSUME_NONNULL_END
