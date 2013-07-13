//
//  TankSoundController.m
//  ES2_tankgame
//
//  Created by BjornC on 7/12/13.
//  Copyright (c) 2013 Built Light. All rights reserved.
//

#import "TankSoundController.h"

static SystemSoundID tankFireSoundID;

@implementation TankSoundController

-(id) init {
    self = [super init];
    if (self) {
        [self tankSoundSetup];
    }
    return self;
}

-(void) tankSoundSetup {
    // audio services
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tank-fire" ofType:@"caf"];
    NSURL *afURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)afURL,&tankFireSoundID);
    
    // uAVAudio
    self.tankEngine.enableRate = YES;
    NSError *audio_session_err = nil;
    BOOL retVal = YES;
    retVal = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                                    error:&audio_session_err ];
    [[AVAudioSession sharedInstance] setDelegate:self];
    retVal = [[AVAudioSession sharedInstance] setActive:YES error:&audio_session_err];
    NSURL *engineURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tank-engine" ofType:@"caf"]];
    self.tankEngine = [[AVAudioPlayer alloc] initWithContentsOfURL:engineURL error:&audio_session_err];
    self.tankEngine.delegate = self;
    self.tankEngine.numberOfLoops = -1;
}

-(void) playerTankFires {
    AudioServicesPlaySystemSound(tankFireSoundID);
}

-(void) enemyTankFires {
    AudioServicesPlaySystemSound(tankFireSoundID);
}

-(void) startEngine {
    self.tankEngine.volume = 0.2;
    [self.tankEngine play];
    
}

-(void) setEngineVolume:(float)vol {
    if (vol < 0.2) {
        vol = 0.2;
    } else if (vol > 1.0){
        vol = 1.0;
    }
    //fprintf(stderr,"engine vol= %.2f\n",vol);
    self.tankEngine.volume = vol;
    
}

-(void) setEngineSpeed:(float)r {
    if (r<0.5) {
        r = 0.5;
    } else if (r>2.0){
        r = 2.0;
    }
    //fprintf(stderr,"engine speed= %.2f\n", r);
    self.tankEngine.rate = r;
    
}

-(void) dealloc {
    AudioServicesDisposeSystemSoundID(tankFireSoundID);
}

@end
