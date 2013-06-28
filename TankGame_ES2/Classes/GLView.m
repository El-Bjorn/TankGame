//
//  GLView.m
//  OC_helloArrow_ES1
//
//  Created by Bjorn Chambless on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <OpenGLES/EAGLDrawable.h>
#import "GLView.h"
#import <mach/mach_time.h>
#import "ControllerView.h"


@implementation GLView

+(Class) layerClass {
	return [CAEAGLLayer class];
}



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		CAEAGLLayer *eaglLayer = (CAEAGLLayer*) super.layer;
		/* optimization stuff */
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:FALSE],kEAGLDrawablePropertyRetainedBacking,
										kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
		
		EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
		
		m_context = [[EAGLContext alloc] initWithAPI:api];
		
		[EAGLContext setCurrentContext:m_context];
		
		m_renderingEngine = [[RenderingEngine2 alloc] initWithSize:frame.size];
		
		
		[m_context renderbufferStorage:GL_RENDERBUFFER
						  fromDrawable:eaglLayer];
		
		
		[self drawView:nil];
		
		m_timestamp = CACurrentMediaTime();
		
		CADisplayLink *displayLink;

		displayLink = [CADisplayLink displayLinkWithTarget:self 
												 selector:@selector(drawView:)];
		[displayLink addToRunLoop:[NSRunLoop currentRunLoop] 
						  forMode:NSDefaultRunLoopMode];
		displayLink.frameInterval=2; // slow the refresh to improve touch performance?
		
		self.multipleTouchEnabled = YES;
		
		// set up control views
		ControllerView *c_left=[[ControllerView alloc] initWithFrame: CGRectMake(536, 860, 80, 162)
														  rendEngine:m_renderingEngine
															   andID:leftContoller];
		[self addSubview:c_left];
		ControllerView *c_right=[[ControllerView alloc] initWithFrame:CGRectMake(670, 860, 80, 162)
														   rendEngine:m_renderingEngine
																andID:rightController];
		[self addSubview:c_right];
	}
	
    return self;
}


-(void) drawView:(CADisplayLink *)displayLink {
	if (displayLink != nil) {
		float elapsedSeconds = displayLink.timestamp - m_timestamp;
		m_timestamp = displayLink.timestamp;
		[m_renderingEngine updateAnimationWithTimestep:elapsedSeconds];
	}
	[m_renderingEngine render];
	[m_context presentRenderbuffer:GL_RENDERBUFFER];
}


- (void)dealloc {
	[EAGLContext setCurrentContext:nil];
	[m_context release];
	[m_renderingEngine release];
    [super dealloc];
}


@end
