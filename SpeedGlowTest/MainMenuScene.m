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
#import "ChooseScene.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"
#import "UserData.h"
#import "MyMenuItem.h"


@implementation MainMenuScene
{
    CGSize screenSize ;
    CCSprite* background;
    CCAction* playAction;
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


-(void) playMenuSingleClick:(id)pSender
{

}

-(void) playMenuDoubleClick:(id)pSender
{
    [self pushToPlayScene];
}

-(void) addPlay
{    
    MyMenuItem* playMenuItem=[MyMenuItem myMenuItemWithNormalFile:@"Play.png" selectFile:@"PlaySelect.png" target:self singleClick:@selector(playMenuSingleClick:) doubleClick:@selector(playMenuDoubleClick:)];

    [self addChild:playMenuItem];
    ///////////////////////改变透明度/////////////
    CCFiniteTimeAction* downAction=[CCSpawn actionOne:[CCFadeIn actionWithDuration:0.5] two:[CCMoveBy actionWithDuration:0.5 position:ccp(0, -20)]];
    CCFiniteTimeAction* upAction=[CCSpawn actionOne:[CCFadeOut actionWithDuration:0.5] two:[CCMoveBy actionWithDuration:0.5 position:ccp(0, 20)]];
    CCSequence* downAndUpAction=[CCSequence actions:downAction ,upAction, nil];
    
    [playMenuItem runAction:[CCRepeatForever actionWithAction:downAndUpAction]];
    
}


-(id) init
{
    if( (self=[super init]))
    {
        
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
    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[HelpScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}


-(void) pushToSettingScene:(id)pSender
{

    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[SettingScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];

}

-(void) pushToPlayScene
{

    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    CCTransitionFade* fade=[CCTransitionCrossFade transitionWithDuration:0.1 scene:[ChooseScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) playMenuEffect:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"双击进入场景.mp3"];
    
}

-(void) onEnter
{
    [super onEnter];
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"开始宣传语.mp3"];
        playAction=[CCSequence actions:[CCSequence actionWithDuration:14.5], [CCCallFunc actionWithTarget:self selector:@selector(playMenuEffect:)],nil];
        [self runAction:playAction];
    }
}

-(void) onExit
{
    [[SimpleAudioEngine sharedEngine] stopAllEffect];
    [self stopAllActions];
    [super onExit];
}

@end
