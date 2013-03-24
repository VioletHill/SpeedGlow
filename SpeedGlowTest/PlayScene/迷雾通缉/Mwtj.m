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
#import "MwtjChooseLevelScene.h"


@implementation Mwtj
{
    bool isLock;
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
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[MwtjChooseLevelScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) onFog
{
    fog=[CCParticleSystemQuad particleWithFile:@"fog.plist"];
    [self addChild:fog];
}


-(void) onEnterLayer
{
    [Obstacle sharedObstacle].gameScene=kMWTJ;
    if ([[UserData sharedUserData] getIsUnlockAtScene:kMWTJ])
    {
        isLock=false;
        [super unlockScene];
        [self onFog];
    }
    else
    {
        isLock=true;
        [super lockScene];
    }
   // [self unlockScene];
}

-(void) onExitLayer
{
    [self removeChild:fog cleanup:true];
    [super onExitLayer];

}

-(void) onClick
{
    if (isLock) return ;
    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音二双击.mp3"];
    [self pushToChooseLevel];
}

@end
