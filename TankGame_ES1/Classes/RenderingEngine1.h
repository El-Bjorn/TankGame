//
//  RenderingEngine1.h
//  OC_helloArrow_ES1
//
//  Created by Bjorn Chambless on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>


@interface RenderingEngine1 : NSObject {
	GLuint m_framebuffer;
	GLuint m_renderbuffer;
	
	float m_currentAngle;
	float m_desiredAngle;
	
	int rotationDirection; // based on slider position
	
	float revolutionsPerSecond;
	
	// controllers
	CGRect leftSlider;
	float leftSliderPos; // normalized (-1,1)
	
	CGRect rightSlider;
	float rightSliderPos; // normalized (-1,1)
	
	// translation
	float cumulativeDeltaX;
	float cumulativeDeltaY;
	
	float translationSpeed;
}

-(id) initWithSize:(CGSize)size;
-(void) render;
-(void) renderTank;
-(void) renderController;
-(void) renderSliders;
-(void) updateAnimationWithTimestep:(float)timestep;
-(void) onTouchWithLocation:(CGPoint)location;
-(float) rotationDirection;

-(float) normSliderPosition:(CGPoint)pos;

-(void) setLeftSlider:(float)p;
-(void) setRightSlider:(float)p;
@end
