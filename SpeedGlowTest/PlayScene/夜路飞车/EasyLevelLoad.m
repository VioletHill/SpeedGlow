//
//  EasyLevelLoad.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-4.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "EasyLevelLoad.h"
#import "SimpleAudioEngine.h"
#import "PlayGameScene.h"


@implementation EasyLevelLoad
{
    int totTime;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	EasyLevelLoad *layer = [EasyLevelLoad node];
	[scene addChild: layer];
	return scene;
    
}

-(void) enterGame:(id)pSender
{
  //  [[CCDirector sharedDirector] rem]
    [[CCDirector sharedDirector] replaceScene: [PlayGameScene scene]];
}

-(void) playLoadEffect:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"载入中-.mp3"];
}

-(void) preloadMusic
{
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"游戏界面.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"321Go.mp3"];
    
    //车音效
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"变道L2R.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"变道R2L.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"启动发车.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"常速行驶音效.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"加速音效.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"重启间隙2s.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"重启间隙4s.mp3"];
    
    
    //路障
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"路障提示音_L.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"路障提示音_R.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"路障超越L.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"路障超越R.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"撞到路障.mp3"];
    
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"货箱.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"路牌.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"猫咪.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"猫咪的惨叫.mp3"];
    
    
    //太阳
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"SunEatenL.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"SunEatenR.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sun提示L.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sun提示R.mp3"];
    
    //红绿灯
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"前方红灯转绿灯.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"前方绿灯转红灯.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"交通信号灯红灯03.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"交通信号灯绿灯03.mp3"];
    
    //转弯
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"完成转弯提示音.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"向右转提示音单位.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"向左转提示音单位.mp3"];


}

-(id) init
{
    if (self=[super init])
    {
        totTime=1;
       // totTime=1+12+1;
        
    
       // [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playLoadEffect:)],nil] ];
        
        
        // 进度条
        CCProgressTimer* process=[CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"Load.png"]];
        process.position=ccp(100,100);
        
        [process setMidpoint:ccp(0,0)];
        [process setBarChangeRate:ccp(1,0)];
        process.type=kCCProgressTimerTypeBar;
        [self addChild:process];
        
        [process runAction:[CCProgressTo actionWithDuration:totTime percent:100]];
        
        [self preloadMusic];
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:totTime], [CCCallFunc actionWithTarget:self selector:@selector(enterGame:)],nil]];
    }
    return self;
}



@end
