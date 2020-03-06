//
//  UIColor+MineSweeperAdditions.m
//  minesweeper
//
//  Created by PixelOmer on 1.03.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import "UIColor+MineSweeperAdditions.h"

@implementation UIColor(MineSweeperAdditions)

static NSArray *colors;

+ (void)MSInitializeAdditions {
	#define color(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
	colors = @[
		color(250.0, 250.0, 250.0),
		color(226.0, 226.0, 226.0),
		color(190.0, 190.0, 190.0),
		color(126.0, 126.0, 126.0)
	];
	#undef color
}

+ (UIColor *)MSLightColor {
	return colors[0];
}

+ (UIColor *)MSBackgroundColor {
	return colors[1];
}

+ (UIColor *)MSGrayColor {
	return colors[2];
}

+ (UIColor *)MSDarkGrayColor {
	return colors[3];
}

@end
