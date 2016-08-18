//
//  ShortestPathStep.h
//  AStar
//
//  Created by Chao on 16/8/17.
//  Copyright © 2016年 Chao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortestPathStep : NSObject

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) int gScore;
@property (nonatomic, assign) int hScore;
@property (nonatomic, strong) ShortestPathStep *parent;

- (id)initWithPosition:(CGPoint)pos;
- (int)fScore;

@end
