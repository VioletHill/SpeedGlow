//
//  Ylfc.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-24.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "Ylfc.h"
#import "YlfcChooseLevelScene.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"
#import "UserData.h"

@implementation Ylfc
{
    CGSize layerSize;
    CGSize screenSize;
    CCSprite* background;
    
    CCAction* playEffectAction;
    
    CCParticleSystemQuad* start;
}

-(void) playSceneEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"场景一.mp3"];
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
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[YlfcChooseLevelScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) onStart
{
    start=[CCParticleSystemQuad particleWithFile:@"start.plist"];
     [self addChild:start ];
}

-(void) onEnterLayer
{
    [self onStart];
    [background setOpacity:255];
    
    int sun=[[UserData sharedUserData] getSunByScene:kYLFC];
    playEffectAction=[CCSequence actions:
                      [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playSceneEffect:)],
                      [CCDelayTime actionWithDuration:2.5], [CCCallFunc actionWithTarget:self selector:@selector(playAllSunEffect:)],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)YlfcMaxSunNum],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playHaveSunEffect:)],
                      [CCDelayTime actionWithDuration:2],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)sun],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playEnterEffect:)],
                      [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(playLeftRightEffect:)],nil];
    [self runAction:playEffectAction];
}

-(void) onExitLayer
{
    [self removeChild:start cleanup:true];
    [background setOpacity:255/2];
    [self stopAllActions];
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
    [super onExitLayer];
}

-(void) onClick
{
    [self pushToChooseLevel];
}


@end

