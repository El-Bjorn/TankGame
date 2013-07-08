//
//  ControllerView.m
//  ES1_tankgame
//
//  Created by Bjorn Chambless on 7/29/11.
//  Copyright 2011 Built Light. All rights reserved.
//

#import "ControllerView.h"


@implementation ControllerView

-(id) initWithFrame:(CGRect)frame rendEngine:(RenderingEngine2*)r andID:(controlID)i {
	self = [super initWithFrame:frame];
	if (self) {
		rendEng=r;
		myID=i;
	}
	return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint t = [[touches anyObject] locationInView:self];
	float normedY = (t.y-80)/81;
	normedY *= -1;
	switch (myID) {
		case leftContoller:
			fprintf(stderr, "normed left controller pos= %f\n",normedY);
			[rendEng setLeftSlider:normedY];
			break;
		case rightController:
			fprintf(stderr, "normed right controller pos = %f\n",normedY);
			[rendEng setRightSlider:normedY];
			break;
	}
	//fprintf(stderr, "controller view got touched\n");
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint t = [[touches anyObject] locationInView:self];
	if (t.y < 0) {
		//fprintf(stderr, "Trying to move slider too far\n");
		return;
	}
	float normedY = (t.y-80)/81;
	normedY *= -1;
	switch (myID) {
		case leftContoller:
			//fprintf(stderr, "normed left controller pos= %f\n",normedY);
			[rendEng setLeftSlider:normedY];
			break;
		case rightController:
			//fprintf(stderr, "normed right controller pos = %f\n",normedY);
			[rendEng setRightSlider:normedY];
			break;
	}
	//fprintf(stderr, "controllerView got moved\n");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    //[super dealloc];
}


@end
