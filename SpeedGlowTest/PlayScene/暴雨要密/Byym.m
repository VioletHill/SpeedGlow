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
#import "UserData.h"
#import "ByymChooseLevelScene.h"


@implementation Byym
{
    bool isLock;
    
    CGSize layerSize;
    CGSize screenSize;
    CCSprite* background;
    
    CCSprite* lock;
    
    CCAction* playEffectAction;
    
    CCParticleSystemQuad* rain;
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


-(void) pushToChooseLevel
{
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[ByymChooseLevelScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) unlockScene
{
    rain=[CCParticleSystemQuad particleWithFile:@"rain.plist"];
    [self addChild:rain ];
    [background setOpacity:255];
    int sun=[[UserData sharedUserData] getSunByScene:kBYYM];
    playEffectAction=[CCSequence actions:
                      [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playSceneEffect:)],
                      [CCDelayTime actionWithDuration:2.5], [CCCallFunc actionWithTarget:self selector:@selector(playAllSunEffect:)],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)ByymMaxSunNum],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playHaveSunEffect:)],
                      [CCDelayTime actionWithDuration:2],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)sun],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playEnterEffect:)],
                      [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(playLeftRightEffect:)],nil];
    [self runAction:playEffectAction];
}

-(void) lockScene
{
    lock=[CCSprite spriteWithFile:@"Lock.png"];
    lock.position=ccp(layerSize.width/2,layerSize.height/2);
    [self addChild:lock];
}

-(void) onEnterLayer
{
//    if ([[UserData sharedUserData] getIsUnlockAtScene:kBYYM])
//    {
//        isLock=false;
//        [self unlockScene];
//    }
//    else
//    {
//        isLock=true;
//        [self lockScene];
//    }
    [self unlockScene];
}

-(void) onExitLayer
{
    [self removeChild:rain cleanup:true];
    if (lock!=nil)  [self removeChild:lock cleanup:true];
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
