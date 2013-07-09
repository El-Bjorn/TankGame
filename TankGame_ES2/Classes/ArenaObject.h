//
//  ArenaObject.h
//  tankgame
//
//  Created by BjornC on 7/9/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

// This an abstract parent class, try to use it
//    without sub-classing and it will EXPLODE!

#import <Foundation/Foundation.h>
#import "chipmunk.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <math.h>
#import <UIKit/UIKit.h>
#import "modelTypes.h"


@interface ArenaObject : NSObject

// Chipmunk Physics attributes
@property cpSpace *space;
@property cpBody *body;
@property cpShape *shape;

// OpenGL stuff
@property GLuint shaderProgHandle;

-(BOOL) isEqual:(id)object;

// you must override this guy
-(void) render;

@end
