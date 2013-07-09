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

/*@property cpSpace *space;
@property cpBody *body;
@property cpShape *shape;
@property cpFloat *sz_scale; // size scaling
@property cpFloat *tr_scale; // translation scaling
@property GLvoid *coords;
@property GLvoid *colors;
@property GLuint shaderProgHandle;
@property GLsizei shellVertCount;
@property GLsizei shellStride; */


-(id) initInSpace:(cpSpace*)obj_space withPosition:(cpVect)pos
                                        andVelocity:(cpVect)vel
                                        andShader:(GLuint)shade;
-(void) render;
//-(void) setShaderProgHandle:(GLuint)shaderProgHandle;

@end