//
//  ControllerView.h
//  ES1_tankgame
//
//  Created by Bjorn Chambless on 7/29/11.
//  Copyright 2011 Built Light. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"

typedef enum {leftContoller,rightController} controlID;


@interface ControllerView : UIView {
	RenderingEngine2 *rendEng;
	controlID myID;
}

-(id) initWithFrame:(CGRect)frame rendEngine:(RenderingEngine2*)r andID:(controlID)i;

@end
