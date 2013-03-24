//
//  ChooseLevelScene.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-14.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "ChooseLevelScene.h"
#import "UserData.h"
#import "Setting.h"
#import "SimpleAudioEngine.h"
#import "HelpScene.h"

@implementation ChooseLevelScene
{
    CCSprite* totSunSprite1;
    CCSprite* totSunSprite2;
    CCSprite* sprite_;
    CCSprite* haveSunSprite1;
    CCSprite* haveSunSprite2;
}


-(void) callPlayChooseLevelEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"选择难度.mp3"];
    }
}

-(void) playChooseLevelEffect
{
    [self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:0.2] two:[CCCallFunc actionWithTarget:self selector:@selector(callPlayChooseLevelEffect:)]]];
}


-(void) addBack
{
    
    ////后退
    CCMenuItemImage* backMenuItem=[CCMenuItemImage itemWithNormalImage:@"Back.png" selectedImage:NULL target:self selector:@selector(returnLastScene:)];
    CCMenu* backMenu=[CCMenu menuWithItems:backMenuItem, nil];
    backMenu.position=ccp([backMenuItem contentSize].width/2, screenSize.height-[backMenuItem contentSize].height/2);
    [self addChild:backMenu];
}

-(void) addHelp
{
    //帮助
    CCMenuItemImage* helpMenuItem=[CCMenuItemImage itemWithNormalImage:@"Help.png" selectedImage:NULL target:self selector:@selector(pushToHelpScene:)];
    CCMenu* helpMenu=[CCMenu menuWithItems:helpMenuItem, nil];
    helpMenu.position=ccp(screenSize.width-[helpMenuItem contentSize].width/2, screenSize.height-[helpMenuItem contentSize].height/2);
    [self addChild:helpMenu];
    
}

-(void) addSun
{
    CCSprite* sun=[CCSprite spriteWithFile:@"Sun.png"];
    sun.anchorPoint=ccp(0,1);
    sun.position=ccp(372,screenSize.height-636);
    [self addChild:sun];
}

-(void) reflushSunNumAtScene:(GameScene)gameScene  andTotSun:(int)totSun;
{
    [self removeChild:totSunSprite1 cleanup:true];
    [self removeChild:totSunSprite2 cleanup:true];
    [self removeChild:haveSunSprite1 cleanup:true];
    [self removeChild:haveSunSprite2 cleanup:true];
    [self removeChild:sprite_ cleanup:true];
    int haveSun;
    switch (nowPageIndex)
    {
        case 0:
            haveSun=[[UserData sharedUserData] getSunAtScene:gameScene andLevel:kEASY];
            break;
        case 1:
            haveSun=[[UserData sharedUserData] getSunAtScene:gameScene andLevel:kMEDIUM];
            break;
        case 2:
            haveSun=[[UserData sharedUserData] getSunAtScene:gameScene andLevel:kHARD];
            break;
        default:
            haveSun=0;
            break;
    }
    totSunSprite1=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[@"SunNum" stringByAppendingFormat:@"%d",totSun/10]]];
    totSunSprite1.anchorPoint=ccp(0,1);
    totSunSprite1.position=ccp(550,screenSize.height-680);
    [self addChild:totSunSprite1];
    
    totSunSprite2=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[@"SunNum" stringByAppendingFormat:@"%d",totSun%10]]];
    totSunSprite2.anchorPoint=ccp(0,1);
    totSunSprite2.position=ccp(578,screenSize.height-680);
    [self addChild:totSunSprite2];
    
    sprite_=[CCSprite spriteWithFile:@"SunNum_.png"];
    sprite_.anchorPoint=ccp(0,1);
    sprite_.position=ccp(534,screenSize.height-680);
    [self addChild:sprite_];
    
    
    haveSunSprite1=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[@"SunNum" stringByAppendingFormat:@"%d",haveSun/10]]];
    haveSunSprite1.anchorPoint=ccp(0,1);
    haveSunSprite1.position=ccp(478,screenSize.height-680);
    [self addChild:haveSunSprite1];
    
    haveSunSprite2=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[@"SunNum" stringByAppendingFormat:@"%d",haveSun%10]]];
    haveSunSprite2.anchorPoint=ccp(0,1);
    haveSunSprite2.position=ccp(506,screenSize.height-680);
    [self addChild:haveSunSprite2];
}

-(id) init
{
    if (self=[super init])
    {
         screenSize=[[CCDirector sharedDirector] winSize];
    }
    return self;
}

-(void) pushToHelpScene:(id)pSender
{

    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[HelpScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) callReturnLastScene:(id)pSender
{
    [[CCDirector sharedDirector] popScene];
}

-(void) returnLastScene:(id)pSender
{

    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    
    CCAction* action=[CCSequence actions:[CCScaleTo actionWithDuration:0.1 scale:0.25],[CCScaleTo actionWithDuration:0.05 scale:1],[CCCallFunc actionWithTarget:self selector:@selector(callReturnLastScene:)],
                      nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) onEnter
{
    [super onEnter];
    [self playChooseLevelEffect];
}

-(void) onExit
{
    [super onExit];
}

@end
