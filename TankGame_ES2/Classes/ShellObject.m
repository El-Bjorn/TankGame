//
//  ShellObject.m
//  ES2_tankgame
//
//  Created by BjornC on 7/3/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import "ShellObject.h"

// openGL model stuff
#import "shell_model.h"
static GLvoid *shellCoords;
static GLvoid *shellColors;
static GLsizei shellVertCount;

@implementation ShellObject

-(BOOL) tooSlow {
    CGPoint velVect = cpBodyGetVel(self.body);
    float shellVel = (velVect.x * velVect.x)+(velVect.y * velVect.y); // A^2+B^2
    if (shellVel < (MIN_SHELL_VELOCITY*MIN_SHELL_VELOCITY)) {
        return YES;
    }
    return NO;
}

-(void) removeShell {
    cpSpaceRemoveBody(self.space, self.body);
    cpBodyFree(self.body);
    cpSpaceRemoveShape(self.space, self.shape);
    cpShapeFree(self.shape);
}

-(id) initInSpace:(cpSpace*)obj_space withPosition:(cpVect)pos andVelocity:(cpVect)vel andShader:(GLuint)shade
{
    self = [super init];
    if (self) {
        // physics engine
        cpFloat radius = 0.2;
        cpFloat mass = 1;
        cpFloat moment = cpMomentForCircle(mass, 0, radius, cpvzero);
        self.space = obj_space;
        self.body = cpSpaceAddBody(obj_space, cpBodyNew(mass, moment));
        cpBodySetPos(self.body, pos);
        cpBodySetVel(self.body, vel);
        self.shape = cpSpaceAddShape(obj_space, cpCircleShapeNew(self.body, radius, cpvzero));
        cpShapeSetFriction(self.shape, 0.7);
        cpShapeSetElasticity(self.shape, 0.99);
        
        cpShapeSetCollisionType(self.shape, SHELL_COL_TYPE);
        
        // GL rendering
        self.shaderProgHandle = shade;
        shellCoords = (void*)&tankShell[0].Position[0];
        shellColors = (void*)&tankShell[0].Color[0];
        shellVertCount = sizeof(tankShell)/sizeof(Vertex);
        
        //self.display = YES;
    }
    return self;
    
}

-(void) render {
    cpVect pos = cpBodyGetPos(self.body);
    float shellTrans[16]={ // translation and scaling only for now
        0.01,    0,      0,     0,
        0,       0.01,    0,     0,
        0,       0,     0.01,    0,
        0.15*pos.x,  0.15*pos.y,   0,   1
    };
    GLuint modelviewUniform = glGetUniformLocation(self.shaderProgHandle, "Modelview");
    glUniformMatrix4fv(modelviewUniform, 1, 0, &shellTrans[0]);
    GLuint positionSlot = glGetAttribLocation(self.shaderProgHandle, "Position");
    GLuint colorSlot = glGetAttribLocation(self.shaderProgHandle, "SourceColor");
    
    glEnableVertexAttribArray(positionSlot);
    glEnableVertexAttribArray(colorSlot);
    
    glVertexAttribPointer(positionSlot, 2, GL_FLOAT, GL_FALSE, vertStride, shellCoords);
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, vertStride, shellColors);
    glDrawArrays(GL_LINE_LOOP, 0, shellVertCount);
    glDisableVertexAttribArray(positionSlot);
    glDisableVertexAttribArray(colorSlot);
}

@end
