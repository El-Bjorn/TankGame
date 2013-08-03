//
//  ScoreDisp.h
//  ES2_tankgame
//
//  Created by BjornC on 8/2/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ScoreDisp : CATextLayer

@property CGPoint position;
@property int score;
@property NSString *dispString;
@property CALayer *parentLayer;

-(id) initAtPos:(CGPoint)pos withParentLayer:(CALayer*)pLayer;

-(void) incrementScore;

@end
