//
//  EnemyTankObject.h
//  ES2_tankgame
//
//  Created by BjornC on 7/3/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//
/*******************************************
 This is an enemy tank
 ******************************************/


#import "TankObject.h"


@interface EnemyTankObject : TankObject

-(void) tankFires; // we shoot stuff

-(void) ai_tank_controls; // make control adjustments

-(void) tankHit;

-(void) render;

@end
