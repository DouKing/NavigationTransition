//
//  STMBaseTransitionAnimator.h
//  StromFacilitate
//
//  Created by WuYikai on 16/7/26.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface STMBaseTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;

@end
