//
//  TankObject.h
//  ES2_tankgame
//
//  Created by BjornC on 7/3/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//
/*******************************************
 ******************************************/

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <math.h>
#import <UIKit/UIKit.h>
#include "chipmunk.h"



@interface TankObject : NSObject

@property cpSpace *space;
@property cpBody *body;
@property cpShape *shape;
@property cpFloat *sz_scale; // size scaling
@property cpFloat *tr_scale; // translation scaling

@property GLuint shaderProgHandle;

@property GLvoid *turretCoords;
@property GLvoid *turretColors;
@property GLsizei turretVertCount;
@property GLsizei turretStride;

@property GLvoid *tankCoords;
@property GLvoid *tankColors;
@property GLsizei tankVertCount;
@property GLsizei tankStride;


-(id) initInSpace:(cpSpace*)obj_space withPosition:(cpVect)pos
                                        andVelocity:(cpVect)vel
                                        andShader:(GLuint)shade;

-(void) renderWithForce:(cpFloat)force andTorque:(cpFloat)torque;

-(void) damping;

@end
