//
//  Player.h
//
//  Created by : Chao
//  Project    : AStar
//  Date       : 16/8/17
//
//  Copyright (c) 2016年 Chao.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------

@interface Player : CCSprite

- (void)moveToward:(CGPoint)target;

@end




