//
//  GameplayLayer.m
//  Tanks
//
//  Created by Bjorn Chambless on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameplayLayer.h"

@implementation GameplayLayer

-(id) init {
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        self.isTouchEnabled = YES;
        tankSprite = [CCSprite spriteWithFile:@"tank2.png"];
        [tankSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height*0.17f)];
        [self addChild:tankSprite];
        
    }
    return self;
}
@end
