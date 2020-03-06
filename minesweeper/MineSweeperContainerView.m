//
//  MineSweeperContainerView.m
//  minesweeper
//
//  Created by PixelOmer on 1.03.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import "MineSweeperContainerView.h"
#import "UIColor+MineSweeperAdditions.h"

@implementation MineSweeperContainerView

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		_drawBump = YES;
		_topLeftColor = [UIColor MSLightColor];
		self.contentSquareColor = [UIColor MSGrayColor];
		_contentPosition = 5.0;
		_contentSizeConstant = -11.0;
		_bottomRightColor = [UIColor MSDarkGrayColor];
		_contentView = [UIView new];
		_contentView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_contentView];
		(_contentViewTopConstraint = [_contentView.topAnchor constraintEqualToAnchor:self.topAnchor constant:_contentPosition]).active =
		(_contentViewLeftConstraint = [_contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:_contentPosition]).active =
		(_contentViewWidthConstraint = [_contentView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:_contentSizeConstant]).active =
		(_contentViewHeightConstraint = [_contentView.heightAnchor constraintEqualToAnchor:self.heightAnchor constant:_contentSizeConstant]).active = YES;
	}
	return self;
}

- (void)setContentSquareColor:(UIColor *)contentSquareColor {
	CGFloat h,s,b,a;
	[contentSquareColor getHue:&h saturation:&s brightness:&b alpha:&a];
	self.backgroundColor = [UIColor
		colorWithHue:h
		saturation:s
		brightness:b-0.1
		alpha:a
	];
	_contentSquareColor = contentSquareColor;
}

- (instancetype)init {
	return [self initWithFrame:CGRectZero];
}

- (void)setContentPosition:(CGFloat)contentPosition {
	_contentViewTopConstraint.constant = contentPosition;
	_contentViewLeftConstraint.constant = contentPosition;
	_contentPosition = contentPosition;
}

- (void)setContentSizeConstant:(CGFloat)contentSizeConstant {
	_contentViewWidthConstraint.constant = contentSizeConstant;
	_contentViewHeightConstraint.constant = contentSizeConstant;
	_contentSizeConstant = contentSizeConstant;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *path;

	#define start(x,y) [path moveToPoint:CGPointMake(x, y)]
	#define move(x,y) [path addLineToPoint:CGPointMake(x, y)]
    
    if (_drawBump) {
		UIColor *colorA = _topLeftColor;
		UIColor *colorB = _bottomRightColor;
		
		if (_flipped) {
			UIColor *swap = colorA;
			colorA = colorB;
			colorB = swap;
		}
		
		[colorA setFill];
		path = [UIBezierPath bezierPath];
		
		start(0, 0);
		move(0, rect.size.height);
		move(10, rect.size.height-10);
		move(10, 10);
		move(rect.size.width-10, 10);
		move(rect.size.width, 0);
		move(0, 0);
		[path closePath];
		[path fill];
		
		[colorB setFill];
		path = [UIBezierPath bezierPath];
		start(rect.size.width, rect.size.height);
		move(0, rect.size.height);
		move(10, rect.size.height-10);
		move(rect.size.width-10, rect.size.height-10);
		move(rect.size.width-10, 10);
		move(rect.size.width, 0);
		move(rect.size.width, rect.size.height);
		[path closePath];
		[path fill];
		
		[_contentSquareColor setFill];
		path = [UIBezierPath bezierPathWithRect:CGRectMake(_contentPosition, _contentPosition, rect.size.width+_contentSizeConstant, rect.size.height+_contentSizeConstant)];
		[path fill];
    }
    
    if (_drawBorder) {
		[UIColor.blackColor setFill];
		path = [UIBezierPath bezierPath];
		
		start(0, 0);
		move(0, rect.size.height);
		move(rect.size.width, rect.size.height);
		move(rect.size.width, 0);
		move(rect.size.width-1, 0);
		move(rect.size.width-1, rect.size.height-1);
		move(1, rect.size.height-1);
		move(1, 1);
		move(0, 0);
		[path closePath];
		
		start(1, 0);
		move(rect.size.width-1, 0);
		move(rect.size.width-1, 1);
		move(1, 1);
		move(1, 0);
		[path closePath];
		
		[path fill];
	}
	
	#undef start
	#undef move
}

@end
