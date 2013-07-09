//
//  ArenaObject.m
//  ES2_tankgame
//
//  Created by BjornC on 7/9/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import "ArenaObject.h"

@implementation ArenaObject

-(void) render {
    NSLog(@"Dammit, I told you monkeys to override this!!!");
    assert(0);
}


// override this so we can identify objects based on
//      cpShape, which is used for collisions
-(BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[ArenaObject class]]) {
        fprintf(stderr,"comparing an ArenaObject to something weird..\n");
        return NO;
    }
    if (self.shape == [(ArenaObject*)object shape]) {
        return YES;
    }
    return NO;
    
}

@end
