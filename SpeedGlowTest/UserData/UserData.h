//
//  UserData.h
//  SpeedGlowTest
//
//  Created by VioletHill on 13-3-4.
//  Copyright (c) 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Obstacle.h"

#define YlfcMaxSunNum 25
#define YlfcEasySunNum 8
#define YlfcMediumSunNum 8
#define YlfcHardSunNum 9

#define ByymMaxSunNum 50
#define ByymEasySunNum 15
#define ByymMediumSunNum 15
#define ByymHardSunNum 20

#define MwtjMaxSunNum 40
#define MwtjEasySunNum 10
#define MwtjMediumSunNum 10
#define MwtjHardSunNum 20


#define XbtwMaxSunNum 40
#define XbtwEasySunNum 10
#define XbtwMediumSunNum 10
#define XbtwHardSunNum 20

@interface UserData : NSObject


+(UserData*) sharedUserData;

-(int)  getBestTimeByScene:(GameScene)scene andLevel:(GameLevel)level;
-(BOOL) getIsUnlockAtScene:(GameScene) scene;
-(BOOL) getIsUnlockAtScene:(GameScene)scene andLevel:(GameLevel)level;

-(void) reflushTime:(int)time atScene:(GameScene)scene andLevel:(GameLevel)level;
-(void) reflushSunAtScene:(GameScene)scene andLevel:(GameLevel)level withSunNumber:(int)sunNumber;

-(void) unlockAtScene:(GameScene)scene andLevel:(GameLevel)level;

-(BOOL) isNeedBg;
-(BOOL) isNeedEffect;

-(void) setIsNeedBg:(BOOL)isNeedBg;
-(void) setIsNeedEffect:(BOOL)isNeedEffect;

//已经吃到的太阳
-(int) getSunAtScene:(GameScene)scene;
-(int) getSunAtScene:(GameScene)scene andLevel:(GameLevel)level;
//总太阳
-(int) getMaxSunAtScene:(GameScene)scene;
-(int) getMaxSunAtScene:(GameScene)scene andLevel:(GameLevel)level;

-(NSMutableArray*) getRankAtScene:(GameScene)scene andLevel:(GameLevel)level;
@end
