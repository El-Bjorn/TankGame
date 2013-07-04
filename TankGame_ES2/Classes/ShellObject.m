//
//  ShellObject.m
//  ES2_tankgame
//
//  Created by BjornC on 7/3/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import "ShellObject.h"
#import "tank_shell.h"

@implementation ShellObject

-(id) initInSpace:(cpSpace*)obj_space withPosition:(cpVect)pos andVelocity:(cpVect)vel andShader:(GLuint)shade
{
    self = [super init];
    if (self) {
        // physics engine
        cpFloat radius = 1;
        cpFloat mass = 1;
        cpFloat moment = cpMomentForCircle(mass, 0, radius, cpvzero);
        self.space = obj_space;
        self.body = cpSpaceAddBody(obj_space, cpBodyNew(mass, moment));
        cpBodySetPos(self.body, pos);
        cpBodySetVel(self.body, vel);
        self.shape = cpSpaceAddShape(obj_space, cpCircleShapeNew(self.body, radius, cpvzero));
        cpShapeSetFriction(self.shape, 0.7);
        cpShapeSetElasticity(self.shape, 0.7);
        
        // GL rendering
        self.shaderProgHandle = shade;
        self.coords = (void*)&tankShell[0].Position[0];
        self.colors = (void*)&tankShell[0].Color[0];
        self.shellStride = sizeof(Vertex);
        self.shellVertCount = sizeof(tankShell)/sizeof(Vertex);
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
    
    glVertexAttribPointer(positionSlot, 2, GL_FLOAT, GL_FALSE, self.shellStride, self.coords);
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, self.shellStride, self.colors);
    glDrawArrays(GL_LINE_LOOP, 0, self.shellVertCount);
    glDisableVertexAttribArray(positionSlot);
    glDisableVertexAttribArray(colorSlot);
}

@end
