//
//  TankObject.h
//  ES2_tankgame
//
//  Created by BjornC on 7/3/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//
/*******************************************
 ******************************************/


#import "ArenaObject.h"


@interface TankObject : ArenaObject

-(id) initInSpace:(cpSpace*)obj_space withPosition:(cpVect)pos
                                        andVelocity:(cpVect)vel
                                        andShader:(GLuint)shade;

-(void) renderWithForce:(cpFloat)force andTorque:(cpFloat)torque;

-(void) tankHit;

@end
