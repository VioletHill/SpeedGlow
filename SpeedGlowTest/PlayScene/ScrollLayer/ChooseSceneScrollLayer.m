//
//  PlayLayer.m
//  SpeedGlowTest
//
//  Created by 邱峰 on 13-1-9.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "ChooseSceneScrollLayer.h"
#import "Obstacle.h"
#import "UserData.h"


@implementation ChooseSceneScrollLayer
{
    CCSprite* lock;
    CCAction* playEffectAction;
}

-(void) onEnterLayer
{

}

-(void) onExitLayer
{
    [self stopAllActions];
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
    [background setOpacity:255/2];
    if (lock!=nil)  [self removeChild:lock cleanup:true];
}

-(void) onClick
{
    
}

-(void) playEnterEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"双击任意位置选择进入场景.mp3"];
    }
}

-(void) playLeftRightEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"左右滑屏左右上角.mp3"];
    }
}

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

-(void) playLockEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"该场景未解锁.mp3"];
    }
}
///目前数字与数字间隔为0.4  0.3~0.4效果最佳

//数字有待调整
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
    }}

-(void) playSingleNum:(id)pSender data:(void*)num
{
    int playNum=(int) num;
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%d.mp3",playNum]];
    }
}

-(void) lockScene
{
    lock=[CCSprite spriteWithFile:@"Lock.png"];
    lock.position=ccp(layerSize.width/2,layerSize.height/2);
    [self addChild:lock];
    if ([Setting sharedSetting].isNeedEffect)
    {
        playEffectAction=[CCSequence actions:
                          [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playSceneEffect:)],
                          [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(playLockEffect:)],
                          [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playLeftRightEffect:)],nil];
        [self runAction:playEffectAction];
    }
}

-(void) unlockScene
{
    [background setOpacity:255];
    if ([Setting sharedSetting].isNeedEffect)
    {
        int sun=[[UserData sharedUserData] getSunAtScene:[Obstacle sharedObstacle].gameScene];
        playEffectAction=[CCSequence actions:
                      [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playSceneEffect:)],
                      [CCDelayTime actionWithDuration:2.5], [CCCallFunc actionWithTarget:self selector:@selector(playAllSunEffect:)],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)[[UserData sharedUserData] getMaxSunAtScene:[Obstacle sharedObstacle].gameScene]],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playHaveSunEffect:)],
                      [CCDelayTime actionWithDuration:2],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)sun],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playEnterEffect:)],
                      [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(playLeftRightEffect:)],nil];
        [self runAction:playEffectAction];
    }

}

@end
