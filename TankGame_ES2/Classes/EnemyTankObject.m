//
//  EnemyTankObject.m
//  ES2_tankgame
//
//  Created by BjornC on 7/3/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import "EnemyTankObject.h"

// openGL model stuff
#import "enemy_tank_model.h"
/*static GLvoid *turretCoords;
static GLvoid *turretColors;
static GLsizei turretVertCount;
static GLvoid *tankCoords;
static GLvoid *tankColors;
static GLsizei tankVertCount; */

NSString *NOTIF_ENEMY_TANK_FIRES = @"NOTIF_ENEMY_TANK_FIRES";



@implementation EnemyTankObject

-(id) initInSpace:(cpSpace*)obj_space withPosition:(cpVect)pos andVelocity:(cpVect)vel andShader:(GLuint)shade
{
    self = [super initInSpace:obj_space withPosition:pos andVelocity:vel andShader:shade];
    if (self) {
    }
    return self;
    
}

// shootin' stuff, we'll send a notification
-(void) tankFires {
    
}

// here we make adjustments to:
//  cpFloat controlForce &
//  cpFloat controlTorque
//       so that we may carry out our mission of destruction
-(void) ai_tank_controls {
    if (rand()%10 == 5) { // change force
        self.controlForce = ((rand()%200)-100.0)/100.0;
    }
    if (rand()%50 == 5){ // change torque
        self.controlTorque = ((rand()%200)-100.0)/100.0;
    }
    if (rand()%500 == 50){ // shoot
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_ENEMY_TANK_FIRES object:self];
    }
}


-(void) tankHit {
    NSLog(@"Enemy tank hit!");
}

-(void) render {
    [self ai_tank_controls];
    [super render];
}

@end
