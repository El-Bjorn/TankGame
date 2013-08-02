//
//  RenderingEngine2.h
//  OC_helloArrow_ES1
//
//  Created by Bjorn Chambless on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <math.h>
#import <UIKit/UIKit.h>
#include "chipmunk.h"

#import "ShellObject.h"
#import "TankObject.h"
#import "EnemyTankObject.h"
#import "TankSoundController.h"
#import "ScoreDisp.h"


@interface RenderingEngine2 : NSObject {
    
    // doing evil things with CALayers
    CALayer *ourViewLayer;
    //ScoreDisp *playerScore;

	GLuint m_framebuffer;
	GLuint m_renderbuffer;
	GLuint m_simpleProgram;
	
	//float m_currentAngle;
	//float m_desiredAngle;
	
	int rotationDirection; // based on slider position
	
	//float revolutionsPerSecond;
	
	// controllers
	CGRect leftSlider;
	float leftSliderPos; // normalized (-1,1)
	
	CGRect rightSlider;
	float rightSliderPos; // normalized (-1,1)
    	
	// translation
	float cumulativeDeltaX;
	float cumulativeDeltaY;
	
	float translationSpeed;
    
    // tank control forces
    cpFloat contForce;
    cpFloat contTorque;
    
    // chipmunk stuff
    cpVect gravity;
    cpSpace *space;
    cpFloat radius;
    cpFloat mass;
    cpFloat moment;
    cpShape *topBounds,*bottomBounds,*leftBounds,*rightBounds;
    cpFloat timeStep;
    cpFloat elapsedTime;
}
@property NSMutableArray *shellList;
@property CATextLayer *playerScore;

@property TankObject *playerTank;
@property EnemyTankObject *evilTank1;
//}
@property TankSoundController *tankSounds;

+(RenderingEngine2*) ourEngine;
-(void) applyOrtho_MaxX:(float)maxX MaxY:(float)maxY;
-(id) initWithSize:(CGSize)size andViewLayer:(CALayer*)vLayer;
-(GLuint) buildProgram;
-(GLuint) buildShaderWithSource:(const char*)src andType:(GLenum)type;


// this is for doing bad things with CALayer in openGL
//-(void) setOurView:(UIView*)v;
-(void) explosionAtPoint:(CGPoint)pt;

-(void) render;
-(void) renderSliders;
-(void) renderController;
-(void) renderFireButton;

-(void) playerTankFiresShell;
-(void) removeShell:(cpShape*)shell;

-(void) updateAnimationWithTimestep:(float)timestep;

-(float) rotationDirection;

-(float) normSliderPosition:(CGPoint)pos;

-(void) setLeftSlider:(float)p;
-(void) setRightSlider:(float)p;
@end
