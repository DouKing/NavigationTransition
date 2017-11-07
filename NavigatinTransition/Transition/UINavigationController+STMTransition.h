//
//  UINavigationController+STMTransition.h
//  StromFacilitate
//
//  Created by WuYikai on 16/7/20.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+STMTransition.h"

NS_ASSUME_NONNULL_BEGIN


@interface UINavigationController (STMTransition)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *stm_fullscreenInteractivePopGestureRecognizer;

@end


NS_ASSUME_NONNULL_END
