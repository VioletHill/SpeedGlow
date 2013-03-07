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
#define sunTotalTime 1.0
#define turnOneTotalTime 0.7
#define turnTwoTotalTime 1.4
#define trafficeLightTime 2.1

typedef enum
{
    kYLFC,
    kBYYM,
    kMYTJ,
    kXBTW
}GameScene;

typedef enum
{
    kBARRIER,
    kTURN,
    kSUN,
    kTRAFFIC_LIGHT,
}WhichObstacle;

@interface Obstacle : NSObject

@property (nonatomic,readwrite) BOOL barrierL;
@property (nonatomic,readwrite) BOOL barrierR;
@property (nonatomic,readwrite) GameScene gameScene;

+(Obstacle*) sharedObstacle;

-(void) startRotationObstacle;

-(void) startBarrierL;
-(void) startBarrierR;

-(void) startSunL;
-(void) startSunR;

-(void) startTurnTwoLeft;
-(void) startTurnTwoRight;

-(double) getRotationRate;
-(double) getRotationRateByAcceleor;


@end
