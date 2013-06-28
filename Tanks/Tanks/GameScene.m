//
//  GameScene.m
//  Tanks
//
//  Created by Bjorn Chambless on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(id) init {
    self = [super init];
    if (self != nil){
        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        [self addChild:backgroundLayer z:0];
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z:5];
    }
    return self;
}

@end
