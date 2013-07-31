//
//  ShellObject.h
//  ES2_tankgame
//
//  Created by BjornC on 7/3/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import "ArenaObject.h"

#define SHELL_VELOCITY 35

@interface ShellObject : ArenaObject


-(id) initInSpace:(cpSpace*)obj_space withPosition:(cpVect)pos
                                        andVelocity:(cpVect)vel
                                        andShader:(GLuint)shade;
-(void) render;

//@property BOOL display;

@end