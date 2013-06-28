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
#import <OpenGLES/ES1/gl.h>

#import "ControllerView.h"


@implementation GLView

+(Class) layerClass {
	return [CAEAGLLayer class];
}

/* touch stuff 
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[m_renderingEngine onTouchWithLocation:[[touches anyObject] locationInView:self]];
}
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	UITouch *touch = [touches anyObject];
//	[m_renderingEngine onTouchWithLocation:[touch locationInView:self]];
//} 

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[m_renderingEngine onTouchWithLocation:[[touches anyObject] locationInView:self]];
}
*/


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		CAEAGLLayer *eaglLayer = (CAEAGLLayer*) super.layer;
		/* optimization stuff */
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:FALSE],kEAGLDrawablePropertyRetainedBacking,
										kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
		
		m_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		[EAGLContext setCurrentContext:m_context];
		
		m_renderingEngine = [[RenderingEngine1 alloc] initWithSize:frame.size];
		
		
		[m_context renderbufferStorage:GL_RENDERBUFFER_OES
						  fromDrawable:eaglLayer];
		
		
		[self drawView:nil];
		
		m_timestamp = CACurrentMediaTime();
		
		CADisplayLink *displayLink;
		self.multipleTouchEnabled = YES;
		displayLink = [CADisplayLink displayLinkWithTarget:self 
												 selector:@selector(drawView:)];
		[displayLink addToRunLoop:[NSRunLoop currentRunLoop] 
						  forMode:NSDefaultRunLoopMode];
		displayLink.frameInterval=2; // slow the refresh to improve touch performance?
		
		self.multipleTouchEnabled = YES;
		
		// set up control view
		//frame l_frame = CGRectMake(566, 860, 20, 162);
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
	[m_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void)dealloc {
	[EAGLContext setCurrentContext:nil];
	[m_context release];
	[m_renderingEngine release];
    [super dealloc];
}


@end
