//
//  MwtjChooseLevelScene.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-14.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "MwtjChooseLevelScene.h"
#import "CCScrollLayer.h"
#import "UserData.h"
#import "ChooseLevelScrollLayer.h"
#import "MwtjEasyLayer.h"
#import "MwtjMediumLayer.h"
#import "MwtjHardLayer.h"



@implementation MwtjChooseLevelScene
{
    ChooseLevelScrollLayer* nowLayer;
    CCScrollLayer* scroller;
}
@synthesize level=_level;
@synthesize onPageMoved=_onPageMoved;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MwtjChooseLevelScene *layer = [MwtjChooseLevelScene node];
	[scene addChild: layer];
	return scene;
    
}

- (void)setPageIndex:(int)pageIndex
{
    if (nowPageIndex==pageIndex) return;
    nowPageIndex=pageIndex;
    
    [self reflushSunNum];
    
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
        [self.level addObject:[[MwtjEasyLayer alloc] init] ];
    }
    return [self.level objectAtIndex:0];
}

-(ChooseLevelScrollLayer*) getMiddleLevel
{
    if ([self.level count]<2)
    {
        [self.level addObject:[[MwtjMediumLayer alloc] init]];
    }
    return [self.level objectAtIndex:1];
}

-(ChooseLevelScrollLayer*) getHardLevel
{
    if ([self.level count]<3)
    {
        [self.level addObject:[[MwtjHardLayer alloc] init]];
    }
    return [self.level objectAtIndex:2];
}

-(void) initScrollLayer
{
    self.level=[NSMutableArray arrayWithCapacity:3];
    nowLayer=[self getEasyLevel];
    
    [self getMiddleLevel];
    
    [self getHardLevel];
    
    scroller = [[CCScrollLayer alloc]initWithLayers:self.level  widthOffset: 0];
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

-(void) reflushSunNum
{
    switch (nowPageIndex)
    {
        case 0:
            [super reflushSunNumAtScene:kMWTJ andTotSun:MwtjEasySunNum];
            break;
        case 1:
            [super reflushSunNumAtScene:kMWTJ andTotSun:MwtjMediumSunNum];
            break;
        case 2:
            [super reflushSunNumAtScene:kMWTJ andTotSun:MwtjHardSunNum];
            break;
        default:
            break;
    }
    
}

-(id) init
{
    nowPageIndex=0;
    if (self=[super init])
    {
        //background1
        CCSprite* background1=[CCSprite spriteWithFile:@"Background.png"];
        background1.position=ccp(screenSize.width/2,screenSize.height/2);
        [self addChild:background1];
        
        //background2
        CCSprite* backgroud2=[CCSprite spriteWithFile:@"MwtjScrollLayer.png"];
        [backgroud2 setAnchorPoint:ccp(0,0)];
        backgroud2.position=ccp(0,0);
        [self addChild:backgroud2];
        
        [super addBack];
        [super addHelp];
        [super addSun];
        
        [self initScrollLayer];
    }
    return self;
}


-(void) onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:scroller priority:0 swallowsTouches:YES];
    [self reflushSunNum];
    [nowLayer onEnterLayer];
}

-(void) onExit
{
    [nowLayer onExitLayer];
    [super onExit];
}

@end


