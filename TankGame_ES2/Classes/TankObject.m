//
//  TankObject.m
//  ES2_tankgame
//
//  Created by BjornC on 7/3/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import "TankObject.h"

// openGL model stuff
#import "tank_model.h"
static GLvoid *turretCoords;
static GLvoid *turretColors;
static GLsizei turretVertCount;
static GLvoid *tankCoords;
static GLvoid *tankColors;
static GLsizei tankVertCount;



@implementation TankObject

-(id) initInSpace:(cpSpace*)obj_space withPosition:(cpVect)pos andVelocity:(cpVect)vel andShader:(GLuint)shade
{
    self = [super init];
    if (self) {
        cpFloat width = 2;
        cpFloat height = 2;
        cpFloat mass = 1;
        cpFloat moment = cpMomentForBox(mass, width, height);
        self.space = obj_space;
        self.body = cpSpaceAddBody(obj_space, cpBodyNew(mass, moment));
        cpBodySetPos(self.body, pos);
        cpBodySetVel(self.body, vel);
        self.shape = cpSpaceAddShape(obj_space, cpBoxShapeNew(self.body, width, height));

        cpShapeSetFriction(self.shape, 0.8);
        cpShapeSetElasticity(self.shape, 1.0);
        // add motion limits
        cpBodySetVelLimit(self.body, 3.0);
        cpBodySetAngVelLimit(self.body, 2.0);
        
        cpShapeSetCollisionType(self.shape, TANK_COL_TYPE);
        
        // GL rendering
        self.shaderProgHandle = shade;
        // turret
        turretCoords = (void*)&turretVerts[0].Position[0];
        turretColors = (void*)&turretVerts[0].Color[0];
        //self.turretStride = sizeof(Vertex);
        turretVertCount = sizeof(turretVerts)/sizeof(Vertex);
        // tank body
        tankCoords = (void*)&tankVerts[0].Position[0];
        tankColors = (void*)&tankVerts[0].Color[0];
        //self.tankStride = sizeof(Vertex);
        tankVertCount = sizeof(tankVerts)/sizeof(Vertex);
    }
    return self;
    
}

-(void) render {
    [self renderWithForce:self.controlForce andTorque:self.controlTorque];
}

-(void) renderWithForce:(cpFloat)force andTorque:(cpFloat)torque
{
    cpVect pos = cpBodyGetPos(self.body);
    float rad = cpBodyGetAngle(self.body);
    
    cpVect controlVel;
    controlVel.x = -sinf(rad)*force;
    controlVel.y = cosf(rad)*force;
    //cpBodyApplyForce(self.body, controlForce, cpvzero);
    cpBodySetVel(self.body, controlVel);
    //cpBodySetTorque(self.body, torque*500);
    cpBodySetAngVel(self.body, torque);
    
    float c = cosf(rad);
    float s = sinf(rad);
    float tankTrans[16]={ // translation and scaling only for now
        0.15*c,    0.15*s,      0,     0,
        -0.15*s,       0.15*c,    0,     0,
        0,       0,     0.1,    0,
        0.15*pos.x,  0.15*pos.y,   0,   1
    };
    GLuint modelviewUniform = glGetUniformLocation(self.shaderProgHandle, "Modelview");
    glUniformMatrix4fv(modelviewUniform, 1, 0, &tankTrans[0]);
    GLuint positionSlot = glGetAttribLocation(self.shaderProgHandle, "Position");
    GLuint colorSlot = glGetAttribLocation(self.shaderProgHandle, "SourceColor");
    
    glEnableVertexAttribArray(positionSlot);
    glEnableVertexAttribArray(colorSlot);
    
    // draw tank body
    glVertexAttribPointer(positionSlot, 2, GL_FLOAT, GL_FALSE, vertStride, tankCoords);
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, vertStride, tankColors);
    glDrawArrays(GL_LINE_STRIP, 0, tankVertCount);
    // draw turret
    glVertexAttribPointer(positionSlot, 2, GL_FLOAT, GL_FALSE, vertStride, turretCoords);
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, vertStride, turretColors);
    glDrawArrays(GL_LINE_LOOP, 0, turretVertCount);
    
    glDisableVertexAttribArray(positionSlot);
    glDisableVertexAttribArray(colorSlot);
    
}

-(void) tankHit{
    NSLog(@"We're hit!");
}

-(void) damping {
    // max damping is applied perpendicular to tank direction;
    //float damping_factor = 0.5;
    cpVect current_motion = cpBodyGetVel(self.body);
    cpFloat current_rotation = cpBodyGetAngle(self.body);
    float x_damping = fabs(sinf(current_rotation));
    float y_damping = fabs(cosf(current_rotation));
    fprintf(stderr,"x-damping: %.2f   y-damping: %.2f\n",x_damping,y_damping);
    current_motion.x = current_motion.x * x_damping * 0.5;
    current_motion.y = current_motion.y * y_damping * 0.5;
    cpBodySetVel(self.body, current_motion);
    
    // dampen rotation
    cpFloat angle_vel = cpBodyGetAngVel(self.body);
    angle_vel *= 0.9;
    cpBodySetAngVel(self.body, angle_vel);
    
}

@end
