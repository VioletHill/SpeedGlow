//
//  Car.h
//  SpeedGlowTest
//
//  Created by VioletHill on 13-3-4.
//  Copyright (c) 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>

#define noSpeed 0
#define normalSpeed 22
#define accelerateSpeed 33

typedef enum
{
    kLEFT_LAND,
    kRIGHT_LAND
}TrafficLand;



@interface Car : NSObject

@property (nonatomic,readwrite) TrafficLand lane;
@property (nonatomic,readwrite) int speed;
@property (nonatomic,readwrite) BOOL isEatSun;
@property (nonatomic,readwrite) BOOL isFinishSun;
@property (nonatomic,readwrite) BOOL isNeedStop;
@property (nonatomic,readwrite) int sun;
@property (nonatomic,readwrite) float nowDistance;
@property (nonatomic,readwrite) BOOL isNeedTurnLeft;
@property (nonatomic,readwrite) BOOL isNeedTurnRight;
@property (nonatomic,readwrite) BOOL isChangeLand;
@property (nonatomic,readwrite) int carEffect;
@property (nonatomic,readwrite) int finishGameTime;

+(Car*) sharedCar;

-(void) start:(TrafficLand)land;

-(void) collisionBox;
-(void) collisionSign;
-(void) collisionCat;

-(void) turnFail;
-(void) breakRedLight;

-(void) eatSun;

-(void) changeLandFromL2R;
-(void) changeLandFromR2L;

-(void) turnLeft;
-(void) turnRight;

-(void) speedUpStart;
-(void) normalSpeedStart;
-(void) carStopWithTime:(float)time;

@end
