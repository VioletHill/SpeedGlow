//
//  ByymEasyLayer.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-13.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "ByymEasyLevelLayer.h"
#import "Setting.h"
#import "Obstacle.h"
#import "Load.h"
#import "UserData.h"

@implementation ByymEasyLevelLayer
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
        CCSprite* title=[CCSprite spriteWithFile:@"Easy.png"];
        title.position=ccp(layerSize.width/2,layerSize.height-title.contentSize.height/2-22);
        [self addChild:title];
        
        
    }
    return self;
}

-(void) startGame
{
    [Obstacle sharedObstacle].gameScene=kBYYM;
    [Obstacle sharedObstacle].gameLevel=kEASY;
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[Load scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) playEasyEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"一难度简单.mp3"];
    }
    
}

-(void) onEnterLayer
{
    int sun=[[UserData sharedUserData] getSunByScene:kBYYM andLevel:kEASY];
    playEffectAction=[CCSequence actions:
                      [CCDelayTime actionWithDuration:1.2],[CCCallFunc actionWithTarget:self selector:@selector(playEasyEffect:)],
                      [CCDelayTime actionWithDuration:2], [CCCallFunc actionWithTarget:self selector:@selector(playAllSunEffect:)],
                      [CCDelayTime actionWithDuration:1.5],[CCCallFuncND actionWithTarget:self selector:@selector(playNum:data:) data:(void*)ByymEasySunNum],
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
