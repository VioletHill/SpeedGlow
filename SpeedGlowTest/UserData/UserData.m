//
//  UserData.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-3-4.
//  Copyright (c) 2013年 VioletHill. All rights reserved.
//

#import "UserData.h"

#define sceneNum 4
#define levelNum 3
#define totRank 3

@implementation UserData
{
    int sun[sceneNum][levelNum];
    int bestTime[sceneNum][levelNum][totRank];
    bool isUnlock[sceneNum];
}
static UserData* userData;

+(UserData*) sharedUserData
{
    if (userData==nil)
    {
        userData=[[UserData alloc] init];
    }
    return userData;
}

-(id) init
{
    if (self=[super init])
    {
        
    }
    return self;
}

-(void) getDate
{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    
    for (int i=0; i<sceneNum; i++)
    {
        for (int j=0; j<levelNum; j++)
        {
            NSNumber* num=[defaults objectForKey:[@"sun" stringByAppendingFormat:@"%d%d",i,j]];
            sun[i][j]=num.intValue;
        }
    }
    
    for (int i=0; i<sceneNum; i++)
    {
        for (int j=0; j<levelNum; j++)
        {
            for (int k=0; k<totRank; k++)
            {
                NSNumber* num=[defaults objectForKey:[@"time" stringByAppendingFormat:@"%d%d%d",i,j,k]];
                bestTime[i][j][k]=num.intValue;
            }
        }
    }
    
    for (int i=0; i<sceneNum; i++)
    {
        NSNumber* num=[defaults objectForKey:[@"unlock" stringByAppendingFormat:@"%d",i]];
        isUnlock[i]=num.boolValue;
    }
    //强制使得场景一解锁
    if (!isUnlock[0]) isUnlock[0]=true;
}

-(void) saveDate
{
    if (!isUnlock[0]) isUnlock[0]=true;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    for (int i=0; i<sceneNum; i++)
    {
        for (int j=0; j<levelNum; j++)
        {
            [defaults setObject:[NSNumber numberWithInt:sun[i][j]] forKey:[@"sun" stringByAppendingFormat:@"%d%d",i,j]];
        }
    }
    for (int i=0; i<sceneNum; i++)
    {
        for (int j=0; j<levelNum; j++)
        {
            for (int k=0; k<totRank; k++)
            {
                [defaults setObject:[NSNumber numberWithInt:bestTime[i][j][k]] forKey:[@"time" stringByAppendingFormat:@"%d%d%d",i,j,k]];
            }
        }
    }
    
    for (int i=0; i<sceneNum; i++)
    {
        [defaults setObject:[NSNumber numberWithBool:isUnlock[i]] forKey:[@"unlock" stringByAppendingFormat:@"%d",i]];
    }
    [defaults synchronize];
}

-(void) reflushTime:(int)time atScene:(GameScene)scene andLevel:(GameLevel)level
{
    [self getDate];
    if (time<=bestTime[scene][level][totRank-1])
    {
        for (int i=0; i<totRank; i++)
        {
            if (time<=bestTime[scene][level][totRank-1])
            {
                for (int j=totRank-1; j>i; j--)
                {
                    bestTime[scene][level][j]=bestTime[scene][level][j-1];
                }
                bestTime[scene][level][i]=time;
                break;
            }
        }
        [self saveDate];
    }
    else return;
    
}

-(void) reflushLockAtScene:(GameScene)scene withLock:(BOOL)lock
{
    isUnlock[scene]=lock;
    [self saveDate];
}

-(BOOL) getIsUnlockAtScene:(GameScene)scene
{
    [self getDate];
    return isUnlock[scene];
}
-(void) reflushSunAtScene:(GameScene)scene andLevel:(GameLevel)level withSunNumber:(int)sunNumber
{
    [self getDate];
    sun[scene][level]+=sunNumber;
    switch (scene)
    {
        case kYLFC:
            if (sun[scene][kEASY]>YlfcEasySunNum) sun[scene][kEASY]=YlfcEasySunNum;
            if (sun[scene][kMIDDLE]>YlfcMiddleSunNum) sun[scene][kMIDDLE]=YlfcMiddleSunNum;
            if (sun[scene][kHARD]>YlfcHardSunNum) sun[scene][kHARD]=YlfcHardSunNum;
            break;
        case kBYYM:
            if (sun[scene][kEASY]>ByymEasySunNum) sun[scene][kEASY]=ByymEasySunNum;
            if (sun[scene][kMIDDLE]>ByymMiddleSunNum) sun[scene][kMIDDLE]=ByymMiddleSunNum;
            if (sun[scene][kHARD]>ByymHardSunNum) sun[scene][kHARD]=ByymHardSunNum;
            break;
        case kMWTJ:
            if (sun[scene][kEASY]>MwtjEasySunNum) sun[scene][kEASY]=MwtjEasySunNum;
            if (sun[scene][kMIDDLE]>MwtjMiddleSunNum) sun[scene][kMIDDLE]=MwtjMiddleSunNum;
            if (sun[scene][kHARD]>MwtjHardSunNum) sun[scene][kHARD]=MwtjHardSunNum;
            break;
        case kXBTW:
            if (sun[scene][kEASY]>XbtwEasySunNum) sun[scene][kEASY]=XbtwEasySunNum;
            if (sun[scene][kMIDDLE]>XbtwMiddleSunNum) sun[scene][kMIDDLE]=XbtwMiddleSunNum;
            if (sun[scene][kMIDDLE]>XbtwHardSunNum) sun[scene][kHARD]=XbtwHardSunNum;
            break;
        default:
            break;
    }
    [self saveDate];
}

-(int) getSunByScene:(GameScene)scene
{
    [self getDate];
    return sun[scene][kEASY]+sun[scene][kMIDDLE]+sun[scene][kHARD];
}

-(int) getSunByScene:(GameScene)scene andLevel:(GameLevel)level
{
    [self getDate];
    return sun[scene][level];
}

-(int*) getTimeByScene:(GameScene)scene andLevel:(GameLevel)level
{
    [self getDate];
    return bestTime[scene][level];
}

@end
