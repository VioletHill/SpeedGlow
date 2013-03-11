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

@implementation SettingScene
{
    CGSize screenSize;
    
    CCSprite* backgroundMusic;
    CCSprite* effectMusic;
    CCSprite* clearRecord;
    
    CCProgressTimer* closeSprite[2];
    CCProgressTimer* openSprite[2];
    
    int indexOrder;
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
    backgroundMusic=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(268, 266, 224, 84)];
    
    blackScreenBackgroundMusic.position=backgroundMusic.position=ccp(380,screenSize.height-308);
    [self addChild:blackScreenBackgroundMusic];
    [self addChild:backgroundMusic];
    
    // 语音提示
    CCSprite* blackScreenEffect=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(492, 266, 224, 84)];
    effectMusic=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(274, 373, 224, 84)];
    effectMusic.opacity=255/2;
    
    blackScreenEffect.position=effectMusic.position=ccp(386,screenSize.height-415);
    [self addChild:blackScreenEffect];
    [self addChild:effectMusic];
    
    //重置记录
    CCSprite* blackScreenRecord=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(492, 266, 224, 84)];
    clearRecord=[CCSprite spriteWithTexture:backgroundTexture rect:CGRectMake(389, 463, 224, 84)];
    clearRecord.position=blackScreenRecord.position=ccp(501,screenSize.height-505);
    clearRecord.opacity=255/2;
    [self addChild:blackScreenRecord];
    [self addChild:clearRecord];
}

-(void) addSwitch
{
    CCSprite* sprite=[CCSprite spriteWithFile:@"Switch.png"];
    closeSprite[0]=[CCProgressTimer progressWithSprite:sprite];
}

-(void) addBack
{
    ////后退
    CCMenuItemImage* backMenuItem=[CCMenuItemImage itemWithNormalImage:@"Back.png" selectedImage:NULL target:self selector:@selector(returnLastScene:)];
    CCMenu* backMenu=[CCMenu menuWithItems:backMenuItem, nil];
    backMenu.position=ccp([backMenuItem contentSize].width/2, screenSize.height-[backMenuItem contentSize].height/2);
    [self addChild:backMenu];
}

-(void) preloadMusic
{
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
        
        [self preloadMusic];
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


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([touch tapCount]==2)
    {
        
    }
    return false;
}


-(void) onEnter
{
    [super onEnter];
}

-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

@end
