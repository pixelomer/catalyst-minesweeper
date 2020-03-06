//
//  main.m
//  minesweeper
//
//  Created by PixelOmer on 1.03.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIColor+MineSweeperAdditions.h"

int main(int argc, char * argv[]) {
	NSString * appDelegateClassName;
	[UIColor MSInitializeAdditions];
	@autoreleasepool {
	    // Setup code that might create autoreleased objects goes here.
	    appDelegateClassName = NSStringFromClass([AppDelegate class]);
	}
	return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
