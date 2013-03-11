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
#define YlfcMiddleSunNum 8
#define YlfcHardSunNum 9

#define ByymMaxSunNum 50
#define ByymEasySunNum 15
#define ByymMiddleSunNum 15
#define ByymHardSunNum 20

#define MwtjMaxSunNum 40
#define MwtjEasySunNum 10
#define MwtjMiddleSunNum 10
#define MwtjHardSunNum 20


#define XbtwMaxSunNum 40
#define XbtwEasySunNum 10
#define XbtwMiddleSunNum 10
#define XbtwHardSunNum 20

@interface UserData : NSObject


+(UserData*) sharedUserData;

-(int) getSunByScene:(GameScene)scene;
-(int) getSunByScene:(GameScene)scene andLevel:(GameLevel)level;

-(int*) getTimeByScene:(GameScene)scene andLevel:(GameLevel)level;
-(BOOL) getIsUnlockAtScene:(GameScene) scene;

-(void) reflushTime:(int)time atScene:(GameScene)scene andLevel:(GameLevel)level;
-(void) reflushSunAtScene:(GameScene)scene andLevel:(GameLevel)level withSunNumber:(int)sunNumber;
-(void) reflushLockAtScene:(GameScene)scene withLock:(BOOL)lock;


@end
