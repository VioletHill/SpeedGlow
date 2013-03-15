//
//  Obstacle.h
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-26.
//  Copyright (c) 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define barrierTotalTime 0.8
#define sunTotalTime 1.6
#define turnOneTotalTime 0.7
#define turnTwoTotalTime 1.4
#define trafficLightTime 3
#define trafficReadyTime 2.1
#define trafficTotalTime 5.1


typedef enum
{
    kYLFC=0,
    kBYYM=1,
    kMWTJ=2,
    kXBTW=3
}GameScene;

typedef enum
{
    kEASY=0,
    kMIDIUM=1,
    kHARD=2
}GameLevel;

typedef enum
{
    kBARRIER=0,
    kTURN=1,
    kSUN=2,
    kTRAFFIC_LIGHT=3,
    kFINAL=4
}WhichObstacle;

@interface Obstacle : NSObject

@property (nonatomic,readwrite) BOOL barrierL;
@property (nonatomic,readwrite) BOOL barrierR;
@property (nonatomic,readwrite) GameScene gameScene;
@property (nonatomic,readwrite) GameLevel gameLevel;

+(Obstacle*) sharedObstacle;

-(void) startBarrierL;
-(void) startBarrierR;

-(void) startSunL;
-(void) startSunR;

-(void) startTurnTwoLeft;
-(void) startTurnTwoRight;

-(void) startTurnOneLeft;
-(void) startTurnOneRight;

-(void) startRed2Green;
-(void) startGreen2Red;

@end
