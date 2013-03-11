//
//  Mwtj.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-25.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "Mwtj.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"
#import "UserData.h"


@implementation Mwtj
{
    bool isLock;
    
    CGSize layerSize;
    CGSize screenSize;
    CCSprite* background;
    CCSprite* lock;
    
    CCAction* playEffectAction;
    
    CCParticleSystemQuad* fog;
}

-(id) init
{
    
    if ([super init]!=nil)
    {
        [self setContentSize:CGSizeMake(478, 484)];
        layerSize=[self contentSize];
        
        screenSize=[[CCDirector sharedDirector] winSize];
        
        //background
        background=[CCSprite spriteWithFile:@"MwtjScrollLayer.png"];
        [background setAnchorPoint:ccp(0.5,0)];
        [background setPosition:ccp(layerSize.width/2,-106)];
        [background setOpacity:255/2];
        [self addChild:background];
        
        //title
        CCSprite* title=[CCSprite spriteWithFile:@"MwtjTitle.png"];
        title.position=ccp(layerSize.width/2,layerSize.height-title.contentSize.height/2-22);
        [self addChild:title];
    }
    
    return self;
}

-(void) playSceneEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"场景三.mp3"];
    }
}



-(void) pushToChooseLevel
{
    
}

-(void) onFog
{
    fog=[CCParticleSystemQuad particleWithFile:@"fog.plist"];
    [self addChild:fog];
}

-(void) unlockScene
{
    [self onFog];
    [background setOpacity:255];
    int sun=[[UserData sharedUserData] getSunByScene:kYLFC];
    playEffectAction=[CCSequence actions:
                      [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playSceneEffect:)],
                      [CCDelayTime actionWithDuration:2.5], [CCCallFunc actionWithTarget:self selector:@selector(playAllSunEffect:)],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)MwtjMaxSunNum],
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
//    if ([[UserData sharedUserData] getIsUnlockAtScene:kMWTJ])
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
    [super onExitLayer];
    [self removeChild:fog cleanup:true];
    if (lock!=nil)  [self removeChild:lock cleanup:true];
    [background setOpacity:255/2];
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
    [self stopAllActions];
}

-(void) onClick
{
    [self pushToChooseLevel];
}

@end
