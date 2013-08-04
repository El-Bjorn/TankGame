//
//  RenderingEngine1.m
//  OC_helloArrow_ES1
//
//  Created by Bjorn Chambless on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderingEngine2.h"
#import "modelTypes.h"
#include "tank_shaders.h"
#include "controller_models.h"
#include "button_model.h"
#include "ScoreDisp.h"

CGPoint physToScreen(CGPoint pt);
CGPoint screenToPhys(CGPoint pt);

// we get one of these notifications when an enemy tank
//    wants to shoot something.
extern NSString *NOTIF_ENEMY_TANK_FIRES;


static void after_shell_hits_tank(cpSpace *space, cpShape *shape, void *unused)
{
    cpSpaceRemoveBody(space, shape->body);
    cpBodyFree(shape->body);
    
    cpSpaceRemoveShape(space, shape);
    cpShapeFree(shape);
}

#define XPOS_MUL 10
#define YPOS_MUL 10

static int shellToTank_collisionHandler(cpArbiter *arb, cpSpace *sp, void *unused) {
    static int playerTank_hits = 0;
    static int enemyTank_hits = 0;
    RenderingEngine2 *rendEng = [RenderingEngine2 ourEngine];
    
    cpShape *t; // tank
    cpShape *s; // shell
    cpArbiterGetShapes(arb, &t, &s);
    if (t == rendEng.playerTank.shape) {
       fprintf(stderr, "player hit ouch!, we've taken %d hits.\n",playerTank_hits++);
        [rendEng.playerScore setString:[NSString stringWithFormat:@"%d",playerTank_hits]];
    } else if (t == rendEng.evilTank1.shape){
       fprintf(stderr,"Enemy tank hit! HA!   hit num:%d\n",enemyTank_hits++);
    }
    CGPoint xPt = (CGPoint)cpBodyGetPos( cpShapeGetBody(s));
    /*xPt.x += 10;
    xPt.y += 10;
    xPt.x *= XPOS_MUL;
    xPt.y *= YPOS_MUL;
    fprintf(stderr,"explosion pt= %.2f,%.2f\n",xPt.x,xPt.y);*/
    [rendEng explosionAtPoint:xPt];
    [rendEng removeShell:s];
    cpSpaceAddPostStepCallback(sp, (cpPostStepFunc)after_shell_hits_tank, s, NULL);
    return 1;
}

void shellHitTank(){
    static int num_hits=0;
    RenderingEngine2 *rendEng = [RenderingEngine2 ourEngine];
    fprintf(stderr,"tank hit! ouch!  hit number: %d\n",num_hits++);
    [rendEng.playerScore setString:[NSString stringWithFormat:@"%d",num_hits]];
}

// this is the pointer to the shared singleton class
//  needed to do this so c-callbacks can easily access the engine
static RenderingEngine2 *theEngine;

@implementation RenderingEngine2

/*-(void) setOurViewLayer:(CALayer*)v {
    ourViewLayer = v;
} */


-(void) explosionAtPoint:(CGPoint)pt {
    CGPoint scrnPt = physToScreen(pt);
    
    [self.tankSounds tankHit];
    
    fprintf(stderr,"explosion phys:(%f,%f), screen:(%f,%f)\n",pt.x,pt.y,scrnPt.x,scrnPt.y);
    CALayer *xLayer = [CALayer layer];
    xLayer.bounds = CGRectMake(0, 0, 100, 100);
    xLayer.position = scrnPt;
    xLayer.opacity = 1.0;
    xLayer.contents = (id)[UIImage imageNamed:@"vector_explosion2bw2.png"].CGImage;
    [ourViewLayer addSublayer:xLayer];
    [UIView animateWithDuration:5.0 animations:^{
        CABasicAnimation *explode = [CABasicAnimation animationWithKeyPath:@"transform"];
        CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fade.duration = 0.5;
        explode.duration = 0.25;
        fade.fromValue = [NSNumber numberWithFloat:1.0];
        fade.toValue = [NSNumber numberWithFloat:0.0];
        explode.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)];
        explode.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
        //[xLayer addAnimation:explode forKey:@"AnimateFrame"];
        [xLayer addAnimation:fade forKey:@"opacity"];
        [xLayer addAnimation:explode forKey:@"transform"];
        xLayer.opacity = 0.0;
    }];
}

-(void) removeShell:(cpShape *)shell {
    //fprintf(stderr,"%d shells in list, removing one\n",[self.shellList count]);
    ShellObject *obj;
    for (obj in self.shellList) {
        //NSLog(@"shell %@",obj);
        if (obj.shape == shell) {
            break;
        }
    }
    [self.shellList removeObject:obj];
}

//static SystemSoundID tankFireSoundID;

/*-(void) initTankFireSound {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tank-fire" ofType:@"caf"];
    NSURL *afURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)afURL,&tankFireSoundID);
    
    NSLog(@"start engine sounds");
} */

/*-(void) tankFireSound {
    AudioServicesPlaySystemSound(tankFireSoundID);
} */

+(RenderingEngine2*) ourEngine {
    if (theEngine == nil){
        fprintf(stderr,"BIG FAT ERROR! Trying to get shared instance before init is called!\n");
        assert(0);
    }
    return theEngine;
}

-(void) enemy_tank_fires {
    //[self tankFireSound];
    [self.tankSounds enemyTankFires];
    [self tankFiresShell:self.evilTank1];
}

-(id) initWithSize:(CGSize)size andViewLayer:(CALayer *)vLayer {
	self = [super init];
	if (self) {
        ourViewLayer = vLayer;
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
        self.shellList = [[NSMutableArray alloc] initWithCapacity:100];
        self.playerTank = [[TankObject alloc] initInSpace:space withPosition:cpv(1, 1) andVelocity:cpv(0,0) andShader:m_simpleProgram];
        self.evilTank1 = [[EnemyTankObject alloc] initInSpace:space withPosition:cpv(10,10) andVelocity:cpv(1,1) andShader:m_simpleProgram];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enemy_tank_fires) name:NOTIF_ENEMY_TANK_FIRES object:nil];
        
        timeStep = 1.0/60.0; // very small timeset
        elapsedTime=0;
        
        // collision handler
        cpSpaceAddCollisionHandler(space, TANK_COL_TYPE, SHELL_COL_TYPE, (cpCollisionBeginFunc)shellToTank_collisionHandler, NULL, NULL, NULL, NULL);
        
        // sound setup
        //[self initTankFireSound];
        self.tankSounds = [[TankSoundController alloc] init];
        [self.tankSounds startEngine];
        
        // score display setup
        //self.playerScore = [[ScoreDisp alloc] initAtPos:CGPointMake(100, 100) withParentLayer:ourView.layer];
        self.playerScore = [CATextLayer layer];
        self.playerScore.bounds = CGRectMake(0, 0, 150, 150);
        self.playerScore.position = CGPointMake(100, 100);
        //self.playerScore.backgroundColor = [UIColor greenColor].CGColor;
        //self.playerScore.contents=(id)[UIImage imageNamed:@"explosionBW2.png"].CGImage;        //self.playerScore.fontSize = 20;
        [self.playerScore setString:@"0"];
        [ourViewLayer addSublayer:self.playerScore];
         
	}
    theEngine = self;
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
    [self.playerTank render];
    [self.evilTank1 render];
    // shells
    NSMutableArray *deadShells = [[NSMutableArray alloc] initWithArray:nil];
    for (ShellObject *s in self.shellList) {
        if ([s tooSlow]) {
            [deadShells addObject:s];
        }
        else {
            [s render];
        }
    }
    for (ShellObject *ds in deadShells) {
        [self.shellList removeObject:ds];
        [ds removeShell];
    }
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
    [self.tankSounds playerTankFires];
    //[self tankFireSound];
    [self tankFiresShell:self.playerTank];
}

-(void) tankFiresShell:(TankObject*)tank {
    cpVect tankPos = cpBodyGetPos(tank.body);
    cpFloat gunDirection = cpBodyGetAngle(tank.body) + M_PI_2;
    cpFloat deltaX = cosf(gunDirection);
    cpFloat deltaY = sinf(gunDirection);
    cpVect shellVel = cpv(deltaX*SHELL_VELOCITY, deltaY*SHELL_VELOCITY);
    cpVect shellPos = cpv(tankPos.x + deltaX*TANK_SIZE, tankPos.y + deltaY*TANK_SIZE);
    
    ShellObject *shell = [[ShellObject alloc] initInSpace:tank.space withPosition:shellPos andVelocity:shellVel andShader:m_simpleProgram];
    [self.shellList addObject:shell];
    
    
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
        self.playerTank.controlForce = contForce;
        
    }
    contTorque = [self rotationDirection];
    self.playerTank.controlTorque = contTorque;
    
    // adjust engine
    float EngVol = (fabs(leftSliderPos)+fabs(rightSliderPos));
    /*if (EngVol < 0.5) {
        EngVol = 0.5;
    } */
    [self.tankSounds setEngineVolume:EngVol/2.0];
    [self.tankSounds setEngineSpeed:EngVol];
    		
}


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
    //fprintf(stderr, "left slider= %.2f\n",p);
	leftSliderPos = p;
}

-(void) setRightSlider:(float)p {
    //fprintf(stderr, "right slider= %.2f\n",p);
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
    for (ShellObject*s in self.shellList) {
        cpShapeFree(s.shape);
        cpBodyFree(s.body);
    }
    cpSpaceFree(space);
    //AudioServicesDisposeSystemSoundID(tankFireSoundID);
}

@end
