//
//  HelloWorldScene.h
//
//  Created by : Chao
//  Project    : AStar
//  Date       : 16/8/16
//
//  Copyright (c) 2016年 Chao.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Player.h"


// -----------------------------------------------------------------------

@interface HelloWorldScene : CCScene
{
    Player *player;
    CCTiledMap *map;
}

- (instancetype)init;

@end


































