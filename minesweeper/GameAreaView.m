//
//  GameAreaView.m
//  minesweeper
//
//  Created by PixelOmer on 1.03.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import "GameAreaView.h"
#import "MineSweeperContainerView.h"
#import "UIColor+MineSweeperAdditions.h"
#import "MineSweeperButton.h"

@implementation GameAreaView

static NSArray<UIColor *> *numColors;
static UIImage *flagImage;
static UIImage *bombImage;

+ (void)initialize {
	if (self == [GameAreaView class]) {
		#define color(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
		numColors = @[
			color(14.0, 37.0, 249.0),
			color(29.0, 128.0, 30.0),
			color(248.0, 21.0, 32.0),
			color(24.0, 29.0, 128.0),
			color(122.0, 6.0, 11.0),
			color(74.0, 223.0, 208.0),
			color(0.0, 0.0, 0.0),
			color(128.0, 128.0, 128.0)
		];
		#undef color
		flagImage = [UIImage imageNamed:@"flag"];
		bombImage = [UIImage imageNamed:@"bomb"];
	}
}

- (BOOL)shouldButtonRevealRecursively:(MineSweeperButton *)button {
	return ![_gameValues[button.tag%10][button.tag/10] boolValue];
}

- (void)revealCellsWithButton:(MineSweeperButton *)button {
	[self revealCellsWithButton:button recursive:[self shouldButtonRevealRecursively:button]];
}

- (void)resetGame:(MineSweeperButton *)sender {
	_gameValues = nil;
	for (NSArray *line in _mineButtons) {
		for (MineSweeperButton *button in line) {
			button.userInteractionEnabled = YES;
			button.contentSquareColor = [UIColor MSGrayColor];
			button.contentView.backgroundColor = [UIColor clearColor];
			button.image = nil;
			for (UIView *view in button.contentView.subviews) {
				[view removeFromSuperview];
			}
			[button setNeedsDisplay];
		}
	}
}

- (void)revealCellsWithButton:(MineSweeperButton *)button recursive:(BOOL)recursive {
	const int revealX=button.tag%10, revealY=(int)button.tag/10;
	button.userInteractionEnabled = NO;
	NSNumber *num = _gameValues[revealX][revealY];
	UIView *view = nil;
	if (!(!num.boolValue || (num.intValue == 9))) {
		UILabel *numLabel = [UILabel new];
		numLabel.font = [UIFont boldSystemFontOfSize:numLabel.font.pointSize];
		numLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[button.contentView addSubview:numLabel];
		[numLabel.widthAnchor constraintGreaterThanOrEqualToConstant:0.0].active =
		[numLabel.heightAnchor constraintGreaterThanOrEqualToConstant:0.0].active = YES;
		view = numLabel;
		numLabel.text = num.stringValue;
		numLabel.textColor = numColors[num.intValue-1];
	}
	else if (num.intValue == 9) {
		button.image = bombImage;
		button.backgroundColor = [UIColor redColor];
		
		for (int y=0; y<10; y++) {
			for (int x=0; x<10; x++) {
				MineSweeperButton *targetButton = _mineButtons[x][y];
				if (targetButton == button) continue;
				if (!targetButton.userInteractionEnabled) continue;
				int value = _gameValues[x][y].intValue;
				BOOL drawBump = targetButton.drawBump;
				targetButton.userInteractionEnabled = NO;
				if ((value == 9) && !targetButton.image) {
					targetButton.image = bombImage;
					drawBump = NO;
				}
				else if ((value != 9) && targetButton.image) {
					targetButton.contentView.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.25];
				}
				targetButton.drawBump = drawBump;
				[targetButton setNeedsDisplay];
			}
		}
	}
	[view.centerYAnchor constraintEqualToAnchor:button.contentView.centerYAnchor].active =
	[view.centerXAnchor constraintEqualToAnchor:button.contentView.centerXAnchor].active = YES;
	[button setNeedsDisplay];
	if (recursive) {
		int x,y;
		for (x=revealX-1; x<=revealX+1; x++) {
			if ((x < 0) || (x > 9)) continue;
			for (y=revealY-1; y<=revealY+1; y++) {
				if ((y < 0) || (y > 9)) continue;
				if ((x == revealX) && (y == revealY)) continue;
				MineSweeperButton *targetButton = _mineButtons[x][y];
				if (!targetButton.userInteractionEnabled || targetButton.image || [_gameValues[x][y] isEqualToNumber:@9]) continue;
				[self revealCellsWithButton:targetButton recursive:[self shouldButtonRevealRecursively:targetButton]];
			}
		}
	}
}

- (void)generateBoardWithButton:(MineSweeperButton *)button {
	const int safeX=button.tag%10, safeY=(int)button.tag/10;
	NSLog(@"x:%d y:%d", safeX, safeY);
	NSMutableArray<NSMutableArray<NSNumber *> *> *gameValues = [NSMutableArray new];
	int i,x,y,sx,sy;
	for (i=0; i<10; i++) {
		[gameValues addObject:[@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy]];
	}
	for (i=0; i<10; i++) {
		int x = arc4random_uniform(10);
		int y = arc4random_uniform(10);
		if ((abs(safeX-x) < 2) || (abs(safeY-y) < 2) || (gameValues[x][y].intValue == 9)) {
			i--;
			continue;
		}
		gameValues[x][y] = @(9);
	}
	for (x=0; x<10; x++) {
		for (y=0; y<10; y++) {
			int newValue = 0;
			if (gameValues[x][y].intValue == 9) continue;
			for (sx=x-1; sx<=x+1; sx++) {
				if ((sx < 0) || (sx > 9)) continue;
				for (sy=y-1; sy<=y+1; sy++) {
					if ((sy < 0) || (sy > 9)) continue;
					if (gameValues[sx][sy].intValue == 9) {
						newValue++;
					}
				}
			}
			gameValues[x][y] = @(newValue);
		}
	}
	/*
	// Prints the game map. Makes it possible to cheat by looking at Console.app
	for (NSArray<NSNumber *> *array in gameValues) {
		NSMutableString *string = [NSMutableString new];
		for (NSNumber *number in array) {
			[string appendFormat:@"%@", number];
		}
		NSLog(@"%@", string);
	}
	*/
	for (int i=0; i<10; i++) gameValues[i] = gameValues[i].copy;
	_gameValues = gameValues.copy;
	[self revealCellsWithButton:button];
}

- (void)handleGameButtonTap:(MineSweeperButton *)button {
	if (button.image) return;
	if (!_gameValues) [self generateBoardWithButton:button];
	else [self revealCellsWithButton:button];
}

- (void)handleGameButtonHold:(MineSweeperButton *)button {
	button.image = button.image ? nil : flagImage;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor MSGrayColor];
		_statusContainerView = [MineSweeperContainerView new];
		_statusContainerView.flipped = YES;
		_statusContainerView.contentView.backgroundColor = [UIColor MSBackgroundColor];
		_statusContainerView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_statusContainerView];
		[_statusContainerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active =
		[_statusContainerView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:-15.0].active =
		[_statusContainerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:7.5].active =
		[_statusContainerView.heightAnchor constraintEqualToConstant:50.0].active = YES;
		_gameContainerView = [MineSweeperContainerView new];
		_gameContainerView.flipped = YES;
		_gameContainerView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_gameContainerView];
		[_gameContainerView.widthAnchor constraintEqualToAnchor:_statusContainerView.widthAnchor].active =
		[_gameContainerView.centerXAnchor constraintEqualToAnchor:_statusContainerView.centerXAnchor].active =
		[_gameContainerView.topAnchor constraintEqualToAnchor:_statusContainerView.bottomAnchor constant:10.0].active =
		[_gameContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10.0].active = YES;
		_mineContainerView = [UIView new];
		_mineContainerView.translatesAutoresizingMaskIntoConstraints = NO;
		[_gameContainerView.contentView addSubview:_mineContainerView];
		[_mineContainerView.centerXAnchor constraintEqualToAnchor:_gameContainerView.contentView.centerXAnchor].active =
		[_mineContainerView.centerYAnchor constraintEqualToAnchor:_gameContainerView.contentView.centerYAnchor].active =
		[_mineContainerView.heightAnchor constraintEqualToAnchor:_mineContainerView.widthAnchor].active =
		[_mineContainerView.widthAnchor constraintEqualToAnchor:_gameContainerView.contentView.widthAnchor].active = YES;
		NSLayoutXAxisAnchor *lastRight = _mineContainerView.leftAnchor;
		NSLayoutYAxisAnchor *lastBottom = _mineContainerView.topAnchor;
		NSMutableArray *mineButtons = [NSMutableArray new];
		for (int y=0; y<10; y++) {
			MineSweeperButton *button = nil;
			for (int x=0; x<10; x++) {
				if (!y) [mineButtons addObject:[NSMutableArray new]];
				button = [MineSweeperButton new];
				button.translatesAutoresizingMaskIntoConstraints = NO;
				[_mineContainerView addSubview:button];
				[button.widthAnchor constraintEqualToAnchor:_mineContainerView.widthAnchor multiplier:0.1].active =
				[button.heightAnchor constraintEqualToAnchor:_mineContainerView.heightAnchor multiplier:0.1].active =
				[button.topAnchor constraintEqualToAnchor:lastBottom].active =
				[button.leftAnchor constraintEqualToAnchor:lastRight].active = YES;
				button.contentSizeConstant = -6.0;
				button.contentPosition = 2.5;
				button.drawBorder = YES;
				button.tag = (y*10) + x;
				button.target = self;
				button.pressAction = @selector(handleGameButtonTap:);
				button.longPressAction = @selector(handleGameButtonHold:);
				lastRight = button.rightAnchor;
				[mineButtons[x] addObject:button];
			}
			lastBottom = button.bottomAnchor;
			lastRight = _mineContainerView.leftAnchor;
		}
		_mineButtons = mineButtons.copy;
		_resetButton = [MineSweeperButton new];
		_resetButton.translatesAutoresizingMaskIntoConstraints = NO;
		_resetButton.contentPosition = 3.0;
		_resetButton.contentSizeConstant = -6.0;
		_resetButton.target = self;
		_resetButton.pressAction = @selector(resetGame:);
		[_statusContainerView.contentView addSubview:_resetButton];
		[_resetButton.centerXAnchor constraintEqualToAnchor:_statusContainerView.contentView.centerXAnchor].active =
		[_resetButton.heightAnchor constraintEqualToAnchor:_statusContainerView.contentView.heightAnchor constant:-2.5].active =
		[_resetButton.widthAnchor constraintEqualToAnchor:_resetButton.heightAnchor].active =
		[_resetButton.centerYAnchor constraintEqualToAnchor:_statusContainerView.contentView.centerYAnchor].active = YES;
	}
	return self;
}

- (instancetype)init {
	return [self initWithFrame:CGRectZero];
}

@end
