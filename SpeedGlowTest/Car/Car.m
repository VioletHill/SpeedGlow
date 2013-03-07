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

@implementation Car

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


+(Car*) sharedCar
{
    if (car==nil)
    {
        car=[[Car alloc] init];
    }
    return car;
}

-(void) startSpeed:(id)pSender
{
    self.isNeedStop=false;
    self.speed=normalSpeed;
}

//撞到货箱
-(void) collisionBox
{
    self.isNeedStop=true;
    self.speed=noSpeed;
   // [[SimpleAudioEngine sharedEngine] playEffect:@"重启间隙2s.mp3"];
    [[CCDirector sharedDirector].runningScene runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1], [CCCallFunc actionWithTarget:self selector:@selector(startSpeed:)],nil]];
}

//撞到路牌
-(void) collisionSign
{
    
}

//撞到猫
-(void) collisionCat
{
    
}

//吃到太阳
-(void) eatSun
{
    self.sun++;
}

//转弯失败
-(void) turnFail
{
    
}

-(void) changeDone:(id)pSender
{
    self.isChangeLand=false;
}


-(void) changeLandDone:(id)pSender
{
    self.isChangeLand=false;
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
    self.speed=normalSpeed;
    self.isChangeLand=false;
}

-(id) init
{
    return self;
}

@end
