//
//  MineSweeperContainerView.h
//  minesweeper
//
//  Created by PixelOmer on 1.03.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineSweeperContainerView : UIView {
	NSLayoutConstraint *_contentViewWidthConstraint;
	NSLayoutConstraint *_contentViewHeightConstraint;
	NSLayoutConstraint *_contentViewLeftConstraint;
	NSLayoutConstraint *_contentViewTopConstraint;
}
@property (nonatomic, strong) UIColor *topLeftColor;
@property (nonatomic, strong) UIColor *bottomRightColor;
@property (nonatomic, strong) UIColor *contentSquareColor;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, assign) CGFloat contentPosition;
@property (nonatomic, assign) CGFloat contentSizeConstant;
@property (nonatomic, assign) BOOL flipped;
@property (nonatomic, assign) BOOL drawBorder;
@property (nonatomic, assign) BOOL drawBump;
@end

NS_ASSUME_NONNULL_END
