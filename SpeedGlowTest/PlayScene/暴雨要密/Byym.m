//
//  Byym.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-25.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "Byym.h"
#import "Setting.h"
#import "SimpleAudioEngine.h"


@implementation Byym
{
    CGSize layerSize;
    CGSize screenSize;
    CCSprite* background;
    
    CCAction* playEffectAction;
    
    ALuint* nowEffect;
}

-(id) init
{
    
    if ([super init]!=nil)
    {
        [self setContentSize:CGSizeMake(478, 484)];
        layerSize=[self contentSize];
        
        screenSize=[[CCDirector sharedDirector] winSize];
        
        //background
        background=[CCSprite spriteWithFile:@"ByymScrollLayer.png"];
        [background setAnchorPoint:ccp(0.5,0)];
        [background setPosition:ccp(layerSize.width/2,-106)];
        [background setOpacity:255/2];
        [self addChild:background];
        
        //frame
        CCSprite* frame=[CCSprite spriteWithFile:@"FrameLayer.png"];
        frame.position=ccp(layerSize.width/2,layerSize.height/2);
        [self addChild:frame];
        
        //title
        CCSprite* title=[CCSprite spriteWithFile:@"ByymTitle.png"];
        title.position=ccp(layerSize.width/2,layerSize.height-title.contentSize.height/2-22);
        [self addChild:title];
    }
    
    return self;
}

-(void) playSceneEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"场景二.mp3"];
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

-(void) pushToChooseLevel
{
  
}

-(void) onEnterLayer
{
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
