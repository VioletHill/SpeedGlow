//
//  HelpLayer.m
//  SpeedGlow
//
//  Created by 邱峰 on 12-12-31.
//  Copyright 2012年 VioletHill. All rights reserved.
//

#import "HelpScene.h"
#import "CCScrollLayer.h"
#import "EffectLayer.h"
#import "OperateLayer.h"
#import "RegularLayer.h"
#import "Setting.h"
#import "SimpleAudioEngine.h"

@implementation HelpScene
{
    CGSize screenSize;
    CCSprite* background;
    
    int nowPageIndex;
    HelpScrollLayer* nowLayer;
}

@synthesize onPageMoved=_onPageMoved;
@synthesize helpLayer=_helpLayer;

+(CCScene *) scene
{

	CCScene *scene = [CCScene node];
	HelpScene *layer = [HelpScene node];
	[scene addChild: layer];
	return scene;
    
}


- (void)setPageIndex:(int)pageIndex
{
    if (nowPageIndex==pageIndex) return;
    nowPageIndex=pageIndex;
    [nowLayer onExitLayer];
    nowLayer=[self.helpLayer objectAtIndex:pageIndex];
    [nowLayer onEnterLayer];
}

- (void)onPageMoved:(CCScrollLayer *)scrollLayer
{
	[self setPageIndex:scrollLayer.currentScreen - 1];
}

-(HelpScrollLayer*) getMusicEffictLayer
{
    if ([self.helpLayer count]<1)
    {
        [self.helpLayer addObject:[[EffectLayer alloc] init] ];
    }
    
    return [self.helpLayer objectAtIndex:0];
}

-(HelpScrollLayer*) getOperatorLayer
{
    if ([self.helpLayer count]<2)
    {
        [self.helpLayer addObject:[[OperatorLayer alloc] init] ];
    }
    
    return [self.helpLayer objectAtIndex:1];
    
}

-(HelpScrollLayer*) getRegularLayer
{
    if ([self.helpLayer count]<3)
    {
        [self.helpLayer addObject:[[RegularLayer alloc] init] ];
    }
    return [self.helpLayer objectAtIndex:2];
}

- (void)initScrollLayer
{
	self.helpLayer=[NSMutableArray arrayWithCapacity:3];
    
/////////////////////////////////////////effictMusicLayer//////////////////
    
    nowLayer=[self getMusicEffictLayer];
    
/////////////////////////////////////////operatorLayer////////////////////
    
    [self getOperatorLayer];
    
////////////////////////////////////////regularLayer/////////////////////
    
    [self getRegularLayer];
    
///////////////////////////////////////加入到划屏中///////////////////////
	// now create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages)
    
   // self.helpLayer=[NSMutableArray arrayWithObjects:musicEffictayer,operatorLayer,regularLayer,nil];
	CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:self.helpLayer  widthOffset: 0];
	
    
	// finally add the scroller to your scene
	[self addChild:scroller];
	
	// page moved delegate
	{
		NSMethodSignature* signature =
		[[self class] instanceMethodSignatureForSelector:@selector(onPageMoved:)];
		
		NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
		
		[invocation setTarget:self];
		[invocation setSelector:@selector(onPageMoved:)];
		
		scroller.onPageMoved = invocation;
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

-(id) init
{
    nowPageIndex=0;
    if(self=[super init])
    {
        screenSize=[[CCDirector sharedDirector] winSize];
        background=[CCSprite spriteWithFile:@"HelpBackground.png"];
        background.position=CGPointMake(screenSize.width/2,screenSize.height/2);
        [self addChild:background];
        
        [self initScrollLayer];
        
        [self addBack];
        
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
        
        [nowLayer onEnterLayer];
        
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
//    
//    CCAction* action=[CCSequence actions:[CCScaleTo actionWithDuration:0.1 scale:0.25],[CCScaleTo actionWithDuration:0.05 scale:1],[CCCallFunc actionWithTarget:self selector:@selector(callReturnLastScene:)],
//                      nil];
//    [[[CCDirector sharedDirector] runningScene] runAction:action];
    [[CCDirector sharedDirector] popScene];
}

-(void) nextOrder:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    }
    [nowLayer nextOrder];
}

-(void) lastOrder:(id)pSender
{
    if ([Setting sharedSetting].isNeedEffect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    }
    [nowLayer lastOrder];
}

-(void) onExit
{
    [nowLayer onExitLayer];
    [self stopAllActions];
    [self removeAllChildrenWithCleanup:true];
    [super onExit];
}


@end
