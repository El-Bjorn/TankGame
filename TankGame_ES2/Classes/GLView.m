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
		
		m_renderingEngine = [[RenderingEngine2 alloc] initWithSize:frame.size andViewLayer:self.layer];
        //[m_renderingEngine setOurView:self];
		
		
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
        ControllerView *fButton=[[ControllerView alloc] initWithFrame:CGRectMake(75,915, 79, 79)
                                                              rendEngine:m_renderingEngine
                                                                   andID:fireButton];
        [self addSubview:fButton];
        
        // playing around with CALayers to see how bad it f's performance
        //CALayer *tstLayer = self.layer;
        //xLayer = [CALayer layer];
        //tstLayer.frame = CGRectMake(10, 10, 10, 10);
        //xLayer.bounds = CGRectMake(0, 0, 100, 100);
        //xLayer.position = CGPointMake(100, 100);
        //tstLayer.backgroundColor = [[UIColor greenColor] CGColor];
        //xLayer.contents = (id)[UIImage imageNamed:@"LLVM-Logo.png"].CGImage;
        //xLayer.delegate = self;
        //[self.layer addSublayer:xLayer];
	}
	
    return self;
}

//-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
//}


-(void) drawView:(CADisplayLink *)displayLink {
	if (displayLink != nil) {
		float elapsedSeconds = displayLink.timestamp - m_timestamp;
		m_timestamp = displayLink.timestamp;
		[m_renderingEngine updateAnimationWithTimestep:elapsedSeconds];
        //fprintf(stderr, "elapsed= %f\n",m_timestamp);
        /*if ((rand() % 100)==10) {
            fprintf(stderr,"bla!\n");// Change the position explicitly.
            [UIView animateWithDuration:5.0 animations:^{
                CABasicAnimation *explode = [CABasicAnimation animationWithKeyPath:@"contensScale"];
                explode.fromValue = (id)[NSNumber numberWithFloat: 1.0];
                explode.toValue = (id)[NSNumber numberWithFloat:2.0];
                //[NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(10, 10)];
                explode.duration = 5.0;
                [xLayer addAnimation:explode forKey:@"AnimateFrame"]; }];
            /*CABasicAnimation* theAnim = [CABasicAnimation animationWithKeyPath:@"position"];
            theAnim.fromValue = [NSValue valueWithCGPoint:xLayer.position];
            CGPoint tmp = xLayer.position;
            tmp.x += 100;
            tmp.y += 100;
            theAnim.toValue = [NSValue valueWithCGPoint:tmp];
            theAnim.duration = 3.0;
                [xLayer addAnimation:theAnim forKey:@"AnimateFrame"]; }];
            //xLayer.position = tmp;
            //[xLayer setNeedsDisplay];
        } */
	}
	[m_renderingEngine render];
	[m_context presentRenderbuffer:GL_RENDERBUFFER];
}


- (void)dealloc {
	[EAGLContext setCurrentContext:nil];
	//[m_context release];
	//[m_renderingEngine release];
    //[super dealloc];
}


@end
