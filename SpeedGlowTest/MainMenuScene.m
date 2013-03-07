//
//  MainMenu.m
//  SpeedGlow
//
//  Created by 邱峰 on 12-12-31.
//  Copyright 2012年 VioletHill. All rights reserved.
//

#import "HelpScene.h"
#import "IntroLayer.h"
#import "MainMenuScene.h"
#import "SettingScene.h"
#import "PlayScene.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"


@implementation MainMenuScene
{
    CGSize screenSize ;
    int nowEffect;
    CCSprite* background;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenuScene *layer = [MainMenuScene node];
	[scene addChild: layer];
	return scene;

}

-(void) addHelp
{
    CCMenuItemImage* helpMenuItem=[CCMenuItemImage itemWithNormalImage:@"HelpMain.png" selectedImage:@"HelpSelect.png" target:self selector:@selector(pushToHelpScene:)];
    CCMenu* helpMenu=[CCMenu menuWithItems:helpMenuItem, nil];
    [helpMenuItem setAnchorPoint:ccp(0,0)];
    [helpMenu setPosition:CGPointMake(screenSize.width-[helpMenuItem contentSize].width, 0)];
    [self addChild:helpMenu];
}

-(void) addSetting
{
    CCMenuItemImage* settingMenuItem=[CCMenuItemImage itemWithNormalImage:@"Setting.png" selectedImage:@"SettingSelect.png"  target:self selector:@selector(pushToSettingScene:)];
    CCMenu* settingMenu=[CCMenu menuWithItems:settingMenuItem, nil];
    [settingMenuItem setAnchorPoint:ccp(0,0)];
    settingMenu.position=ccp(0,0);
    [self addChild:settingMenu];
}

-(void) addPlay
{
    CCMenuItemImage* playMenuItem=[CCMenuItemImage itemWithNormalImage:@"Play.png" selectedImage:@"PlaySelect.png" target:self selector:@selector(pushToPlayScene:)];
    CCMenu* playMenu=[CCMenu menuWithItems:playMenuItem, nil];
    playMenu.position=ccp(screenSize.width/2,screenSize.height/2+10);
    [self addChild:playMenu];
    
    
    ///////////////////////改变透明度/////////////
    CCFiniteTimeAction* downAction=[CCSpawn actionOne:[CCFadeIn actionWithDuration:0.5] two:[CCMoveBy actionWithDuration:0.5 position:ccp(0, -20)]];
    CCFiniteTimeAction* upAction=[CCSpawn actionOne:[CCFadeOut actionWithDuration:0.5] two:[CCMoveBy actionWithDuration:0.5 position:ccp(0, 20)]];
    CCSequence* downAndUpAction=[CCSequence actions:downAction ,upAction, nil];
    
    [playMenu runAction:[CCRepeatForever actionWithAction:downAndUpAction]];
    
}

-(void) preloadMusic
{
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"01主菜单单击屏幕中间开始游戏.mp3"];
}

-(id) init
{
    if( (self=[super init]))
    {
        [self preloadMusic];
        
        screenSize=[[CCDirector sharedDirector] winSize];
        background=[CCSprite spriteWithFile:@"MainMenuBackground.png"];
        [background setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
        [self addChild:background];
        
        [self addHelp];
        
        [self addSetting];
        
        [self addPlay];
        
    }
    return self;
}


-(void) pushToHelpScene:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    }
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[HelpScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}


-(void) pushToSettingScene:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    }
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[SettingScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];

}

-(void) pushToPlayScene:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    }
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[PlayScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}


-(void) onEnter
{
    [super onEnter];
    if ([Setting sharedSetting].isNeedEffect)
    {
        nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"01主菜单单击屏幕中间开始游戏.mp3"];
       // nowEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"01主菜单单击屏幕中间开始游戏.mp3" pitch:1.0 pan:0.0 gain:1];
    }
}

-(void) onExit
{
    [[SimpleAudioEngine sharedEngine] stopEffect:nowEffect];
    [super onExit];
}

@end
