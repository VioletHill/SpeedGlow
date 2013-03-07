//
//  ChooseLevel.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-25.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "ChooseLevel.h"
#import "CCScrollLayer.h"
#import "EasyLevelLayer.h"
#import "MidiumLevelLayer.h"
#import "HardLevelLayer.h"
#import "HelpScene.h"

@implementation ChooseLevel
{
    CGSize screenSize;
    ChooseLevelScrollLayer* nowLayer;
    int nowPageIndex;
}
@synthesize level=_level;
@synthesize onPageMoved=_onPageMoved;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ChooseLevel *layer = [ChooseLevel node];
	[scene addChild: layer];
	return scene;
    
}

- (void)setPageIndex:(int)pageIndex
{
    if (nowPageIndex==pageIndex) return;
    nowPageIndex=pageIndex;
    [nowLayer onExitLayer];
    nowLayer=[self.level objectAtIndex:pageIndex];
    [nowLayer onEnterLayer];
}

-(void)onClick:(CCScrollLayer *)scrollLayer
{
    [nowLayer onClick];
}

- (void)onPageMoved:(CCScrollLayer *)scrollLayer
{
	[self setPageIndex:scrollLayer.currentScreen - 1];
}

-(ChooseLevelScrollLayer*) getEasyLevel
{
    if ([self.level count]<1)
    {
        [self.level addObject:[[EasyLevelLayer alloc] init] ];
    }
    return [self.level objectAtIndex:0];
}

-(ChooseLevelScrollLayer*) getMiddleLevel
{
    if ([self.level count]<2)
    {
        [self.level addObject:[[MiddleLevelLayer alloc] init]];
    }
    return [self.level objectAtIndex:1];
}

-(ChooseLevelScrollLayer*) getHardLevel
{
    if ([self.level count]<3)
    {
        [self.level addObject:[[HardLevelLayer alloc] init]];
    }
    return [self.level objectAtIndex:2];
}

-(void) initScrollLayer
{
    self.level=[NSMutableArray arrayWithCapacity:3];
    nowLayer=[self getEasyLevel];
    
    [self getMiddleLevel];
    
    [self getHardLevel];
    
    CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:self.level  widthOffset: 0];
    [self addChild:scroller];
	
	// page moved delegate
	{
		NSMethodSignature* signature =
		[[self class] instanceMethodSignatureForSelector:@selector(onPageMoved:)];
		
		NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
		
		[invocation setTarget:self];
		[invocation setSelector:@selector(onPageMoved:)];
		
		scroller.onPageMoved = invocation;
        
        
      ////on click delegate
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
    nowPageIndex=0;
    
    //background1
    CCSprite* background1=[CCSprite spriteWithFile:@"Background.png"];
    background1.position=ccp(screenSize.width/2,screenSize.height/2);
    [self addChild:background1];
    
    //background2
    CCSprite* backgroud2=[CCSprite spriteWithFile:@"YlfcScrollLayer.png"];
    [backgroud2 setAnchorPoint:ccp(0,0)];
    backgroud2.position=ccp(0,0);
    [self addChild:backgroud2];
    
    [self addBack];
    [self addHelp];
    
    [self initScrollLayer];
}

-(id) init
{
  
    if (self=[super init])
    {
        screenSize=[[CCDirector sharedDirector] winSize];
    }
    return self;
}

-(void) callReturnLastScene:(id)pSender
{
    [[CCDirector sharedDirector] popScene];
}

-(void) returnLastScene:(id)pSender
{
    CCAction* action=[CCSequence actions:[CCScaleTo actionWithDuration:0.1 scale:0.25],[CCScaleTo actionWithDuration:0.05 scale:1],[CCCallFunc actionWithTarget:self selector:@selector(callReturnLastScene:)],
                      nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) pushToHelpScene:(id)pSender
{
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[HelpScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) onEnter
{
    [super onEnter];
    [self startInit];
}

-(void) onExit
{
    [self removeAllChildrenWithCleanup:true];
    [super onExit];
}

@end
