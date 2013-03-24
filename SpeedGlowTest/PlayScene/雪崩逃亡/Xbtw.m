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



-(void) onEnterLayer
{
    [Obstacle sharedObstacle].gameScene=kXBTW;
    if ([[UserData sharedUserData] getIsUnlockAtScene:kXBTW])
    {
        isLock=false;
        [self unlockScene];
        [self onSnow];
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
    [super onExitLayer];

}

-(void) onClick
{
    if (isLock) return;
    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音二双击.mp3"];
    [self pushToChooseLevel];
}

@end
