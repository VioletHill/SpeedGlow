//
//  PlayScene.m
//  SpeedGlowTest
//
//  Created by 邱峰 on 13-1-9.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "PlayScene.h"
#import "PlayScrollLayer.h"
#import "CCScrollLayer.h"
#import "Ylfc.h"
#import "Byym.h"
#import "HelpScene.h"
#import "Xbtw.h"
#import "Mwtj.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"

@implementation PlayScene
{
    CGSize screenSize;
    int nowPageIndex;
    PlayScrollLayer* nowLayer;
    CCScrollLayer *scroller ;
    
    ALuint chooseScene;
}

@synthesize playLayer=_playLayer;
@synthesize onPageMoved=_onPageMoved;

+(CCScene *) scene
{
    
	CCScene *scene = [CCScene node];
	PlayScene *layer = [PlayScene node];
	[scene addChild: layer];
	return scene;
    
}

- (void)setPageIndex:(int)pageIndex
{
    if (nowPageIndex==pageIndex) return;
    nowPageIndex=pageIndex;
    [nowLayer onExitLayer];
    nowLayer=[self.playLayer objectAtIndex:pageIndex];
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

-(PlayScrollLayer*) getYlfcLayer
{
    if ([self.playLayer count]<1)
    {
        [self.playLayer addObject:[[Ylfc alloc] init]];
    }
    
    return [self.playLayer objectAtIndex:0];
}


-(PlayScrollLayer*) getByymLayer
{
    if ([self.playLayer count]<2)
    {
        [self.playLayer addObject:[[Byym alloc] init]];
    }
    return [self.playLayer objectAtIndex:1];
}

-(PlayScrollLayer*) getMwtjLayer
{
    if ([self.playLayer count]<3)
    {
        [self.playLayer addObject:[[Mwtj alloc] init]];
    }
    return [self.playLayer objectAtIndex:2];
}

-(PlayScrollLayer*) getXbtwLayer
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

-(void) startInit
{
    CCSprite* background=[CCSprite spriteWithFile:@"Background.png"];
    background.position=CGPointMake(screenSize.width/2,screenSize.height/2);
    [self addChild:background];
    
    nowPageIndex=0;
    
    [self initScrollLayer];
    [nowLayer onEnterLayer];
    
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
    [self playChooseSceneEffect];
}

-(void) onExit
{
    [nowLayer onExitLayer];
    [self removeAllChildrenWithCleanup:true];
    [super onExit];
}



@end
