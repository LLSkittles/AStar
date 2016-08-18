//
//  HelloWorldScene.m
//
//  Created by : Chao
//  Project    : AStar
//  Date       : 16/8/16
//
//  Copyright (c) 2016年 Chao.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "HelloWorldScene.h"

// -----------------------------------------------------------------------

@implementation HelloWorldScene

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    self.userInteractionEnabled = YES;
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    NSAssert(self, @"Whoops");
    
    map = [CCTiledMap tiledMapWithFile:@"AStar.tmx"];
    map.scale = 0.5;
    [self addChild:map];
    
    player = [Player spriteWithImageNamed:@"005.png"];
    player.position = CGPointMake(16, 32 * 8 + 16);
    [map addChild:player];

    return self;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    
    CGPoint touchLocation = [touch locationInNode:map];
    [player moveToward:touchLocation];
}

@end























// why not add a few extra lines, so we dont have to sit and edit at the bottom of the screen ...
