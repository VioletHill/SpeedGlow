//
//  PlayScene.m
//  SpeedGlowTest
//
//  Created by 邱峰 on 13-1-9.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "ChooseScene.h"
#import "ChooseScrollLayer.h"
#import "CCScrollLayer.h"
#import "Ylfc.h"
#import "Byym.h"
#import "HelpScene.h"
#import "Xbtw.h"
#import "Mwtj.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"
#import "UserData.h"

@implementation ChooseScene
{
    CGSize screenSize;
    int nowPageIndex;
    ChooseScrollLayer* nowLayer;
    CCScrollLayer *scroller ;
    
    ALuint chooseScene;
    
    
    CCSprite* totSunSprite1;
    CCSprite* totSunSprite2;
    CCSprite* sprite_;
    CCSprite* haveSunSprite1;
    CCSprite* haveSunSprite2;
}

@synthesize playLayer=_playLayer;
@synthesize onPageMoved=_onPageMoved;

+(CCScene *) scene
{

    
    
	CCScene *scene = [CCScene node];
	ChooseScene *layer = [ChooseScene node];
	[scene addChild: layer];
	return scene;
    
}

-(void) reflushSunNum
{
    [self removeChild:totSunSprite1 cleanup:true];
    [self removeChild:totSunSprite2 cleanup:true];
    
    int totSun;
    int haveSun;
    switch (nowPageIndex)
    {
        case 0:
            totSun=YlfcMaxSunNum;
            haveSun=[[UserData sharedUserData] getSunByScene:kYLFC];
            break;
        case 1:
            totSun=ByymMaxSunNum;
            haveSun=[[UserData sharedUserData] getSunByScene:kBYYM];
            break;
        case 2:
            totSun=MwtjMaxSunNum;
            haveSun=[[UserData sharedUserData] getSunByScene:kMWTJ];
            break;
        case 3:
            totSun=XbtwMaxSunNum;
            haveSun=[[UserData sharedUserData] getSunByScene:kXBTW];
            break;
        default:
            totSun=0;
            haveSun=0;
            break;
    }
    totSunSprite1=[CCSprite spriteWithFile:[@"SunNum" stringByAppendingFormat:@"%d.png",totSun/10]];
    totSunSprite1.anchorPoint=ccp(0,1);
    totSunSprite1.position=ccp(550,screenSize.height-680);
    [self addChild:totSunSprite1];
    
    totSunSprite2=[CCSprite spriteWithFile:[@"SunNum" stringByAppendingFormat:@"%d.png",totSun%10]];
    totSunSprite2.anchorPoint=ccp(0,1);
    totSunSprite2.position=ccp(578,screenSize.height-680);
    [self addChild:totSunSprite2];
    
    sprite_=[CCSprite spriteWithFile:@"SunNum_.png"];
    sprite_.anchorPoint=ccp(0,1);
    sprite_.position=ccp(534,screenSize.height-680);
    [self addChild:sprite_];
    
    
    haveSunSprite1=[CCSprite spriteWithFile:[@"SunNum" stringByAppendingFormat:@"%d.png",haveSun/10] ];
    haveSunSprite1.anchorPoint=ccp(0,1);
    haveSunSprite1.position=ccp(478,screenSize.height-680);
    [self addChild:haveSunSprite1];
    
    haveSunSprite2=[CCSprite spriteWithFile:[@"SunNum" stringByAppendingFormat:@"%d.png",haveSun%10] ];
    haveSunSprite2.anchorPoint=ccp(0,1);
    haveSunSprite2.position=ccp(506,screenSize.height-680);
    [self addChild:haveSunSprite2];
}

- (void)setPageIndex:(int)pageIndex
{
    if (nowPageIndex==pageIndex) return;
    
    nowPageIndex=pageIndex;
    [nowLayer onExitLayer];
    
    nowLayer=[self.playLayer objectAtIndex:pageIndex];
    [self reflushSunNum];
    [nowLayer onEnterLayer];
    
}

- (void)onPageMoved:(CCScrollLayer *)scrollLayer
{
	[self setPageIndex:scrollLayer.currentScreen - 1];
}

-(void)onClick:(CCScrollLayer *)scrollLayer
{
    [nowLayer onClick];
}

-(ChooseScrollLayer*) getYlfcLayer
{
    if ([self.playLayer count]<1)
    {
        [self.playLayer addObject:[[Ylfc alloc] init]];
    }
    
    return [self.playLayer objectAtIndex:0];
}


-(ChooseScrollLayer*) getByymLayer
{
    if ([self.playLayer count]<2)
    {
        [self.playLayer addObject:[[Byym alloc] init]];
    }
    return [self.playLayer objectAtIndex:1];
}

-(ChooseScrollLayer*) getMwtjLayer
{
    if ([self.playLayer count]<3)
    {
        [self.playLayer addObject:[[Mwtj alloc] init]];
    }
    return [self.playLayer objectAtIndex:2];
}

-(ChooseScrollLayer*) getXbtwLayer
{
    if ([self.playLayer count]<4)
    {
        [self.playLayer addObject:[[Xbtw alloc] init]];
    }
    return [self.playLayer objectAtIndex:3];
}



-(void) initScrollLayer
{
    self.playLayer=[NSMutableArray arrayWithCapacity:4];
    nowLayer=[self getYlfcLayer];
    
    [self getByymLayer];
    
    [self getMwtjLayer];
    
    [self getXbtwLayer];
    
    
    
    scroller = [[CCScrollLayer alloc] initWithLayers:self.playLayer  widthOffset: 0];
    [self addChild:scroller];
	// page moved delegate
	{
        NSInvocation* invocationMove ;
        NSMethodSignature* signatureMove;
        
	    signatureMove =[[self class] instanceMethodSignatureForSelector:@selector(onPageMoved:)];
        
        invocationMove = [NSInvocation invocationWithMethodSignature:signatureMove];
        
        [invocationMove setTarget:self];
        [invocationMove setSelector:@selector(onPageMoved:)];
        
        scroller.onPageMoved = invocationMove;
        
        NSInvocation* invocationClick;
        NSMethodSignature* signatureClick;
        signatureClick=[[self class] instanceMethodSignatureForSelector:@selector(onClick:)];
        invocationClick = [NSInvocation invocationWithMethodSignature:signatureClick];
        [invocationClick setTarget:self];
        [invocationClick setSelector:@selector(onClick:)];
        
        scroller.onClick=invocationClick;

	}


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

-(void) startInit
{
    CCSprite* background=[CCSprite spriteWithFile:@"Background.png"];
    background.position=CGPointMake(screenSize.width/2,screenSize.height/2);
    [self addChild:background];
    
    nowPageIndex=0;
    
    [self initScrollLayer];
    [nowLayer onEnterLayer];
    
    [self addSun];
    [self addBack];
    [self addHelp];
}

-(void) preloadMusic
{
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"选择关卡.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"场景一.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"场景二.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"场景三.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"场景四.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"双击任意位置选择进入场景.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"左右滑屏左右上角.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"太阳总数.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"已获得太阳数量.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"已获得所有太阳.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"1.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"2.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"3.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"4.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"5.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"6.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"7.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"8.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"9.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"10.mp3"];
}

-(void) callPlayChooseSceneEffect:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        chooseScene=[[SimpleAudioEngine sharedEngine] playEffect:@"选择关卡.mp3"];
    }
}

-(void) playChooseSceneEffect
{
    [self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:0.2] two:[CCCallFunc actionWithTarget:self selector:@selector(callPlayChooseSceneEffect:)]]];
}

-(id) init
{
    if (self=[super init])
    {
        screenSize=[[CCDirector sharedDirector] winSize];
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

-(void) pushToHelpScene:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    }
    
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[HelpScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}



-(void) onEnter
{
    [super onEnter];
    [self startInit];
    [self reflushSunNum];
    [self playChooseSceneEffect];
}

-(void) onExit
{
    [nowLayer onExitLayer];
    [self removeAllChildrenWithCleanup:true];
    [super onExit];
}



@end
