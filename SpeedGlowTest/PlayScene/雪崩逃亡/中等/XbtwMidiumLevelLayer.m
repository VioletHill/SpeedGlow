//
//  XbtwMidiumLevelLayer.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-21.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "XbtwMidiumLevelLayer.h"
#import "UserData.h"
#import "Load.h"
#import "Setting.h"

@implementation XbtwMidiumLevelLayer
{
    BOOL isLock;
}

-(id) init
{
    if (self=[super init])
    {
        [self setContentSize:CGSizeMake(478,484)];
        layerSize=[self contentSize];
        
        //frame
        CCSprite* frame=[CCSprite spriteWithFile:@"FrameLayer.png"];
        frame.position=ccp(layerSize.width/2,layerSize.height/2);
        [self addChild:frame];
        
        //title
        CCSprite* title=[CCSprite spriteWithFile:@"Medium.png"];
        title.position=ccp(layerSize.width/2,layerSize.height-title.contentSize.height/2-22);
        [self addChild:title];
    }
    return self;
}

-(void) startGame
{
    [Obstacle sharedObstacle].gameScene=kXBTW;
    [Obstacle sharedObstacle].gameLevel=kMIDIUM;
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[Load scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) playEasyEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"二难度中等.mp3"];
    }
    
}

-(void) unlockLevel
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        int sun=[[UserData sharedUserData] getSunByScene:kXBTW andLevel:kMIDIUM];
        playEffectAction=[CCSequence actions:
                      [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEasyEffect:)],
                      [CCDelayTime actionWithDuration:2], [CCCallFunc actionWithTarget:self selector:@selector(playAllSunEffect:)],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)XbtwMidiumSunNum],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playHaveSunEffect:)],
                      [CCDelayTime actionWithDuration:2],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)sun],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playLeftRightEffect:)],
                      [CCDelayTime actionWithDuration:2],[CCCallFunc actionWithTarget:self selector:@selector(playReturnAndHelpEffect:)],nil];
        [self runAction:playEffectAction];
    }
}

-(void) onEnterLayer
{
    if ([[UserData sharedUserData] getIsUnlockAtScene:kXBTW andLevel:kMIDIUM])
    {
        [self unlockLevel];
        isLock=false;
    }
    else
    {
        [super lockLevel];
        isLock=true;
    }

    
}

-(void) onExitLayer
{

    [super onExitLayer];
    
}

-(void) onClick
{
    if (isLock) return;
    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音二双击.mp3"];
    [self startGame];
}

@end

