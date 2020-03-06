//
//  MineSweeperButton.h
//  minesweeper
//
//  Created by PixelOmer on 1.03.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineSweeperContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineSweeperButton : MineSweeperContainerView {
	NSTimer *_timer;
	BOOL _didLongPress;
	NSArray<NSLayoutConstraint *> *_imageSizeConstraints;
	UIView *_imageViewContainer;
}
@property (nonatomic, readonly, assign) BOOL isPushed;
@property (nonatomic, weak) id _Nullable target;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, assign) SEL _Nullable pressAction;
@property (nonatomic, assign) SEL _Nullable longPressAction;
@property (nonatomic, assign) CGFloat imageSizeMultiplier;
@property (setter=setImage:, getter=image) UIImage * _Nullable image;
@end

NS_ASSUME_NONNULL_END
