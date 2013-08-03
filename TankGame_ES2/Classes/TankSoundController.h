//
//  TankSoundController.h
//  ES2_tankgame
//
//  Created by BjornC on 7/12/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface TankSoundController : NSObject <AVAudioSessionDelegate,
                                            AVAudioPlayerDelegate>

@property AVAudioPlayer *tankEngine;

-(void) tankSoundSetup;

-(void) playerTankFires;
-(void) enemyTankFires;

-(void) tankHit;

-(void) startEngine;
-(void) setEngineVolume:(float)vol;
-(void) setEngineSpeed:(float)r;

@end
