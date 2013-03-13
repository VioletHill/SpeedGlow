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
    [[CCDirector sharedDirector] replaceScene: [PlayGameScene scene]];
}

-(void) playLoadEffect:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"载入中-.mp3"];
}

-(id) init
{
    if (self=[super init])
    {
         totTime=1;
        //totTime=1+12+1;
        
        
      //  [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playLoadEffect:)],nil] ];
        
        
        // 进度条
        CCProgressTimer* process=[CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"Load.png"]];
        process.position=ccp([[CCDirector sharedDirector] winSize].width/2,100);
        
        [process setMidpoint:ccp(0,0)];
        [process setBarChangeRate:ccp(1,0)];
        process.type=kCCProgressTimerTypeBar;
        [self addChild:process];
        
        [process runAction:[CCProgressTo actionWithDuration:totTime percent:100]];
        
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:totTime], [CCCallFunc actionWithTarget:self selector:@selector(enterGame:)],nil]];

    }
    return self;
}

@end
