//
//  ScoreDisp.m
//  ES2_tankgame
//
//  Created by BjornC on 8/2/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import "ScoreDisp.h"

@implementation ScoreDisp

-(id) initAtPos:(CGPoint)pos withParentLayer:(CALayer *)pLayer {
    self = [super init];
    if (self) {
        self.score = 0;
        self.parentLayer = pLayer;
        self.bounds = CGRectMake(0, 0, 1000, 1000);
        self.position = pos;
        self.foregroundColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = [UIColor greenColor].CGColor;
        self.fontSize = 20.0f;
        self.alignmentMode = kCAAlignmentCenter;
        [self setString:[NSString stringWithFormat:@"%d",self.score]];
        [pLayer addSublayer:self];
        //[self setNeedsDisplay];
    }
    return self;
}

-(void) incrementScore {
    self.score++;
    [self setString:[NSString stringWithFormat:@"%d",self.score]];
}

@end
