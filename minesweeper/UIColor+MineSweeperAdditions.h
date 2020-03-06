//
//  UIColor+MineSweeperAdditions.h
//  minesweeper
//
//  Created by PixelOmer on 1.03.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor(MineSweeperAdditions)
+ (UIColor *)MSLightColor;
+ (UIColor *)MSBackgroundColor;
+ (UIColor *)MSGrayColor;
+ (UIColor *)MSDarkGrayColor;
+ (void)MSInitializeAdditions;
@end

NS_ASSUME_NONNULL_END
