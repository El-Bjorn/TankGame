//
//  RenderingEngine1.m
//  OC_helloArrow_ES1
//
//  Created by Bjorn Chambless on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import "chipmunk.h"
//#import "ShellObject.h"
//#import "TankObject.h"
#import "RenderingEngine2.h"
#import "modelTypes.h"

/* ----------------- shaders -----------------*/
const char SimpleVertexShader[] =
"attribute vec4 Position;                             \n"
"attribute vec4 SourceColor;                          \n"
"varying vec4 DestinationColor;                       \n"
"uniform mat4 Projection;                             \n"
"uniform mat4 Modelview;                              \n"
"void main(void){                                     \n"
"    DestinationColor = SourceColor;                  \n"
"    gl_Position = Projection * Modelview * Position; \n"
"}                                                    \n";

const char SimpleFragmentShader[] =
"varying lowp vec4 DestinationColor;                  \n"
"void main(void) {                                    \n"
"    gl_FragColor = DestinationColor;                 \n"
"}                                                    \n";


#include "controller_models.h"
#include "button_model.h"
//#include "tank_model.h"
//#include "tank_shell.h"

static void postStepRemoveShell(cpShape *sp, cpShape *shell, void *unused){
    
    
}

static int shellToTank_collisionHandler(cpArbiter *arb, cpSpace *sp, void *unused) {
    cpShape *t; // tank
    cpShape *s; // shell
    cpArbiterGetShapes(arb, &t, &s);
    return 0;
}

void shellHitTank(){
    static int num_hits=0;
    fprintf(stderr,"tank hit! ouch!  hit number: %d\n",num_hits++);
}

@implementation RenderingEngine2

-(id) initWithSize:(CGSize)size {
	self = [super init];
	if (self) {
		// init renderbuffer
		glGenRenderbuffers(1, &m_renderbuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, m_renderbuffer);
		
		// init framebuffer
		glGenFramebuffers(1, &m_framebuffer);
		glBindFramebuffer(GL_FRAMEBUFFER, m_framebuffer);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, 
								  GL_COLOR_ATTACHMENT0, 
								  GL_RENDERBUFFER, m_renderbuffer);
		glViewport(0, 0, size.width, size.height);
		
		m_simpleProgram = [self buildProgram];
		glUseProgram(m_simpleProgram);
		
		// init projection matrix
		[self applyOrtho_MaxX:2.0 MaxY:3.0];
		// set up rects for controls
		leftSlider = CGRectMake(536,860,80,162);
		rightSlider = CGRectMake(670, 860, 80, 162);
		
		// init translation state
		cumulativeDeltaX = 0.0;
		cumulativeDeltaY = 0.0;
		translationSpeed = 0.5;
        
        
        // startup chipmunk
        space = cpSpaceNew();
        gravity = cpv(0,0); // low gravity
        cpSpaceSetGravity(space, gravity);
        //ground = cpSegmentShapeNew(space->staticBody, cpv(-20,-18), cpv(20,-17.5), 0);
        // setup boundaries
        bottomBounds = cpSegmentShapeNew(space->staticBody, cpv(-14,-21), cpv(13,-21), 1);
        leftBounds = cpSegmentShapeNew(space->staticBody, cpv(-14,-20), cpv(-14,20), 1);
        topBounds = cpSegmentShapeNew(space->staticBody, cpv(-14,20), cpv(13.5,20), 1);
        rightBounds = cpSegmentShapeNew(space->staticBody, cpv(13.5,20), cpv(13.5,-20), 1);
        cpShapeSetFriction(bottomBounds, 0);
        cpShapeSetFriction(leftBounds, 0);
        cpShapeSetFriction(topBounds, 0);
        cpShapeSetFriction(rightBounds, 0);
        cpShapeSetElasticity(bottomBounds, 1);
        cpShapeSetElasticity(leftBounds, 1);
        cpShapeSetElasticity(topBounds, 1);
        cpShapeSetElasticity(rightBounds, 1);
        cpSpaceAddShape(space, bottomBounds);
        cpSpaceAddShape(space, leftBounds);
        cpSpaceAddShape(space, topBounds);
        cpSpaceAddShape(space, rightBounds);
        
        srand(time(NULL));
        //int numShells = 10; //rand()%100;
        //int i;
        shellList = [[NSMutableArray alloc] initWithCapacity:100];
        /*for (i=0; i<numShells; i++) {
            cpVect randPos;
            cpVect randVel;
            randPos.x = rand()%20-10;
            randPos.y = rand()%20-10;
            randVel.x = rand()%100-50;
            randVel.y = rand()%100-50;
            
            shell1 = [[ShellObject alloc] initInSpace:space withPosition:randPos andVelocity:randVel andShader:m_simpleProgram];
            [shellList addObject:shell1];
        } */
        playerTank = [[TankObject alloc] initInSpace:space withPosition:cpv(1, 1) andVelocity:cpv(0,0) andShader:m_simpleProgram];
        
        timeStep = 1.0/60.0; // very small timeset
        elapsedTime=0;
        
        // collision handler
        cpSpaceAddCollisionHandler(space, TANK_COL_TYPE, SHELL_COL_TYPE, (cpCollisionBeginFunc)shellHitTank, NULL, NULL, NULL, NULL);
        
	}
	return self;
}


-(GLuint) buildProgram {
	GLuint vertexShader = [self buildShaderWithSource:SimpleVertexShader andType:GL_VERTEX_SHADER];
	GLuint fragmentShader = [self buildShaderWithSource:SimpleFragmentShader andType:GL_FRAGMENT_SHADER];
	
	GLuint programHandle = glCreateProgram();
	glAttachShader(programHandle, vertexShader);
	glAttachShader(programHandle, fragmentShader);
	glLinkProgram(programHandle);
	
	GLint linkSuccess;
	glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
	if (linkSuccess==GL_FALSE) {
		GLchar messages[256];
		glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
		fprintf(stderr, "program link error=%s\n",messages);
		exit(1);
	}
	return programHandle;
}

-(GLuint) buildShaderWithSource:(const char*)src andType:(GLenum)type {
	GLuint shaderHandle = glCreateShader(type);
	glShaderSource(shaderHandle, 1, &src, 0);
	glCompileShader(shaderHandle);
	
	GLint compileSuccess;
	glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
	
	if (compileSuccess == GL_FALSE) {
		GLchar messages[256];
		glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
		fprintf(stderr, "shader compile error=%s\n",messages);
		exit(1);
	}
	return shaderHandle;
}

-(void) render {
	//glClearColor(0.5, 0.0, 0.5, 1); // pretty purple
	glClearColor(0.0, 0.0, 0.0, 1);
	glClear(GL_COLOR_BUFFER_BIT);
	
	//[self renderTank];
	[self renderController];
	[self renderSliders];
    [self renderFireButton];
    //[playerTank renderWithForce:contForce andTorque:contTorque];
    [playerTank render];
    for (ShellObject *s in shellList) {
        [s render];
    }
    // start shooting?
    /*if (rand()%100 == 150) {
        [self tankFiresShell:playerTank];
    } */
}

-(void) renderSliders {
	float ls = leftSliderPos*4.5;
	float rs = rightSliderPos*4.5;
	float leftSliderMatrix[16]={
		0.08,  0,       0,     0,
		0,     0.08,    0,     0,
		0,     0,       0.08,  0,
		1,  (0.08*ls)-2.5,    0,     1
	};
	float rightSliderMatrix[16]={
		0.08,  0,        0,     0,
		0,     0.08,     0,     0,
		0,     0,        0.08,  0,
		1.704,(0.08*rs)-2.5, 0,  1
	};
	GLsizei stride = sizeof(Vertex);
	GLuint modelviewUniform = glGetUniformLocation(m_simpleProgram, "Modelview");
	GLuint positionSlot = glGetAttribLocation(m_simpleProgram, "Position");
	GLuint colorSlot = glGetAttribLocation(m_simpleProgram, "SourceColor");
	glEnableVertexAttribArray(positionSlot);
	glEnableVertexAttribArray(colorSlot);
	
	GLvoid *pCoords = (GLvoid*)&sliderVerts[0].Position[0];
	GLvoid *pColors = (GLvoid*)&sliderVerts[0].Color[0];
	
	glVertexAttribPointer(positionSlot, 2, GL_FLOAT, GL_FALSE, stride, pCoords);
	glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, stride, pColors);
	GLsizei sliderVertCount = sizeof(sliderVerts)/sizeof(Vertex);
	
	// draw left slider
	glUniformMatrix4fv(modelviewUniform, 1, 0, &leftSliderMatrix[0]);
	glDrawArrays(GL_LINE_LOOP, 0, sliderVertCount);
	
	// draw right slider
	glUniformMatrix4fv(modelviewUniform, 1, 0, &rightSliderMatrix[0]);
	glDrawArrays(GL_LINE_LOOP, 0, sliderVertCount);
	
	
	glDisableVertexAttribArray(positionSlot);
	glDisableVertexAttribArray(colorSlot);	
	
}

-(void) renderFireButton {
    float buttonTrans[16]={
        0.1, 0, 0, 0,
        0,  0.1, 0, 0,
        0,   0, 0.1, 0,
        -1.4,-2.6, 0,1
    };
    GLsizei stride = sizeof(Vertex);
	GLuint modelviewUniform = glGetUniformLocation(m_simpleProgram, "Modelview");
	GLuint positionSlot = glGetAttribLocation(m_simpleProgram, "Position");
	GLuint colorSlot = glGetAttribLocation(m_simpleProgram, "SourceColor");
	glEnableVertexAttribArray(positionSlot);
	glEnableVertexAttribArray(colorSlot);
	
	GLvoid *pCoords = (GLvoid*)&fireButton[0].Position[0];
	GLvoid *pColors = (GLvoid*)&fireButton[0].Color[0];
	
	glVertexAttribPointer(positionSlot, 2, GL_FLOAT, GL_FALSE, stride, pCoords);
	glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, stride, pColors);
	GLsizei buttonVertCount = sizeof(fireButton)/sizeof(Vertex);
	
	// draw button
	glUniformMatrix4fv(modelviewUniform, 1, 0, &buttonTrans[0]);
	glDrawArrays(GL_LINE_LOOP, 0, buttonVertCount);
	
	
	glDisableVertexAttribArray(positionSlot);
	glDisableVertexAttribArray(colorSlot);
    
}
	

-(void) renderController { 
	float leftContTrans[16]={
		0.07,0,0,0,
		0,0.07,0,0,
		0,0,0.07,0,
		1,-2.5,0,1
	};
	float rightContTrans[16]={
		0.07,0,0,0,
		0,0.07,0,0,
		0,0,0.07,0,
		1.7,-2.5,0,1
	};
	GLuint modelviewUniform = glGetUniformLocation(m_simpleProgram, "Modelview");
	glUniformMatrix4fv(modelviewUniform, 1, 0, &leftContTrans[0]);
	 
	GLuint positionSlot = glGetAttribLocation(m_simpleProgram, "Position");
	GLuint colorSlot = glGetAttribLocation(m_simpleProgram, "SourceColor");
	 
	glEnableVertexAttribArray(positionSlot);
	glEnableVertexAttribArray(colorSlot);
	 
	GLsizei stride = sizeof(Vertex);
	 
	
	GLvoid *pCoords = (void*)&controllerVerts[0].Position[0];
	GLvoid *pColors = (void*)&controllerVerts[0].Color[0];
	 
	glVertexAttribPointer(positionSlot, 2, GL_FLOAT, GL_FALSE, stride, pCoords);
	glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, stride, pColors);
	 
	GLsizei controllerVertCount = sizeof(controllerVerts)/sizeof(Vertex);
	// left controller
	glDrawArrays(GL_LINE_STRIP, 0, controllerVertCount);
	// right controller
	glUniformMatrix4fv(modelviewUniform, 1, 0, &rightContTrans[0]);
	glDrawArrays(GL_LINE_STRIP, 0, controllerVertCount);
	 
	glDisableVertexAttribArray(positionSlot);
	glDisableVertexAttribArray(colorSlot);	
}

-(void) playerTankFiresShell {
    [self tankFiresShell:playerTank];
}

-(void) tankFiresShell:(TankObject*)tank {
    cpVect tankPos = cpBodyGetPos(tank.body);
    cpFloat gunDirection = cpBodyGetAngle(tank.body) + M_PI_2;
    cpVect shellVel = cpv(cosf(gunDirection)*SHELL_VELOCITY, sinf(gunDirection)*SHELL_VELOCITY);
    
    
    ShellObject *shell = [[ShellObject alloc] initInSpace:tank.space withPosition:tankPos andVelocity:shellVel andShader:m_simpleProgram];
    [shellList addObject:shell];
    
    //
    
}



-(void) updateAnimationWithTimestep:(float)timestep {
    // update chipmunk time
    elapsedTime += timeStep;
    cpSpaceStep(space, timeStep);
	
	// translation section
	translationSpeed = leftSliderPos+rightSliderPos;
    
    // tank control forces
    if (fabs(translationSpeed)>0.5) {
        contForce = translationSpeed;
        playerTank.controlForce = contForce;
        
    }
    contTorque = [self rotationDirection];
    playerTank.controlTorque = contTorque;
    		
}


/*-(void) onTouchWithLocation:(CGPoint)location {
    fprintf(stderr, "Touch at: %.2f, %.2f\n",location.x,location.y);
	if (CGRectContainsPoint(leftSlider, location)) {
		leftSliderPos = [self normSliderPosition:location];
	}
	if (CGRectContainsPoint(rightSlider, location)) {
		rightSliderPos = [self normSliderPosition:location];
	}
} */

-(float) rotationDirection {
	// determine rotation direction from controller positions
	if (fabs(leftSliderPos-rightSliderPos) < 0.2) {
		return 0;
	}
	if ((leftSliderPos - rightSliderPos)<0) {
		return 1;
	}
	return -1;
}

-(float) normSliderPosition:(CGPoint)pos {
	float normed = (pos.y-941)/81;
	normed *= -1; // flip so 1 is up & -1 is down
	return normed;
}
												   
-(void) setLeftSlider:(float)p {
	leftSliderPos = p;
}

-(void) setRightSlider:(float)p {
	rightSliderPos = p;
}

/* matrix transform methods */
-(void) applyOrtho_MaxX:(float)maxX MaxY:(float)maxY {
	float a = 1.0/maxX;
	float b = 1.0/maxY;
	float ortho[16]={
		a,0,0,0,
		0,b,0,0,
		0,0,-1,0,
		0,0,0,1
	};
	GLint projectionUniform = glGetUniformLocation(m_simpleProgram, "Projection");
	glUniformMatrix4fv(projectionUniform, 1, 0, &ortho[0]);
}

-(void) dealloc {
    for (ShellObject*s in shellList) {
        cpShapeFree(s.shape);
        cpBodyFree(s.body);
    }
    cpSpaceFree(space);
}

@end
