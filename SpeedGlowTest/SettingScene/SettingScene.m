//
//  SettingScene.m
//  SpeedGlow
//
//  Created by 邱峰 on 13-1-1.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "SettingScene.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"
#import "UserData.h"

@implementation SettingScene
{
    CGSize screenSize;
    
    CCSprite* labelSprite[3];
    
    CCSprite* switchSprite[2];
    
    int indexOrder;
    
    ALuint nowEffect;
    CCAction* playEffectAction;
}


+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	SettingScene *layer = [SettingScene node];
	[scene addChild: layer];
	return scene;
    
}


-(void) addText
{
    CCTexture2D* backgroundTexture=[[CCTextureCache sharedTextureCache] addImage:@"SettingBackground.png"];
    
    CCSprite* background=[CCSprite spriteWithTexture:backgroundTexture];
    background.position=ccp(screenSize.width/2,screenSize.height/2);
    [self addChild:background];
    
    // 背景音乐
    CCSprite* blackScreenBackgroundMusic=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(492, 266, 224, 84)];
    labelSprite[0]=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(268, 266, 224, 84)];
    
    blackScreenBackgroundMusic.position=labelSprite[0].position=ccp(380,screenSize.height-308);
    [self addChild:blackScreenBackgroundMusic];
    [self addChild:labelSprite[0]];
    
    // 语音提示
    CCSprite* blackScreenEffect=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(492, 266, 224, 84)];
    labelSprite[1]=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(274, 373, 224, 84)];
    labelSprite[1].opacity=255/2;
    
    blackScreenEffect.position=labelSprite[1].position=ccp(386,screenSize.height-415);
    [self addChild:blackScreenEffect];
    [self addChild:labelSprite[1]];
    
    //重置记录
    CCSprite* blackScreenRecord=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(492, 266, 224, 84)];
    labelSprite[2]=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(389, 463, 224, 84)];
    labelSprite[2].position=blackScreenRecord.position=ccp(501,screenSize.height-505);
    labelSprite[2].opacity=255/2;
    [self addChild:blackScreenRecord];
    [self addChild:labelSprite[2]];
}

-(void) addSwitch
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTextureFilename:@"SwitchOff.png" rect:CGRectMake(0, 0, 249, 92)] name:@"SwitchOff"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTextureFilename:@"SwitchOn.png" rect:CGRectMake(0, 0, 249, 92)] name:@"SwitchOn"];
    
    if (![Setting sharedSetting].isNeedBackgroundMusic)
    {
        switchSprite[0]=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SwitchOff"]];
    }
    else
    {
        switchSprite[0]=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SwitchOn"]];
    }
    switchSprite[0].position=ccp(600,screenSize.height-330);
    [self addChild:switchSprite[0]];
    
    if (![Setting sharedSetting].isNeedEffect)
    {
        switchSprite[1]=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SwitchOff"]];
    }
    else
    {
        switchSprite[1]=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SwitchOn"]];
    }
    switchSprite[1].position=ccp(600,screenSize.height-437);
    [self addChild:switchSprite[1]];
}

-(CCAction*) CCMoveByPosition:(CGPoint)point AndFadeOutWithTime:(ccTime)time
{
    CCAction* action;
    action=[CCSpawn actions:[CCMoveBy actionWithDuration:1 position:point], nil];
    return action;
}

-(void) changeSwitch
{
    if (indexOrder==0)
    {
        if ([Setting sharedSetting].isNeedBackgroundMusic)
        {
            [Setting sharedSetting].isNeedBackgroundMusic=false;
            [[UserData sharedUserData] setIsNeedBg:false];
            [switchSprite[0] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SwitchOff"]];
        }
        else
        {
            [Setting sharedSetting].isNeedBackgroundMusic=true;
            [[UserData sharedUserData] setIsNeedBg:true];
            [switchSprite[0] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SwitchOn"]];
        }
    }
    else
    {
        if ([Setting sharedSetting].isNeedEffect)
        {
            [Setting sharedSetting].isNeedEffect=false;
            [[UserData sharedUserData] setIsNeedEffect:false];
            [switchSprite[1] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SwitchOff"]];
        }
        else
        {
            [Setting sharedSetting].isNeedEffect=true;
            [[UserData sharedUserData] setIsNeedEffect:true];
            [switchSprite[1] setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SwitchOn"]];
        }
    }
    [self resetIndex];
}

-(void) addBack
{
    ////后退
    CCMenuItemImage* backMenuItem=[CCMenuItemImage itemWithNormalImage:@"Back.png" selectedImage:NULL target:self selector:@selector(returnLastScene:)];
    CCMenu* backMenu=[CCMenu menuWithItems:backMenuItem, nil];
    backMenu.position=ccp([backMenuItem contentSize].width/2, screenSize.height-[backMenuItem contentSize].height/2);
    [self addChild:backMenu];
}

-(void) addNextAndLast
{
    //上一条
    CCMenuItemImage* lastOrderMenuItem=[CCMenuItemImage itemWithNormalImage:@"LastOrder.png" selectedImage:nil target:self selector:@selector(lastOrder:)];
    CCMenu* lastOrderMenu=[CCMenu menuWithItems:lastOrderMenuItem, nil];
    [lastOrderMenuItem setAnchorPoint:ccp(0,0)];
    lastOrderMenu.position=ccp(0,20);
    [self addChild:lastOrderMenu];
    
    //下一条
    CCMenuItemImage* nextOrderMenuItem=[CCMenuItemImage itemWithNormalImage:@"NextOrder.png" selectedImage:nil target:self selector:@selector(nextOrder:)];
    CCMenu* nextOrderMenu=[CCMenu menuWithItems:nextOrderMenuItem, nil];
    [nextOrderMenuItem setAnchorPoint:ccp(0, 0)];
    nextOrderMenu.position=ccp(screenSize.width-[nextOrderMenuItem contentSize].width,20);
    [self addChild:nextOrderMenu];

}

-(id) init
{
    if (self=[super init])
    {
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        indexOrder=0;
        
        screenSize=[[CCDirector sharedDirector] winSize];

        [self addText];
        
        [self addSwitch];
        
        [self addBack];
        
        [self addNextAndLast];
    }
    return self;
}

-(void) callReturnLastScene:(id)pSender
{
    [[CCDirector sharedDirector] popScene];
}

-(void) returnLastScene:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    }
    
    CCAction* action=[CCSequence actions:[CCScaleTo actionWithDuration:0.1 scale:0.25],[CCScaleTo actionWithDuration:0.05 scale:1],[CCCallFunc actionWithTarget:self selector:@selector(callReturnLastScene:)],
                      nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) resetIndex
{
    [self stopAllActions];
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
    switch (indexOrder)
    {
        case 0:
            playEffectAction=[self playEffectBGM];
            break;
        case 1:
            playEffectAction=[self playEffectSpeak];
            break;
        default:
            playEffectAction=nil;
            break;
    }
    if ([Setting sharedSetting].isNeedEffect)
    {
        if (playEffectAction!=nil)  [self runAction:playEffectAction];
    }
}

-(void) lastOrder:(id)pSender
{
    if (indexOrder==0) return;
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    }
    labelSprite[indexOrder].opacity=255/2;
    labelSprite[--indexOrder].opacity=255;
    
    [self resetIndex];
}

-(void) nextOrder:(id)pSender
{
    if (indexOrder==2) return;
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    }
    labelSprite[indexOrder].opacity=255/2;
    labelSprite[++indexOrder].opacity=255;
    
    [self resetIndex];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([touch tapCount]==2)
    {
        if ([Setting sharedSetting].isNeedEffect)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"按键音二双击.mp3"];
        }
        
        if (indexOrder<2)
        {
            [self changeSwitch];
        }
    }
    return false;
}

-(void) playEffectOnEnter:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"设置面板.mp3"];
    }
}

-(void) playEffectBGM:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"背景音乐.mp3"];
    }
}

-(void) playEffectOpen:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"开.mp3"];
    }
}

-(void) playEffectClose:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"关.mp3"];
    }
}

-(void) playEffectSpeak:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"语音提示.mp3"];
    }
}

-(CCAction*) playEffectBGM
{
    if (![Setting sharedSetting].isNeedBackgroundMusic)
    {
        return [CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(playEffectBGM:)],[CCDelayTime actionWithDuration:1.5], [CCCallFunc actionWithTarget:self selector:@selector(playEffectClose:)],nil];
    }
    else
    {
        return [CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(playEffectBGM:)],[CCDelayTime actionWithDuration:1.5], [CCCallFunc actionWithTarget:self selector:@selector(playEffectOpen:)],nil];
    }
}

-(CCAction*) playEffectSpeak
{
    if (![Setting sharedSetting].isNeedEffect)
    {
        return [CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(playEffectSpeak:)],[CCDelayTime actionWithDuration:1.5], [CCCallFunc actionWithTarget:self selector:@selector(playEffectClose:)],nil];
    }
    else
    {
        return [CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(playEffectSpeak:)],[CCDelayTime actionWithDuration:1.5], [CCCallFunc actionWithTarget:self selector:@selector(playEffectOpen:)],nil];
    }
}

-(void) onEnter
{
    [super onEnter];
    if ([Setting sharedSetting].isNeedEffect)
    {
        playEffectAction=[CCSequence actions:[CCDelayTime actionWithDuration:0.5],[CCCallFunc actionWithTarget:self selector:@selector(playEffectOnEnter:)],[CCDelayTime actionWithDuration:13],[self playEffectBGM],nil];
        [self runAction:playEffectAction];
    }
}

-(void) onExit
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrameByName:@"SwitchOff"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrameByName:@"SwitchOn"];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[SimpleAudioEngine sharedEngine] stopAllEffect];
    [self stopAllActions];
    [super onExit];
}

@end
