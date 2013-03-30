//
//  ChooseLevel.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-12.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "ChooseLevelScrollLayer.h"
#import "Setting.h"
#import "UserData.h"
#import "Load.h"


@implementation ChooseLevelScrollLayer
{
    ALuint nowEffect;
    CCSprite* lock;
    CCAction* playEffectAction;
    BOOL isLock;
}


-(void) playLeftRightEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"左右滑屏切换难度选择.mp3"];
    }
}

-(void) playReturnAndHelpEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"左上角返回主菜单右上角帮助文档.mp3"];
    }
    
}

//时间排名 
-(void) play1st:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"排名第一"];
    }
}


//太阳
-(void) playAllSunEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"太阳总数.mp3"];
    }
    
}

-(void) playHaveSunEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"已获得太阳数量.mp3"];
    }
}

-(void) playLockLevel:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"该难度未解锁.mp3"];
    }
}

-(void) playMinuteTimeEffect:(id)pSender data:(void*)minute
{
    int min=(int)minute;
    switch (min)
    {
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"1分.mp3"];
            break;
        case 2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"2分.mp3"];
            break;
        case 3:
            [[SimpleAudioEngine sharedEngine] playEffect:@"3分.mp3"];
        default:
            break;
    }
}

-(void) playSecondEffect:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"秒.mp3"];
}

-(CCFiniteTimeAction*) playSecondTimeEffect:(int)second
{
    return [CCSequence actions:[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)second],[CCDelayTime actionWithDuration:1.5],[CCDelayTime actionWithDuration:0.3],nil];
}

-(void) playBestRecord:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"最佳纪录.mp3"];
}

-(CCAction*) playTimeEffect:(int)time
{
    if (time==0) return [CCDelayTime actionWithDuration:0.1];
    int minute=time/60;
    int second=time%60;
    CCAction* playAction=[CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(playBestRecord:)],
        [CCDelayTime actionWithDuration:1.3],[CCCallFuncND actionWithTarget:self selector:@selector(playMinuteTimeEffect:data:) data:(void*)minute],
        [CCDelayTime actionWithDuration:0.5],[self playSecondTimeEffect:second],nil];
    return playAction;
}

-(void) playNum:(id)pSender data:(void*)num
{
    int playNum=(int) num;
    if (playNum>=10)
    {
        if (playNum%10!=0)
        {
            CCAction* playAction=[CCSequence actions:
                                  [CCCallFuncND actionWithTarget:self selector:@selector(playSingleNum:data:) data:(void*) (playNum/10*10)],
                                  [CCDelayTime actionWithDuration:0.7],[CCCallFuncND actionWithTarget:self selector:@selector(playSingleNum:data:) data:(void*)(playNum%10)],nil];
            [self runAction:playAction];
        }
        else    //整十
        {
            CCAction* playAction=[CCSequence actions:
                                  [CCDelayTime actionWithDuration:0.5],[CCCallFuncND actionWithTarget:self selector:@selector(playSingleNum:data:) data:(void*) (playNum/10*10)],nil];
            [self runAction:playAction];
        }
    }
    else    //10以内
    {
        CCAction*playAction=[CCSequence actions:
                             [CCDelayTime actionWithDuration:0.5],[CCCallFuncND actionWithTarget:self selector:@selector(playSingleNum:data:) data:(void*)playNum],nil];
        [self runAction:playAction];
    }
}

-(void) playSingleNum:(id)pSender data:(void*)num
{
    int playNum=(int) num;
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%d.mp3",playNum]];
    }
}

-(void) playLevelEffect:(id)pSender
{
    switch ([Obstacle sharedObstacle].gameLevel)
    {
        case kEASY:
            if ([Setting sharedSetting].isNeedEffect)
            {
                nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"一难度简单.mp3"];
            }
            break;
        case kMEDIUM:
            if ([Setting sharedSetting].isNeedEffect)
            {
                nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"二难度中等.mp3"];
            }
            break;
        case kHARD:
            if ([Setting sharedSetting].isNeedEffect)
            {
                nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"三难度困难.mp3"];
            }
        default:
            break;
    }
}

-(void) lockLevel
{
    isLock=true;
    lock=[CCSprite spriteWithFile:@"Lock.png"];
    lock.position=ccp(layerSize.width/2,layerSize.height/2);
    [self addChild:lock];
    if ([Setting sharedSetting].isNeedEffect)
    {
        playEffectAction=[CCSequence actions:
                          [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playLevelEffect:)],
                          [CCDelayTime actionWithDuration:2],[CCCallFunc actionWithTarget:self selector:@selector(playLockLevel:)],
                          [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playLeftRightEffect:)],
                          [CCDelayTime actionWithDuration:2],[CCCallFunc actionWithTarget:self selector:@selector(playReturnAndHelpEffect:)],nil];
        [self runAction:playEffectAction];
    }
    
}

-(CCAction*) playSunAction
{
    CCAction* play;
    int sun=[[UserData sharedUserData] getSunAtScene:[Obstacle sharedObstacle].gameScene andLevel:[Obstacle sharedObstacle].gameLevel];

    play=[CCSequence actions:
          [CCCallFunc actionWithTarget:self selector:@selector(playAllSunEffect:)],
          [CCDelayTime actionWithDuration:1.5],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)[[UserData sharedUserData] getMaxSunAtScene:[Obstacle sharedObstacle].gameScene andLevel:[Obstacle sharedObstacle].gameLevel]],
          [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playHaveSunEffect:)],
          [CCDelayTime actionWithDuration:2],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)sun],
          [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playLeftRightEffect:)],
          [CCDelayTime actionWithDuration:2],nil];
    return play;
   
}
-(void) unlockLevel
{
    isLock=false;
    if ([Setting sharedSetting].isNeedEffect)
    {
        int time=[[UserData sharedUserData] getBestTimeByScene:[Obstacle sharedObstacle].gameScene andLevel:[Obstacle sharedObstacle].gameLevel];
        playEffectAction=[CCSequence actions:
            [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playLevelEffect:)],
            [CCDelayTime actionWithDuration:2], [self playTimeEffect:time] ,[self playSunAction],
            [CCCallFunc actionWithTarget:self selector:@selector(playReturnAndHelpEffect:)],nil];
        [self runAction:playEffectAction];

    }
}

-(void) startGame
{
    if (isLock) return;
    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音二双击.mp3"];
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[Load scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) onEnterLayer
{
    if ([[UserData sharedUserData] getIsUnlockAtScene:[Obstacle sharedObstacle].gameScene andLevel:[Obstacle sharedObstacle].gameLevel])
    {
        [self unlockLevel];
        isLock=false;
    }
    else
    {
        [self lockLevel];
        isLock=true;
    }
}

-(void) onExitLayer
{
    [self stopAllActions];
    if (lock!=nil)  [self removeChild:lock cleanup:true];
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
}

-(void) onClick
{
    
}

@end
