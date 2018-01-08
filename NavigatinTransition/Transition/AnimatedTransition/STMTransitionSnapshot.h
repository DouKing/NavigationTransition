//
//  STMTransitionSnapshot.h
//  StromFacilitate
//
//  Created by WuYikai on 16/7/25.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface STMTransitionSnapshot : NSObject

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UIView *snapshotView;

@end
