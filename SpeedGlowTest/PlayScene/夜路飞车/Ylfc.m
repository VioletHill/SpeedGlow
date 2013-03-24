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
    [Obstacle sharedObstacle].gameScene=kYLFC;
    [self onStart];
    [super unlockScene];
    [super onEnterLayer];
}

-(void) onExitLayer
{
    [self removeChild:start cleanup:true];
    [super onExitLayer];
}

-(void) onClick
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音二双击.mp3"];
    [self pushToChooseLevel];
}


@end

