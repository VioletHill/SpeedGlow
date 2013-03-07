//
//  Ylfc.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-24.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "Ylfc.h"
#import "ChooseLevel.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"

@implementation Ylfc
{
    CGSize layerSize;
    CGSize screenSize;
    CCSprite* background;
    CCParticleRain* rain;
    
    CCAction* playEffectAction;
    
    int nowEffect;
}



-(void) onRain
{
    // rain=[[CCParticleRain alloc] init];
    CCParticleSystemQuad* rain=[CCParticleSystemQuad particleWithFile:@"YLFCrain.plist"];
   // [rain setBlendAdditive:false];
   // [rain setOpacityModifyRGB:true];
    [self addChild:rain ];
}

-(void) playSceneEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"场景一.mp3"];
    }
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

-(id) init
{

    if ([super init]!=nil)
    {
        [self setContentSize:CGSizeMake(478, 484)];
        layerSize=[self contentSize];
        
        screenSize=[[CCDirector sharedDirector] winSize];
    
        //background
        background=[CCSprite spriteWithFile:@"YlfcScrollLayer.png"];
        [background setAnchorPoint:ccp(0.5,0)];
        background.position=ccp(layerSize.width/2,-106);
        [background setOpacity:255/2];
        [self addChild:background];
    }
    
    return self;
}

-(void) pushToChooseLevel
{
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[ChooseLevel scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) onEnterLayer
{
    [self onRain];
    [background setOpacity:255];
    playEffectAction=[CCSequence actions:
                      [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playSceneEffect:)],
                      [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(playEnterEffect:)],
                      [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(playLeftRightEffect:)],nil];
    [self runAction:playEffectAction];
}

-(void) onExitLayer
{
    [background setOpacity:255/2];
    [self stopAllActions];
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
}

-(void) onClick
{
    [self pushToChooseLevel];
}


@end

