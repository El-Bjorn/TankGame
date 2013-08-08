//
//  GameArenaManager.m
//  ES2_tankgame
//
//  Created by BjornC on 8/6/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import "GameArenaManager.h"


#pragma mark - wallSection utility functions
// we need these guys since you can write-out an NSDictionary
//     to a plist unless the values are XML representable strings
// the format will be:   X1,Y1---X2,Y2    (one dash)

#define WALL_STR_LEN 512

NSString *stringify_wallSection(wallSection w){
    char wall_string[WALL_STR_LEN];
    sprintf(wall_string,"%.2f,%.2f-%.2f,%.2f",w.startPt.x,w.startPt.y,w.endPt.x,w.endPt.y);
    fprintf(stderr,"wall string: %s\n",wall_string);
    return [NSString stringWithUTF8String:wall_string];
    
}

wallSection unstringify_wallSection(NSString *ocwallString){
    wallSection w;
    char *wall_string = (char*)[ocwallString UTF8String];
     
    w.startPt.x = atof(strtok(wall_string, ",-"));
    w.startPt.y = atof(strtok(NULL, ",-"));
    w.endPt.x = atof(strtok(NULL, ",-"));
    w.endPt.y = atof(strtok(NULL, ",-"));
    
    return w;
}

    

@implementation GameArenaManager

// this gives us a simple arena
-(void) tstArenaSetup {
    wallSection top,bottom,right,left;
    wallSection diag;
    CGPoint top_left,top_right,bottom_left,bottom_right;
    top_left = CGPointMake(0, 20);
    top_right = CGPointMake(768, 20);
    bottom_left = CGPointMake(0, 1024);
    bottom_right = CGPointMake(768, 1024);
    
    diag.startPt = CGPointMake(100, 100);
    diag.endPt = CGPointMake(500, 700);
    
    top.startPt = top_left;
    top.endPt = top_right;
    bottom.startPt = bottom_left;
    bottom.endPt = bottom_right;
    left.startPt = top_left;
    left.endPt = bottom_left;
    right.startPt = top_right;
    right.endPt = bottom_right;
    
    // write out basic arena
    NSMutableArray *walls = [NSMutableArray arrayWithArray:nil];
    [walls addObject:stringify_wallSection(top)];
    [walls addObject:stringify_wallSection(bottom)];
    [walls addObject:stringify_wallSection(left)];
    [walls addObject:stringify_wallSection(right)];
    
    
    NSDictionary *arenaDict = @{ @"arenaName": @"BasicBoundaries",
                                 @"arenaNumber": @1,
                                 @"arenaWallSections": walls,
                                 @"players": [NSArray array],
                                 @"enemies": [NSArray array]};
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"BasicBounds.plist"];
    if (![arenaDict writeToFile:path atomically:NO]){
        NSLog(@"DAMMIT");
    }
    NSLog(@"%@",arenaDict);
    [self loadArena:@"BasicBounds"];
    
    /*[self addWall:top];
    [self addWall:bottom];
    [self addWall:left];
    [self addWall:right];
    [self addWall:diag]; */
    NSLog(@"%@",path);
    //exit(0);
}



-(NSDictionary*) loadArena:(NSString *)a {
    NSString *aPlist = [a stringByAppendingString:@".plist"];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:aPlist];
    
    NSMutableDictionary *arena = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *strWalls = arena[@"arenaWallSections"];
    //NSMutableArray *ptWalls = [NSMutableArray arrayWithObject:nil];
    for (NSString *w in strWalls) {
        [self addWall:unstringify_wallSection(w)];
    }

    return nil;
}



-(id) initArena:(NSString *)arena withParentLayer:(CALayer *)pLayer
                                    andArenaSpace:(cpSpace *)space
{
    self = [super init];
    if (self) {
        arenaLayer = [CAShapeLayer layer];
        arenaLayer.frame = pLayer.frame;
        arenaLayer.bounds = pLayer.bounds;
        arenaLayer.position = pLayer.position;
        arenaSpace = space;
        wallPath = CGPathCreateMutable();
        [self tstArenaSetup];
        [arenaLayer setPath:wallPath];
        [pLayer addSublayer:arenaLayer];
        
        arenaSpace = space;
    }
    //[self tstArenaSetup];
    //pLayer.opacity = 1.0;
    //[pLayer addSublayer:arenaLayer];
    return self;
}


// wall points are in screen-space
-(void) addWall:(wallSection)w {
    CGPoint scrPt1 = w.startPt;
    CGPoint scrPt2 = w.endPt;
    CGPoint physPt1 = screenToPhys(scrPt1);
    CGPoint physPt2 = screenToPhys(scrPt2);
    // adding the wall to physics world
    cpShape *newWall = cpSegmentShapeNew(arenaSpace->staticBody, physPt1, physPt2, 1);
    cpShapeSetFriction(newWall, 0);
    cpShapeSetElasticity(newWall, 1);
    cpSpaceAddShape(arenaSpace, newWall);
    
    // save the wall so we can remove it later
    [wallShapes addPointer:newWall];
    
    // add a line to the CAShapeLayer
    [arenaLayer setStrokeColor:[UIColor lightGrayColor].CGColor];
    [arenaLayer setLineWidth:12.0];
    //CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(wallPath, NULL, scrPt1.x, scrPt1.y);
    CGPathAddLineToPoint(wallPath, NULL, scrPt2.x, scrPt2.y);
    //[arenaLayer setPath:path];
}

@end
