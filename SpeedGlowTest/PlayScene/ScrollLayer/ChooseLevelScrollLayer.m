//
//  ChooseLevel.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-12.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "ChooseLevelScrollLayer.h"
#import "Setting.h"


@implementation ChooseLevelScrollLayer

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

@end
