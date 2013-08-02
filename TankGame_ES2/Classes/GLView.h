//
//  GLView.h
//  OC_helloArrow_ES1
//
//  Created by Bjorn Chambless on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <QuartzCore/QuartzCore.h>
#import "RenderingEngine2.h"


@interface GLView : UIView {
	EAGLContext *m_context;
	RenderingEngine2 *m_renderingEngine;
	float m_timestamp;
    
    //CALayer *xLayer;
}

-(void) drawView:(CADisplayLink*)displayLink;

@end
