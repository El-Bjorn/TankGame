//
//  RenderingEngine1.m
//  OC_helloArrow_ES1
//
//  Created by Bjorn Chambless on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderingEngine1.h"
#import <math.h>

typedef struct {
	float Position[2];
	float Color[4];
} Vertex;

/* Vertex models *
 *              */
// asteroids ship
const Vertex Vertices[]={
	{{-0.5,-0.866},{1,1,0.5,1}},
	{{0,-0.5},{1,1,0.5,1}},
	{{0.5,-0.866},{1,1,0.5,1}},
	{{0,1},{1,1,0.5,1}}
};

#include "controller_models.h"
#include "tank_model.h"


@implementation RenderingEngine1

-(id) initWithSize:(CGSize)size {
	self = [super init];
	if (self) {
		// init renderbuffer
		glGenRenderbuffersOES(1, &m_renderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_renderbuffer);
		
		// init framebuffer
		glGenFramebuffersOES(1, &m_framebuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, m_framebuffer);
		
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, 
									 GL_COLOR_ATTACHMENT0_OES, 
									 GL_RENDERBUFFER_OES, m_renderbuffer);
		
		glViewport(0, 0, size.width, size.height);
		glMatrixMode(GL_PROJECTION);
		
		// init proj matrix
		glOrthof(-2, +2, -3, +3, -1, 1);
		glMatrixMode(GL_MODELVIEW);
		
		// set up rects for controls
		leftSlider = CGRectMake(536,860,80,162);
		rightSlider = CGRectMake(670, 860, 80, 162);
		
		// init translation state
		cumulativeDeltaX = 0.0;
		cumulativeDeltaY = 0.0;
		translationSpeed = 0.5;
		
		// init rotation state
		revolutionsPerSecond = 0.1;
		m_desiredAngle = 0;
		m_currentAngle = m_desiredAngle;
	}
	return self;
}

-(void) render {
	//glClearColor(0.5, 0.0, 0.5, 1); // pretty purple
	glClearColor(0.0, 0.0, 0.0, 1);
	glClear(GL_COLOR_BUFFER_BIT);
	[self renderTank];
	[self renderController];
	[self renderSliders];
}

-(void) renderSliders {
	glPushMatrix();
	glTranslatef(1, -2.5, 0);
	glScalef(0.08, 0.08, 0.08);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, sizeof(Vertex), &sliderVerts[0].Position[0]);
	glColorPointer(4, GL_FLOAT, sizeof(Vertex), &sliderVerts[0].Color[0]);
	
	GLsizei sliderVertCount = sizeof(sliderVerts)/sizeof(Vertex);
	
	// draw left slider
	glTranslatef(0, (leftSliderPos*4.5), 0); // move based on slider position
	glDrawArrays(GL_LINE_LOOP, 0, sliderVertCount);
	
	// draw right slider
	glTranslatef(0, -(leftSliderPos*4.5), 0); // undo left slider translation before doing right 
	glTranslatef(8.8, 0, 0);
	glTranslatef(0, (rightSliderPos*4.5), 0);
	glDrawArrays(GL_LINE_LOOP, 0, sliderVertCount);
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glPopMatrix();
}
	

-(void) renderController {
	glPushMatrix();
	// move to bottom-right corner
	glTranslatef(1, -2.5, 0);
	glScalef(0.07, 0.07, 0.07);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, sizeof(Vertex), &controllerVerts[0].Position[0]);
	glColorPointer(4, GL_FLOAT, sizeof(Vertex), &controllerVerts[0].Color[0]);
	
	GLsizei controllerVertCount = sizeof(controllerVerts)/sizeof(Vertex);
	
	// draw left controller strip
	glDrawArrays(GL_LINE_STRIP, 0, controllerVertCount);
	// draw right controller strip
	glTranslatef(10, 0, 0);
	glDrawArrays(GL_LINE_STRIP, 0, controllerVertCount);
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glPopMatrix();
}
	
	
	
-(void) renderTank {	
	glPushMatrix();
	
	// shrink the tank
	glScalef(0.15, 0.15, 0.15);
	//glTranslatef(2, 2, 0);
	// tank translation due to movement
	glTranslatef(cumulativeDeltaX, cumulativeDeltaY, 0);
	glRotatef(m_currentAngle, 0, 0, 1);			
	//fprintf(stderr, "cumX=%f, cumY=%f\n",cumulativeDeltaX,cumulativeDeltaY);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	//glVertexPointer(2, GL_FLOAT, sizeof(Vertex), &Vertices[0].Position[0]);
	glVertexPointer(2, GL_FLOAT, sizeof(Vertex), &turretVerts[0].Position[0]);
	//glColorPointer(4, GL_FLOAT, sizeof(Vertex), &Vertices[0].Color[0]);
	glColorPointer(4, GL_FLOAT, sizeof(Vertex), &turretVerts[0].Color[0]);
	//GLsizei vertexCount = sizeof(Vertices)/sizeof(Vertex);
	GLsizei turretVertCount = sizeof(turretVerts)/sizeof(Vertex);
	//glDrawArrays(GL_TRIANGLES, 0, vertexCount);
	//glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
	glDrawArrays(GL_LINE_LOOP, 0, turretVertCount);
	
	glVertexPointer(2, GL_FLOAT, sizeof(Vertex), &tankVerts[0].Position[0]);
	glColorPointer(4, GL_FLOAT, sizeof(Vertex), &tankVerts[0].Color[0]);
	GLsizei tankVertCount = sizeof(tankVerts)/sizeof(Vertex);
	glDrawArrays(GL_LINE_STRIP, 0, tankVertCount);
	
		
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glPopMatrix();
}

-(void) updateAnimationWithTimestep:(float)timestep {
	float deltaX;
	float deltaY;
	
	// translation section
	translationSpeed = leftSliderPos+rightSliderPos;
	if (fabs(translationSpeed)>0.5) {
		deltaX = -sinf((m_currentAngle)*(M_PI/180))*translationSpeed*timestep;
		cumulativeDeltaX += deltaX;
		deltaY = cosf((m_currentAngle)*(M_PI/180))*translationSpeed*timestep;
		cumulativeDeltaY += deltaY;
	}
	
	float direction = [self rotationDirection];
	if (direction==0) {
		return;
	}
	
	float degrees = timestep * 360 * revolutionsPerSecond;
	m_currentAngle += degrees * direction;
	
	if (m_currentAngle >= 360){
		m_currentAngle = 0;
	}
	if (m_currentAngle < 0) {
		m_currentAngle = 360;
	}
	
	/*if ([self rotationDirection] != direction) {
		m_currentAngle = m_desiredAngle;
	} */
		
}


-(void) onTouchWithLocation:(CGPoint)location {	
	if (CGRectContainsPoint(leftSlider, location)) {
		leftSliderPos = [self normSliderPosition:location];
	}
	if (CGRectContainsPoint(rightSlider, location)) {
		rightSliderPos = [self normSliderPosition:location];
	}
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
	leftSliderPos = p;
}

-(void) setRightSlider:(float)p {
	rightSliderPos = p;
}

@end
