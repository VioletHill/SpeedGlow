//
//  ByymChooseLevelScene.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-13.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "ByymChooseLevelScene.h"
#import "CCScrollLayer.h"
#import "ByymEasyLayer.h"
#import "ByymMediumLayer.h"
#import "ByymHardLayer.h"
#import "UserData.h"


@implementation ByymChooseLevelScene
{
    ChooseLevelScrollLayer* nowLayer;
    CCScrollLayer *scroller ;
}
@synthesize level=_level;
@synthesize onPageMoved=_onPageMoved;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ByymChooseLevelScene *layer = [ByymChooseLevelScene node];
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
        [self.level addObject:[[ByymEasyLayer alloc] init] ];
    }
    return [self.level objectAtIndex:0];
}

-(ChooseLevelScrollLayer*) getMiddleLevel
{
    if ([self.level count]<2)
    {
        [self.level addObject:[[ByymMediumLayer alloc] init]];
    }
    return [self.level objectAtIndex:1];
}

-(ChooseLevelScrollLayer*) getHardLevel
{
    if ([self.level count]<3)
    {
        [self.level addObject:[[ByymHardLayer alloc] init]];
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
            [super reflushSunNumAtScene:kBYYM andTotSun:ByymEasySunNum];
            break;
        case 1:
            [super reflushSunNumAtScene:kBYYM andTotSun:ByymMediumSunNum];
            break;
        case 2:
            [super reflushSunNumAtScene:kBYYM andTotSun:ByymHardSunNum];
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
        nowPageIndex=0;
        
        //background1
        CCSprite* background1=[CCSprite spriteWithFile:@"Background.png"];
        background1.position=ccp(screenSize.width/2,screenSize.height/2);
        [self addChild:background1];
        
        //background2
        CCSprite* background2=[CCSprite spriteWithFile:@"ByymScrollLayer.png"];
        [background2 setAnchorPoint:ccp(0,0)];
        background2.position=ccp(0,0);
        [self addChild:background2];
        
        [self addSun];
        [self addBack];
        [self addHelp];
        
        
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

