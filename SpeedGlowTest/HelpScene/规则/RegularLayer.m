//
//  RegularLayer.m
//  SpeedGlow
//
//  Created by 邱峰 on 13-1-1.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "RegularLayer.h"
#import "Setting.h"

#define addDistance 40
@implementation RegularLayer
{
    CGSize layerSize;
    CCAction* playEffectAction;
    int effectCurrent;
}

-(id) init
{
    effectCurrent=0;
    if ([super init]!=nil)
    {
        [self setContentSize:CGSizeMake(650, 497)];
        layerSize=[self contentSize];
      
        
        CCSprite* bg=[CCSprite spriteWithFile:@"OperateBackground.png"];
        bg.position=ccp(layerSize.width/2,layerSize.height/2);
        [self addChild:bg];

    }
    return self;
}

-(void) nextOrder
{
    
}

-(void) lastOrder
{
    
}

-(void) onEnterLayer
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        playEffectAction=[CCSequence actions:
                          [CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playSceneEffect:)],
                          [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(playUpDownScrollEffect:)],
                          [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(playSlideEffect:)],
                          [CCDelayTime actionWithDuration:2.5],[CCCallFuncND actionWithTarget:self selector:@selector(playPromotsEffect:data:) data:(void*) effectCurrent],nil];
    }
    else
    {
        playEffectAction=[CCSequence actions:[CCDelayTime actionWithDuration:1], [CCCallFuncND actionWithTarget:self selector:@selector(playPromotsEffect:data:) data:(void*) effectCurrent],nil];
    }
    [self runAction:playEffectAction];
}

-(void) onExitLayer
{
    
}

@end
