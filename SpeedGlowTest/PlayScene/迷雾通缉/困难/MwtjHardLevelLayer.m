//
//  MwtjHardLevelLayer.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-14.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "MwtjHardLevelLayer.h"
#import "UserData.h"
#import "Setting.h"
#import "Load.h"

@implementation MwtjHardLevelLayer
{
    CGSize layerSize;
    CCAction* playEffectAction;
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
        CCSprite* title=[CCSprite spriteWithFile:@"Hard.png"];
        title.position=ccp(layerSize.width/2,layerSize.height-title.contentSize.height/2-22);
        [self addChild:title];
    }
    return self;
}

-(void) startGame
{
    [Obstacle sharedObstacle].gameScene=kMWTJ;
    [Obstacle sharedObstacle].gameLevel=kHARD;
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[Load scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) playEasyEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"三难度困难.mp3"];
    }
    
}

-(void) onEnterLayer
{
    int sun=[[UserData sharedUserData] getSunByScene:kMWTJ andLevel:kHARD];
    playEffectAction=[CCSequence actions:
                      [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEasyEffect:)],
                      [CCDelayTime actionWithDuration:2], [CCCallFunc actionWithTarget:self selector:@selector(playAllSunEffect:)],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)MwtjHardSunNum],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playHaveSunEffect:)],
                      [CCDelayTime actionWithDuration:2],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)sun],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFunc actionWithTarget:self selector:@selector(playLeftRightEffect:)],
                      [CCDelayTime actionWithDuration:2],[CCCallFunc actionWithTarget:self selector:@selector(playReturnAndHelpEffect:)],nil];
    [self runAction:playEffectAction];
    
}

-(void) onExitLayer
{
    [self stopAllActions];
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
    [super onExitLayer];
    
}

-(void) onClick
{
    [self startGame];
}

@end
