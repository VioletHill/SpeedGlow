//
//  MusicEffictLayer.m
//  SpeedGlow
//
//  Created by 邱峰 on 13-1-1.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "EffectLayer.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"



#define labelFontSize 40
#define currentPosition ccp(layerSize.width/2,layerSize.height/2+100);
#define labelSpace 100
#define addDistance 40

#define lowerLimit  layerSize.height/2+addDistance-2*labelSpace
#define uperLimit   layerSize.height/2+addDistance+labelSpace
#define middleLightPoint layerSize.height/2+addDistance

static const int totalEffect=4;


@implementation EffectLayer
{
    CCLabelTTF* effectLabel[4];
    
    int effectCurrent;
    CGSize layerSize;
    
    CCAction* playEffectAction;
    
    bool isChangeOrder;
    
    int nowEffect;
}

-(void) addMusicEffectLabel
{
    isChangeOrder=false;
    effectCurrent=0;

    effectLabel[0]=[CCLabelTTF labelWithString:@"左方有障碍物" fontName:@"Marker Felt" fontSize:labelFontSize];
    effectLabel[1]=[CCLabelTTF labelWithString:@"右方有障碍物" fontName:@"Marker Felt" fontSize:labelFontSize];
    effectLabel[2]=[CCLabelTTF labelWithString:@"向左转弯" fontName:@"Marker Felt" fontSize:labelFontSize];
    effectLabel[3]=[CCLabelTTF labelWithString:@"向右转弯" fontName:@"Marker Felt" fontSize:labelFontSize];
    
    for (int i=0; i<totalEffect; i++)
    {
        [effectLabel[i] setPosition:ccp(layerSize.width/2,middleLightPoint-i*labelSpace)];
        [self addChild:effectLabel[i]];
        
        if (effectLabel[i].position.y>uperLimit || effectLabel[i].position.y<lowerLimit)
        {
            [effectLabel[i] setVisible:false];
        }
        else
        {
            [effectLabel[i] setVisible:true];
        }
        
        if ( effectLabel[i].position.y==middleLightPoint)
        {
            effectLabel[i].opacity=255;
        }
        else
        {
            effectLabel[i].opacity=100;
        }

    }
    
}

-(void) preloadMusic
{
   
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"当前页音效页.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"上下滚动切换查看不同音效.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"向右滑屏切换操作页.mp3"];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"音效提示路障L.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"音效提示路障R.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"红绿灯红转绿音效.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"红绿灯绿转红音效.mp3"];
}

-(id) init
{
    if ([super init]!=nil)
    {
        [self setContentSize:CGSizeMake(478, 484)];
        layerSize=[self contentSize];
        
        //frame
        CCSprite* bg=[CCSprite spriteWithFile:@"EffectBackground.png"];
        bg.position=ccp(layerSize.width/2,layerSize.height/2+addDistance);
        [self addChild:bg];
        
        [self addMusicEffectLabel];
        
        [self preloadMusic];
    }
    return self;
}

-(void) playPromotsEffect:(CCNode*)pTarget data:(void*)num
{
    switch ((int) num)
    {
        case 0:
            nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"音效提示路障L.mp3"];
            break;
        case 1:
            nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"音效提示路障R.mp3"];
            break;
        case 2:
            nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"红绿灯红转绿音效.mp3"];
            break;
        case 3:
            nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"红绿灯绿转红音效.mp3"];
            break;
        default:
            break;
    }
}

-(void) resetLabelDone:(CCNode*)pTarget data:(void*) labelNum
{

    CCLabelTTF* musicLabel=effectLabel[(int) labelNum];
    
    if (musicLabel.position.y>uperLimit || musicLabel.position.y<lowerLimit)
    {
        [musicLabel setVisible:false];
    }
    else
    {
        [musicLabel setVisible:true];
    }
    
    if ( musicLabel.position.y==middleLightPoint )
    {
        [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
        [self stopAllActions];
        
        CCAction* play=[CCSequence actions:[CCDelayTime actionWithDuration:0.5], [CCCallFuncND actionWithTarget:self selector:@selector(playPromotsEffect:data:) data:labelNum],nil];
        [self runAction:play];
        
        musicLabel.opacity=255;
    }
    else
    {
        musicLabel.opacity=100;
    }
    
    isChangeOrder=false;
}

-(void) nextOrder
{
    if (isChangeOrder) return ;

    if (effectCurrent==totalEffect-1) return;
    isChangeOrder=true;
    
    
    
    for (int i=0; i<totalEffect; i++)
    {
        if (effectLabel[i].position.y==uperLimit)
        {
            [effectLabel[i] setVisible:false];
        }
        
        CCAction* action=[CCSequence actions:[CCMoveBy actionWithDuration:0.5 position:ccp(0,labelSpace)],[CCCallFuncND actionWithTarget:self selector:@selector(resetLabelDone: data:)data:(void*) i],nil];
        [effectLabel[i] runAction:action];
    }
    
    effectCurrent++;
}

-(void) lastOrder
{
    if (isChangeOrder) return ;
    
    if (effectCurrent==0) return;
    isChangeOrder=true;
    
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
    
    for (int i=0; i<totalEffect; i++)
    {
        if (effectLabel[i].position.y==lowerLimit)
        {
            [effectLabel[i] setVisible:false];
        }
        CCAction* action=[CCSequence actions:[CCMoveBy actionWithDuration:0.5 position:ccp(0,-labelSpace)],[CCCallFuncND actionWithTarget:self selector:@selector(resetLabelDone: data:)data:(void*) i],nil];
        [effectLabel[i] runAction:action];
    }
    
    effectCurrent--;
}

-(void) playSceneEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"当前页音效页.mp3"];
    }
}

-(void) playUpDownScrollEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"上下滚动切换查看不同音效.mp3"];
    }
}

-(void) playSlideEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"向右滑屏切换操作页.mp3"];
    }
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
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
    [self stopAllActions];
}

@end
