//
//  Car.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-3-4.
//  Copyright (c) 2013年 VioletHill. All rights reserved.
//

#import "Car.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"


#define stopNormlSignTime 2.0
#define stopTurnFailTime 2.0
#define stopRedLight 4.0

@implementation Car
{
    ALint carSpeedSoundId;
}

static Car* car;
@synthesize lane=_lane;
@synthesize speed=_speed;
@synthesize sun=_sun;
@synthesize nowDistance=_nowDistance;
@synthesize isNeedTurnLeft=_isNeedTurnLeft;
@synthesize isNeedTurnRight=_isNeedTurnRight;
@synthesize isNeedStop=_isNeedStop;
@synthesize isChangeLand=_isChangeLand;
@synthesize carEffect=_carEffect;
@synthesize finishGameTime=_finishGameTime;
@synthesize isEatSun=_isEatSun;
@synthesize isFinishSun=_isFinishSun;

+(Car*) sharedCar
{
    if (car==nil)
    {
        car=[[Car alloc] init];
    }
    return car;
}

//撞到货箱
-(void) collisionBox
{
    [self carStopWithTime:stopNormlSignTime];
}

//撞到路牌
-(void) collisionSign
{
    [self carStopWithTime:stopNormlSignTime];
}

//撞到猫
-(void) collisionCat
{
    [self carStopWithTime:stopNormlSignTime];
}

//吃到太阳
-(void) eatSun
{
    self.sun++;
}

//转弯失败
-(void) turnFail
{
    [self carStopWithTime:stopTurnFailTime];
}

//闯红灯
-(void) breakRedLight
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"重启间隙4s.mp3"];
    [self carStopWithTime:stopRedLight];
}

-(void) changeDone:(id)pSender
{
    self.isChangeLand=false;
}


-(void) changeLandDone:(id)pSender
{
    self.isChangeLand=false;
}

-(void) turnLeft
{
    if (self.isNeedTurnLeft) self.isNeedTurnLeft=false;
    
}

-(void) turnRight
{
    if (self.isNeedTurnRight) self.isNeedTurnRight=false;
}

-(void) changeLandFromR2L
{
    if (self.isChangeLand) return ;
    if (self.isNeedStop) return ;
    if (self.lane==kLEFT_LAND) return ;
    
    self.isChangeLand=true;
    self.lane=kLEFT_LAND;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"变道R2L.mp3"];
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:1], [CCCallFunc actionWithTarget:self selector:@selector(changeLandDone:)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) changeLandFromL2R
{
    if (self.isChangeLand) return ;
    if (self.isNeedStop) return ;
    if (self.lane==kRIGHT_LAND) return ;
    
    self.isChangeLand=true;
    self.lane=kRIGHT_LAND;

    [[SimpleAudioEngine sharedEngine] playEffect:@"变道L2R.mp3"];
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:1], [CCCallFunc actionWithTarget:self selector:@selector(changeLandDone:)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
    
}

-(void) start:(TrafficLand) startLand
{
    self.sun=0;
    self.lane=startLand;
    self.isNeedStop=false;
    self.isChangeLand=false;
    [self normalSpeedStart];
}


-(void) speedUpStart
{
    if (self.speed==accelerateSpeed) return ;
    self.speed=accelerateSpeed;
    [[SimpleAudioEngine sharedEngine] stopEffect:carSpeedSoundId];
    carSpeedSoundId=[[SimpleAudioEngine sharedEngine] playEffect:@"加速音效.mp3" loop:true];
}

-(void) normalSpeedStart
{
    if (self.speed==normalSpeed) return ;
    self.speed=normalSpeed;
    [[SimpleAudioEngine sharedEngine] stopEffect:carSpeedSoundId];
    carSpeedSoundId=[[SimpleAudioEngine sharedEngine] playEffect:@"常速行驶音效.mp3" loop:true];
}

-(void) restartCar:(id)pSender
{
    carSpeedSoundId=[[SimpleAudioEngine sharedEngine] playEffect:@"常速行驶音效.mp3" loop:true];
   // [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    self.speed=normalSpeed;
    self.isNeedStop=false;
}

-(void) carStopWithTime:(float)time
{
    self.isNeedStop=true;
    self.speed=noSpeed;
    [[SimpleAudioEngine sharedEngine] stopEffect:carSpeedSoundId];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:time], [CCCallFunc actionWithTarget:self selector:@selector(restartCar:) ],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}


-(id) init
{
    return self;
}

@end
