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
    bool isUnlock[sceneNum][levelNum];
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
        for (int j=0; j<levelNum; j++)
        {
            NSNumber* num=[defaults objectForKey:[@"unlock" stringByAppendingFormat:@"%d%d",i,j]];
            isUnlock[i][j]=num.boolValue;
        }
    }
    //强制使得场景一解锁
    if (!isUnlock[0][0]) isUnlock[0][0]=true;
}

-(void) saveDate
{
    if (!isUnlock[0]) isUnlock[0][0]=true;
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
        for (int j=0; j<levelNum; j++)
        {
            [defaults setObject:[NSNumber numberWithBool:isUnlock[i][j]] forKey:[@"unlock" stringByAppendingFormat:@"%d%d",i,j]];
        }
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


-(BOOL) getIsUnlockAtScene:(GameScene)scene
{
    [self getDate];
    switch (scene)
    {
        case kYLFC:
            return sun[scene][kEASY]+sun[scene][kMIDIUM]+sun[scene][kHARD]>=YlfcMaxSunNum;
            break;
        case kBYYM:
            return sun[scene][kEASY]+sun[scene][kMIDIUM]+sun[scene][kHARD]>=ByymMaxSunNum;
            break;
        case kMWTJ:
            return sun[scene][kEASY]+sun[scene][kMIDIUM]+sun[scene][kHARD]>=MwtjMaxSunNum;
            break;
        case kXBTW:
            return sun[scene][kEASY]+sun[scene][kMIDIUM]+sun[scene][kHARD]>=XbtwMaxSunNum;
            break;
        default:
            return false;
    }
   
}

-(BOOL) getIsUnlockAtScene:(GameScene)scene andLevel:(GameLevel)level
{
    [self getDate];
    return isUnlock[scene][level];
}

-(void) reflushSunAtScene:(GameScene)scene andLevel:(GameLevel)level withSunNumber:(int)sunNumber
{
    if (sunNumber==0) return;
    [self getDate];
    sun[scene][level]+=sunNumber;
    switch (scene)
    {
        case kYLFC:
            if (sun[scene][kEASY]>=YlfcEasySunNum)      sun[scene][kEASY]=YlfcEasySunNum;
            if (sun[scene][kMIDIUM]>=YlfcMidiumSunNum)  sun[scene][kMIDIUM]=YlfcMidiumSunNum;
            if (sun[scene][kHARD]>=YlfcHardSunNum)      sun[scene][kHARD]=YlfcHardSunNum;
            break;
        case kBYYM:
            if (sun[scene][kEASY]>=ByymEasySunNum)      sun[scene][kEASY]=ByymEasySunNum;
            if (sun[scene][kMIDIUM]>=ByymMidiumSunNum)  sun[scene][kMIDIUM]=ByymMidiumSunNum;
            if (sun[scene][kHARD]>=ByymHardSunNum)      sun[scene][kHARD]=ByymHardSunNum;
            break;
        case kMWTJ:
            if (sun[scene][kEASY]>=MwtjEasySunNum)      sun[scene][kEASY]=MwtjEasySunNum;
            if (sun[scene][kMIDIUM]>=MwtjMidiumSunNum)  sun[scene][kMIDIUM]=MwtjMidiumSunNum;
            if (sun[scene][kHARD]>=MwtjHardSunNum)      sun[scene][kHARD]=MwtjHardSunNum;
            break;
        case kXBTW:
            if (sun[scene][kEASY]>=XbtwEasySunNum)      sun[scene][kEASY]=XbtwEasySunNum;
            if (sun[scene][kMIDIUM]>=XbtwMidiumSunNum)  sun[scene][kMIDIUM]=XbtwMidiumSunNum;
            if (sun[scene][kHARD]>=XbtwHardSunNum)      sun[scene][kHARD]=XbtwHardSunNum;
            break;
        default:
            break;
    }
    [self saveDate];
}

-(int) getSunByScene:(GameScene)scene
{
    [self getDate];
    return sun[scene][kEASY]+sun[scene][kMIDIUM]+sun[scene][kHARD];
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

-(BOOL) isNeedBg
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSNumber* num=[defaults objectForKey:@"IsNeedBg"];
    if (num!=nil)   return num.boolValue;
    else return true;
}

-(BOOL) isNeedEffect
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSNumber* num=[defaults objectForKey:@"IsNeedEffect"];
    if (num!=nil)   return num.boolValue;
    else return true;
}

-(void) setIsNeedBg:(BOOL)isNeedBg
{
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isNeedBg] forKey:@"IsNeedBg"];
}

-(void) setIsNeedEffect:(BOOL)isNeedEffect
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isNeedEffect] forKey:@"IsNeedEffect"];
}

@end
