//
//  Load.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-13.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "Load.h"
#import "SimpleAudioEngine.h"
#import "PlayGameScene.h"
#import "Obstacle.h"


@implementation Load
{
    int totTime;
    CCProgressTimer* process;
}

+(CCScene*) scene
{
    CCScene *scene = [CCScene node];
	Load *layer = [Load node];
	[scene addChild: layer];
	return scene;
}

-(void) enterGame:(id)pSender
{
    [[CCDirector sharedDirector] pushScene: [PlayGameScene scene]];
}

-(void) playLoadEffect:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"载入中-.mp3"];
}

-(void) preloadEffect
{
    if ([Obstacle sharedObstacle].gameScene==kYLFC)
    {
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"1夜路飞车.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"货箱.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"路牌.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"猫咪.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"猫咪的惨叫.mp3"];
    }
    else if ([Obstacle sharedObstacle].gameScene==kBYYM)
    {
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"2暴雨要密.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"倒下的树.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"车辆.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"雷声.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"雷声背景.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"雷电.mp3"];
    }
    else if ([Obstacle sharedObstacle].gameScene==kMWTJ)
    {
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"3迷雾通缉.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"大石头.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"自行车.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"货箱.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"自行车声音.mp3"];
    }
    
}

-(void) startInit
{
    totTime=1;
    //totTime=1+12+1;
    
  //  [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playLoadEffect:)],nil] ];
    
    [process setMidpoint:ccp(0,0)];
    [process setBarChangeRate:ccp(1,0)];
    process.type=kCCProgressTimerTypeBar;
    [process runAction:[CCProgressTo actionWithDuration:totTime percent:100]];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:totTime], [CCCallFunc actionWithTarget:self selector:@selector(enterGame:)],nil]];

    
    // 进度条

}
-(id) init
{
    if (self=[super init])
    {
        process=[CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"Load.png"]];
        process.position=ccp([[CCDirector sharedDirector] winSize].width/2,100);
        

        [self addChild:process];
        
                
        [self preloadEffect];
    }
    return self;
}

-(void) onEnter
{
    [super onEnter];
    [self startInit];

}


-(void) onExit
{
    [super onExit];
}
@end
