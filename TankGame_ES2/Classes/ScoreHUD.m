//
//  ScoreDisp.m
//  ES2_tankgame
//
//  Created by BjornC on 8/2/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import "ScoreHUD.h"

@implementation ScoreHUD

/*+(ScoreHUD*) layerAtPos:(CGPoint)pos onParentLayer:(CALayer*)pLayer {
    
} */

-(id) initAtPos:(CGPoint)pos onParentLayer:(CALayer *)pLayer {
    self = [super init];
    if (self) {
        self.ourLayer = [CATextLayer layer];
        self.score = 0;
        self.parentLayer = pLayer;
        self.bounds = CGRectMake(0, 0, 150, 150);
        self.position = pos;
        //self.foregroundColor = [UIColor whiteColor].CGColor;
        //self.backgroundColor = [UIColor greenColor].CGColor;
        //self.fontSize = 20.0f;
        //self.alignmentMode = kCAAlignmentCenter;
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
