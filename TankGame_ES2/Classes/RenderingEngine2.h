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


@interface RenderingEngine2 : NSObject {
	GLuint m_framebuffer;
	GLuint m_renderbuffer;
	GLuint m_simpleProgram;
	
	float m_currentAngle;
	float m_desiredAngle;
	
	int rotationDirection; // based on slider position
	
	float revolutionsPerSecond;
	
	// controllers
	CGRect leftSlider;
	float leftSliderPos; // normalized (-1,1)
	
	CGRect rightSlider;
	float rightSliderPos; // normalized (-1,1)
    
    // the shell
    CGPoint shellPos;
	
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
    cpBody *ballBody;
    cpShape *ballShape;
    //cpShape *ground;
    cpShape *topBounds,*bottomBounds,*leftBounds,*rightBounds;
    cpFloat timeStep;
    cpFloat elapsedTime;
    
    ShellObject *shell1;
    ShellObject *shell2;
    ShellObject *shell3;
    NSMutableArray *shellList;
    TankObject *tank1;
}
-(void) applyOrtho_MaxX:(float)maxX MaxY:(float)maxY;
-(id) initWithSize:(CGSize)size;
-(GLuint) buildProgram;
-(GLuint) buildShaderWithSource:(const char*)src andType:(GLenum)type;

-(void) render;
-(void) renderSliders;
-(void) renderController;
-(void) renderFireButton;

-(void) renderTank;
//-(void) renderShell;

-(void) updateAnimationWithTimestep:(float)timestep;

-(float) rotationDirection;

-(float) normSliderPosition:(CGPoint)pos;

-(void) setLeftSlider:(float)p;
-(void) setRightSlider:(float)p;
@end
