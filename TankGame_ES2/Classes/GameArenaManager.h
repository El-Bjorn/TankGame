//
//  GameArenaManager.h
//  ES2_tankgame
//
//  Created by BjornC on 8/6/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//
/* For loading the arena specs. from a plist and adding    *
 *  the walls and such. Everything we add will be a static shapes */


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "coordsTrans.h"
#import "chipmunk.h"

#define MAX_WALLS 1000

// wall points are in screen-space
typedef struct {
    CGPoint startPt;
    CGPoint endPt;
    
} wallSection;

@interface GameArenaManager : NSObject {
    CALayer *parentLayer;
    CAShapeLayer *arenaLayer;
    cpSpace *arenaSpace;
    NSPointerArray *wallShapes; // store the walls
    CGMutablePathRef wallPath;
}

@property NSArray *arenaWalls; // we will read this from the plist

-(id) initArena:(NSString*)arena withParentLayer:(CALayer*)pLayer andArenaSpace:(cpSpace*)space;

-(void) addWall:(wallSection)w;

// will read "arena.plist"
-(NSDictionary*) loadArena:(NSString*)arena;




@end
