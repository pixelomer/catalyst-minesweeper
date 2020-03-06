//
//  ViewController.m
//  minesweeper
//
//  Created by PixelOmer on 1.03.2020.
//  Copyright © 2020 PixelOmer. All rights reserved.
//

#import "ViewController.h"
#import "MineSweeperButton.h"
#import "GameAreaView.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	GameAreaView *gameArea = [GameAreaView new];
	self.view.backgroundColor = gameArea.backgroundColor;
	[self.view addSubview:gameArea];
	gameArea.translatesAutoresizingMaskIntoConstraints = NO;
	[gameArea.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor].active =
	[gameArea.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor].active =
	[gameArea.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active =
	[gameArea.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor].active = YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	return UIInterfaceOrientationPortrait;
}


@end
