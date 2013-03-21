//
//  Xbtw.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-25.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "Xbtw.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"
#import "UserData.h"
#import "XbtwChooseLevelScene.h"


@implementation Xbtw
{
    bool isLock;
    
    CGSize layerSize;
    CGSize screenSize;
    CCSprite* background;
    CCSprite* lock;
    
    CCAction* playEffectAction;
    
    CCParticleSystemQuad* snow;
    
}

-(id) init
{
    
    if ([super init]!=nil)
    {
        [self setContentSize:CGSizeMake(478, 484)];
        layerSize=[self contentSize];
        
        screenSize=[[CCDirector sharedDirector] winSize];
        
        //background
        background=[CCSprite spriteWithFile:@"XbtwScrollLayer.png"];
        [background setAnchorPoint:ccp(0.5,0)];
        background.position=ccp(layerSize.width/2,-106);
        [background setOpacity:255/2];
        [self addChild:background];
    }
    
    return self;
}

-(void) playSceneEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"场景四.mp3"];
    }
}



-(void) pushToChooseLevel
{
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[XbtwChooseLevelScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) onSnow
{
    snow=[CCParticleSystemQuad particleWithFile:@"mySnow.plist"];
    [self addChild:snow];
}

-(void) unlockScene
{
    [self onSnow];
    [background setOpacity:255];
    int sun=[[UserData sharedUserData] getSunByScene:kXBTW];
    if ([Setting sharedSetting].isNeedEffect)
    {
        playEffectAction=[CCSequence actions:
                      [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playSceneEffect:)],
                      [CCDelayTime actionWithDuration:2.5], [CCCallFunc actionWithTarget:self selector:@selector(playAllSunEffect:)],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)XbtwMaxSunNum],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playHaveSunEffect:)],
                      [CCDelayTime actionWithDuration:2],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)sun],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playEnterEffect:)],
                      [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(playLeftRightEffect:)],nil];
        [self runAction:playEffectAction];
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

-(void) onEnterLayer
{
    if ([[UserData sharedUserData] getIsUnlockAtScene:kXBTW])
    {
        isLock=false;
        [self unlockScene];
    }
    else
    {
        isLock=true;
        [self lockScene];
    }
    //[self unlockScene];
}

-(void) onExitLayer
{
    [self removeChild:snow cleanup:true];
    if (lock!=nil)  [self removeChild:lock cleanup:true];
    [background setOpacity:255/2];
    [self stopAllActions];
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
    [super onExitLayer];

}

-(void) onClick
{
    if (isLock) return;
    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音二双击.mp3"];
    [self pushToChooseLevel];
}

@end
