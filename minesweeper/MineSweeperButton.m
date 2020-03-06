//
//  MineSweeperButton.m
//  minesweeper
//
//  Created by PixelOmer on 1.03.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import "MineSweeperButton.h"
#import "UIColor+MineSweeperAdditions.h"
#import <objc/runtime.h>

@implementation MineSweeperButton

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		_imageView = [UIImageView new];
		_imageView.translatesAutoresizingMaskIntoConstraints = NO;
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		_imageViewContainer = [UIView new];
		_imageViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
		[_imageViewContainer addSubview:_imageView];
		[_imageView.centerXAnchor constraintEqualToAnchor:_imageViewContainer.centerXAnchor].active =
		[_imageView.centerYAnchor constraintEqualToAnchor:_imageViewContainer.centerYAnchor].active = YES;
		[self addSubview:_imageViewContainer];
		[_imageViewContainer.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active =
		[_imageViewContainer.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active =
		[_imageViewContainer.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active =
		[_imageViewContainer.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
		self.imageSizeMultiplier = 0.75;
		self.exclusiveTouch = YES;
		self.drawBorder = YES;
	}
	return self;
}

- (void)setImageSizeMultiplier:(CGFloat)imageSizeMultiplier {
	for (NSLayoutConstraint *constraint in _imageSizeConstraints) {
		constraint.active = NO;
	}
	_imageSizeConstraints = @[
		[_imageView.widthAnchor constraintEqualToAnchor:_imageViewContainer.widthAnchor multiplier:imageSizeMultiplier],
		[_imageView.heightAnchor constraintEqualToAnchor:_imageViewContainer.heightAnchor multiplier:imageSizeMultiplier]
	];
	for (NSLayoutConstraint *constraint in _imageSizeConstraints) {
		constraint.active = YES;
	}
	_imageSizeMultiplier = imageSizeMultiplier;
}

- (void)setImage:(UIImage *)image {
	self.imageView.image = image;
	[self.imageView setNeedsDisplay];
}

- (UIImage *)image {
	return self.imageView.image;
}

- (void)setIsPushed:(BOOL)isPushed {
	if (_isPushed && !isPushed) {
		self.contentPosition *= 2.0;
		self.contentPosition /= 3.0;
		self.topLeftColor = [UIColor MSLightColor];
	}
	else if (!_isPushed && isPushed) {
		self.contentPosition *= 3.0;
		self.contentPosition /= 2.0;
		self.topLeftColor = self.bottomRightColor;
	}
	if (_isPushed != isPushed) {
		[_timer invalidate];
		_timer = nil;
		[self setNeedsDisplay];
	}
	_isPushed = isPushed;
}

- (void)performAction:(SEL)action {
	if (_target && action) {
		Class cls = object_getClass(_target);
		Method m = class_getInstanceMethod(cls, action);
		void(*targetFunction)(id, SEL, MineSweeperButton *) = (typeof(targetFunction))method_getImplementation(m);
		targetFunction(_target, action, self);
	}
}

- (void)handleLongPress:(id)sender {
	_didLongPress = YES;
	[self performAction:_longPressAction];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	_didLongPress = NO;
	self.isPushed = YES;
	_timer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(handleLongPress:) userInfo:nil repeats:NO];
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	[_timer invalidate];
	_timer = nil;
	self.isPushed = NO;
	BOOL shouldPerformSelector = [self pointInside:[touches.anyObject locationInView:self] withEvent:nil];
	if (!_didLongPress && shouldPerformSelector) [self performAction:_pressAction];
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	self.isPushed = [self pointInside:[touches.anyObject locationInView:self] withEvent:nil];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
	[super setUserInteractionEnabled:userInteractionEnabled];
	self.drawBump = self.userInteractionEnabled;
}

@end
