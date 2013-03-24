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

-(void) onRain
{
    rain=[CCParticleSystemQuad particleWithFile:@"rain.plist"];
    [self addChild:rain ];
    [background setOpacity:255];
}





-(void) onEnterLayer
{
    [Obstacle sharedObstacle].gameScene=kBYYM;
    if ([[UserData sharedUserData] getIsUnlockAtScene:kBYYM])
    {
        isLock=false;
        [self onRain];
        [self unlockScene];
    }
    else
    {
        isLock=true;
        [super lockScene];
    }
    //[self unlockScene];
}

-(void) onExitLayer
{
    [self removeChild:rain cleanup:true];
    [super onExitLayer];

}

-(void) onClick
{
    if (isLock) return;
    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音二双击.mp3"];
    [self pushToChooseLevel];
}


@end
