//
//  CCScrollLayer.m
//  Museum
//
//  Created by GParvaneh on 29/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CCScrollLayer.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"


@implementation CCScrollLayer

@synthesize currentScreen;
@synthesize onPageMoved;
@synthesize onClick;
@synthesize touchPoint=_touchPoint;
@synthesize touchCount=_touchCount;

-(id) initWithLayers:(NSMutableArray *)layers widthOffset: (int) widthOffset
{
	
	if ( (self = [super init]) )
	{
		
		// Make sure the layer accepts touches
		//[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

		
		// Set up the starting variables
		if(!widthOffset){
			widthOffset = 0;
		}	
		currentScreen = 1;
		
		// offset added to show preview of next/previous screens
		screenWidth = [[CCDirector sharedDirector] winSize].width - widthOffset;
		screenHeight = [[CCDirector sharedDirector] winSize].height;
        
		// Loop through the array and add the screens
		int i = 0;
		for (CCLayerColor *l in layers)
		{
            int offset=(screenWidth-l.contentSize.width)/4;
          //  l.position=ccp(i*l.contentSize.width+offset*(2+i),screenHeight/2-l.contentSize.height/2);
            l.position=ccp(i*l.contentSize.width+offset*(2+i),screenHeight-178-484);

			[self addChild:l];
			i=i+1;
            
            scrollWidth=l.contentSize.width+offset;
            scrollHeight=484;
		}
		
		// Setup a count of the available screens
		totalScreens = i;
	}

	return self;
	
}

- (void) onClick:(id)sender
{
    if (self.onClick!=nil)
    {
        [self.onClick setArgument:&self atIndex:2];
        [self.onClick invoke];
    }
        
}

- (void) onPageMoved:(id)sender
{
	if (self.onPageMoved != nil)
	{
		[self.onPageMoved setArgument:&self atIndex:2];
		[self.onPageMoved invoke];
	}
}

-(void) moveToPage:(int)page
{
	id changePage = [CCEaseBounce actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(-((page-1)*scrollWidth),0)]];
	id actions = [CCSequence actions:
				  changePage,
				  [CCCallFunc actionWithTarget:self selector:@selector(onPageMoved:)],
				  nil];
	
	[self runAction:actions];
	currentScreen = page;
}

-(void) moveToNextPage
{
	id changePage = [CCEaseBounce actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(-(((currentScreen+1)-1)*scrollWidth),0)]];
	id actions = [CCSequence actions:
				  changePage,
				  [CCCallFunc actionWithTarget:self selector:@selector(onPageMoved:)],
				  nil];
	
	[self runAction:actions];
	currentScreen = currentScreen+1;
}

-(void) moveToPreviousPage
{
	id changePage = [CCEaseBounce actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(-(((currentScreen-1)-1)*scrollWidth),0)]];
	id actions = [CCSequence actions:
				  changePage,
				  [CCCallFunc actionWithTarget:self selector:@selector(onPageMoved:)],
				  nil];
	
	[self runAction:actions];
	currentScreen = currentScreen-1;
}

- (void)onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	startSwipe = touchPoint.x;
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	self.position = ccp((-(currentScreen-1)*scrollWidth)+(touchPoint.x-startSwipe),0);
	
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if ([touch tapCount]==2 || [touch tapCount]==1)
    {
        self.touchCount=[touch tapCount];
        if (272<touchPoint.x && touchPoint.x<272+478 && 178<touchPoint.y && touchPoint.y<178+478)
        {
            [self runAction:[CCCallFunc actionWithTarget:self selector:@selector(onClick:)]];
        }
    }
    else
    {
        int newX = touchPoint.x;
	
        if ( (newX - startSwipe) < -100 && (currentScreen+1) <= totalScreens )
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"滑屏音.mp3"];
            [self moveToNextPage];
        }
        else if ( (newX - startSwipe) > 100 && (currentScreen-1) > 0 )
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"滑屏音.mp3"];
            [self moveToPreviousPage];
        }
        else
        {
            [self moveToPage:currentScreen];
        }
    }
	
}

- (void) dealloc
{
	[super dealloc];
}

@end
