//
//  ShellObject.h
//  ES2_tankgame
//
//  Created by BjornC on 7/3/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//
/*******************************************
 *     Superclass for all dynamic objects that exist within arena
 *          tanks, shells, etc...
 *     We're going to keep track of all the state (physics, graphic, game data) here
 ******************************************/

//#import <Foundation/Foundation.h>
//#import "RenderingEngine2.h"
/*#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <math.h>
#import <UIKit/UIKit.h>
#include "chipmunk.h" */
//#import "tank_shell.h"

#import "ArenaObject.h"

#define SHELL_VELOCITY 35

@interface ShellObject : ArenaObject


-(id) initInSpace:(cpSpace*)obj_space withPosition:(cpVect)pos
                                        andVelocity:(cpVect)vel
                                        andShader:(GLuint)shade;
-(void) render;

@end