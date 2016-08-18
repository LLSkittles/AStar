//
//  Player.m
//
//  Created by : Chao
//  Project    : AStar
//  Date       : 16/8/17
//
//  Copyright (c) 2016年 Chao.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Player.h"
#import "ShortestPathStep.h"

@interface Player ()
{
    NSMutableArray *shortestPath;
}

@property (nonatomic, retain) NSMutableArray *spOpenSteps;
@property (nonatomic, retain) NSMutableArray *spClosedSteps;


- (void)insertInOpenSteps:(ShortestPathStep *)step;
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord;
- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep;

@end

@implementation Player

- (void)insertInOpenSteps:(ShortestPathStep *)step{
    
    int stepFscore = [step fScore];
    int count = (int)self.spOpenSteps.count;
    int i = 0;
    for (; i < count; i++) {
        
        if (stepFscore <= [_spOpenSteps[i] fScore]) {
            
            break;
        }
    }
    
    [_spOpenSteps insertObject:step atIndex:i];
}

- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord
{
    return abs(toCoord.x - fromCoord.x) + abs(toCoord.y - fromCoord.y);
}

- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep{
    
    return 1;
}

- (BOOL)isValidTileCoord:(CGPoint)tileCoord {

    CCTiledMap *map = (CCTiledMap *)self.parent;
    
    if (tileCoord.x < 0 || tileCoord.y < 0 ||
        tileCoord.x >= map.mapSize.width ||
        tileCoord.y >= map.mapSize.height) {
        return FALSE;
    } else {
        return TRUE;
    }
}

- (BOOL)isWallAtCoord:(CGPoint)titleCoord{
    
    CCTiledMap *map = (CCTiledMap *)self.parent;

    CCTiledMapLayer *layer = [map layerNamed:@"bg"];
    int gid = [layer tileGIDAt:titleCoord];
    NSDictionary *porper = [map propertiesForGID:gid];
    BOOL bcollision = [[porper objectForKey:@"collision"] boolValue];
    
    return bcollision;
}

//取得四周的方块
- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord{
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:4];
    
    // Top
    CGPoint p = CGPointMake(tileCoord.x, tileCoord.y - 1);
    if ([self isValidTileCoord:p] && ![self isWallAtCoord:p]) {
        [tmp addObject:[NSValue valueWithCGPoint:p]];
    }
    
    // Left
    p = CGPointMake(tileCoord.x - 1, tileCoord.y);
    if ([self isValidTileCoord:p] && ![self isWallAtCoord:p]) {
        [tmp addObject:[NSValue valueWithCGPoint:p]];
    }
    
    // Bottom
    p = CGPointMake(tileCoord.x, tileCoord.y + 1);
    if ([self isValidTileCoord:p] && ![self isWallAtCoord:p]) {
        [tmp addObject:[NSValue valueWithCGPoint:p]];
    }
    
    // Right
    p = CGPointMake(tileCoord.x + 1, tileCoord.y);
    if ([self isValidTileCoord:p] && ![self isWallAtCoord:p]) {
        [tmp addObject:[NSValue valueWithCGPoint:p]];
    }
    
    return [NSArray arrayWithArray:tmp];
}



- (void)moveToward:(CGPoint)target {
    
    CCTiledMap *map = (CCTiledMap *)self.parent;
    CCTiledMapLayer *layer = [map layerNamed:@"bg"];
    
    CGPoint fromTileCoord = [layer tileCoordinateAt:self.position];
    CGPoint toTileCoord = [layer tileCoordinateAt:target];
    
    NSLog(@"From: %@", NSStringFromCGPoint(fromTileCoord));
    NSLog(@"To: %@", NSStringFromCGPoint(toTileCoord));
    
    self.spOpenSteps = [[NSMutableArray alloc] init];
    self.spClosedSteps = [[NSMutableArray alloc] init];
    
    [self insertInOpenSteps:[[ShortestPathStep alloc] initWithPosition:fromTileCoord]];

    do {
        // 得到f值最小的步骤，因为open表是有序的，总是第一个是最小的
        ShortestPathStep *currentStep = [self.spOpenSteps objectAtIndex:0];
        
        [self.spClosedSteps addObject:currentStep];
        
        [self.spOpenSteps removeObjectAtIndex:0];
        
        // 如果已经搜索到终点
        if (CGPointEqualToPoint(currentStep.position, toTileCoord)) {
            
            ShortestPathStep *tmpStep = currentStep;
            [self constructPathAndStartAnimationFromStep:currentStep];
//            NSLog(@"PATH FOUND :");
//            do {
//                NSLog(@"%@", tmpStep);
//                tmpStep = tmpStep.parent;
//            } while (tmpStep != nil);
            
            [self.spOpenSteps removeAllObjects];
            [self.spClosedSteps removeAllObjects];;
            break;
        }
        
        NSArray *adjSteps = [self walkableAdjacentTilesCoordForTileCoord:currentStep.position];
        for (NSValue *v in adjSteps) {
            ShortestPathStep *step = [[ShortestPathStep alloc] initWithPosition:[v CGPointValue]];
            
            //是否在close表中
            if ([self.spClosedSteps containsObject:step]) {
                continue;
            }
            
            // 计算g值增量
            int moveCost = [self costToMoveFromStep:currentStep toAdjacentStep:step];
            
            // 是否在open表中
            NSUInteger index = [self.spOpenSteps indexOfObject:step];
            
            //不在open表中，添加
            if (index == NSNotFound) {
                
                step.parent = currentStep;
                
                step.gScore = currentStep.gScore + moveCost;
                
                step.hScore = [self computeHScoreFromCoord:step.position toCoord:toTileCoord];
                
                [self insertInOpenSteps:step];
                
            }
            else { // 已经在open表中
                
                step = [self.spOpenSteps objectAtIndex:index]; // 得到表中的step
                
                // 判断使用当前步骤后g值是否会变小，如果更小更新
                if ((currentStep.gScore + moveCost) < step.gScore) {
                    
                    step.gScore = currentStep.gScore + moveCost;
                    
                    [self.spOpenSteps removeObjectAtIndex:index];
                    
                    [self insertInOpenSteps:step];
                    
                }
            }  
        }  
        
    } while ([self.spOpenSteps count] > 0);
}

- (void)constructPathAndStartAnimationFromStep:(ShortestPathStep *)step{
    
    shortestPath = [NSMutableArray array];
    
    do {
        if (step.parent != nil) {
            [shortestPath insertObject:step atIndex:0];
        }
        step = step.parent;
    } while (step != nil);
    for (ShortestPathStep *s in shortestPath) {
        NSLog(@"%@", s);
    }
    
    [self popStepAndAnimate];
}

- (void)popStepAndAnimate{
    
    if ([shortestPath count] == 0) {
        shortestPath = nil;
        return;
    }
    ShortestPathStep *s = [shortestPath objectAtIndex:0];
    
    CCTiledMap *map = (CCTiledMap *)self.parent;
    
    CCTiledMapLayer *layer = [map layerNamed:@"bg"];
    CGPoint position = [layer positionAt:s.position];
    position.x += 16;
    position.y -= 16;
    id moveAction = [CCActionMoveTo actionWithDuration:0.2 position:position];
    CCActionCallBlock *callBack = [CCActionCallBlock actionWithBlock:^{

        [self popStepAndAnimate];
    }];
    
    [shortestPath removeObjectAtIndex:0];
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[moveAction, callBack]];

    [self runAction:sequence];
}

@end





