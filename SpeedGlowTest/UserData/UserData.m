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
#define totRank 5

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
    if (time<=bestTime[scene][level][totRank-1] || bestTime[scene][level][totRank-1]==0)
    {
        for (int i=0; i<totRank; i++)
        {
            if (time<=bestTime[scene][level][i] || bestTime[scene][level][i]==0)
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
    return isUnlock[scene][kEASY];
}

-(BOOL) getIsUnlockAtScene:(GameScene)scene andLevel:(GameLevel)level
{
    [self getDate];
    return isUnlock[scene][level];
}

-(void) unlockAtScene:(GameScene)scene andLevel:(GameLevel)level
{
    if (isUnlock[scene][level]) return;
    isUnlock[scene][level]=true;
    [self saveDate];
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
            if (sun[scene][kMEDIUM]>=YlfcMediumSunNum)  sun[scene][kMEDIUM]=YlfcMediumSunNum;
            if (sun[scene][kHARD]>=YlfcHardSunNum)      sun[scene][kHARD]=YlfcHardSunNum;
            if(sun[scene][kEASY]+sun[scene][kMEDIUM]+sun[scene][kHARD]>=YlfcMaxSunNum)
            {
                isUnlock[kBYYM][kEASY]=true;
            }
            break;
        case kBYYM:
            if (sun[scene][kEASY]>=ByymEasySunNum)      sun[scene][kEASY]=ByymEasySunNum;
            if (sun[scene][kMEDIUM]>=ByymMediumSunNum)  sun[scene][kMEDIUM]=ByymMediumSunNum;
            if (sun[scene][kHARD]>=ByymHardSunNum)      sun[scene][kHARD]=ByymHardSunNum;
            if(sun[scene][kEASY]+sun[scene][kMEDIUM]+sun[scene][kHARD]>=ByymMaxSunNum)
            {
                isUnlock[kMWTJ][kEASY]=true;
            }
            break;
        case kMWTJ:
            if (sun[scene][kEASY]>=MwtjEasySunNum)      sun[scene][kEASY]=MwtjEasySunNum;
            if (sun[scene][kMEDIUM]>=MwtjMediumSunNum)  sun[scene][kMEDIUM]=MwtjMediumSunNum;
            if (sun[scene][kHARD]>=MwtjHardSunNum)      sun[scene][kHARD]=MwtjHardSunNum;
            if(sun[scene][kEASY]+sun[scene][kMEDIUM]+sun[scene][kHARD]>=MwtjMaxSunNum)
            {
                isUnlock[kXBTW][kEASY]=true;
            }
            break;
        case kXBTW:
            if (sun[scene][kEASY]>=XbtwEasySunNum)      sun[scene][kEASY]=XbtwEasySunNum;
            if (sun[scene][kMEDIUM]>=XbtwMediumSunNum)  sun[scene][kMEDIUM]=XbtwMediumSunNum;
            if (sun[scene][kHARD]>=XbtwHardSunNum)      sun[scene][kHARD]=XbtwHardSunNum;
            break;
        default:
            break;
    }

    [self saveDate];
}

-(int) getSunAtScene:(GameScene)scene
{
    [self getDate];
    return sun[scene][kEASY]+sun[scene][kMEDIUM]+sun[scene][kHARD];
}

-(int) getSunAtScene:(GameScene)scene andLevel:(GameLevel)level
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

-(int) getMaxSunAtScene:(GameScene)scene
{
    switch (scene)
    {
        case kYLFC:
            return YlfcMaxSunNum;
        case kBYYM:
            return ByymMaxSunNum;
        case kMWTJ:
            return MwtjMaxSunNum;
        case kXBTW:
            return XbtwEasySunNum;
        default:
            break;
    }
    return 0;
}

-(int) getMaxSunAtScene:(GameScene)scene andLevel:(GameLevel)level
{
    switch (scene)
    {
        case kYLFC:
            if (level==kEASY)   return YlfcEasySunNum;
            if (level==kMEDIUM) return YlfcMediumSunNum;
            if (level==kHARD)   return YlfcHardSunNum;
            break;
        case kBYYM:
            if (level==kEASY)   return ByymEasySunNum;
            if (level==kMEDIUM) return ByymMediumSunNum;
            if (level==kHARD)   return ByymHardSunNum;
            break;
        case kMWTJ:
            if (level==kEASY)   return MwtjEasySunNum;
            if (level==kMEDIUM) return MwtjMediumSunNum;
            if (level==kHARD)   return MwtjHardSunNum;
            break;
        case kXBTW:
            if (level==kEASY)   return XbtwEasySunNum;
            if (level==kMEDIUM) return XbtwMediumSunNum;
            if (level==kHARD)   return XbtwHardSunNum;
            break;
        default:
            break;
    }
    return 0;
}

-(NSMutableArray*) getRankAtScene:(GameScene)scene andLevel:(GameLevel)level
{
    NSMutableArray* rankArray=[NSMutableArray arrayWithCapacity:totRank];
    [self getDate];
    for (int i=0; i<totRank; i++)
    {
        if (bestTime[scene][level][i]!=0)
        {
            [rankArray addObject:[NSNumber numberWithInt:bestTime[scene][level][i] ]];
        }
    }
    return rankArray;
}

@end
