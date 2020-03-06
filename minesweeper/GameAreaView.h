//
//  GameAreaView.h
//  minesweeper
//
//  Created by PixelOmer on 1.03.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineSweeperContainerView;
@class MineSweeperButton;

@interface GameAreaView : UIView {
	MineSweeperContainerView *_statusContainerView;
	MineSweeperContainerView *_gameContainerView;
	UIView *_mineContainerView;
	NSArray<NSArray<MineSweeperButton *> *> *_mineButtons; // [x][y]
	MineSweeperButton *_resetButton;
	NSArray<NSArray<NSNumber *> *> *_gameValues; // [x][y]
}
@end

NS_ASSUME_NONNULL_END
