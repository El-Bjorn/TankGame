//
//  TankObject.h
//  ES2_tankgame
//
//  Created by BjornC on 7/3/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//
/*******************************************
 This is the player tank
 ******************************************/


#import "ArenaObject.h"

#define TANK_SIZE 1 // size of tank on the screen


@interface TankObject : ArenaObject

// these are tank control parameters, set by the sliders
//     and button in the interface
@property cpFloat controlForce;
@property cpFloat controlTorque;

-(id) initInSpace:(cpSpace*)obj_space withPosition:(cpVect)pos
                                        andVelocity:(cpVect)vel
                                        andShader:(GLuint)shade;

// make this private
-(void) renderWithForce:(cpFloat)force andTorque:(cpFloat)torque;

-(void) render;

-(void) tankHit;

@end
