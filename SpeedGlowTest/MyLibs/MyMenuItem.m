//
//  MyMenuItem.m
//  SpeedGlow
//
//  Created by VioletHill on 13-4-2.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "MyMenuItem.h"


@implementation MyMenuItem
{
}



@synthesize doubleClick=doubleClick;
@synthesize singleClick=singleClick;
@synthesize touchBegin=touchBegin;
@synthesize touchEnd=touchEnd;

@synthesize isEnabled=isEnabled_;

@synthesize normalImage=normalImage_, selectedImage=selectedImage_;



+(MyMenuItem*) myMenuItemWithNormalFile:(NSString*)normalFileName selectFile:(NSString*)selectFileName target:(id)t singleClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun
{
    if (t==nil)
    {
        NSLog(@"target is nil");
        return nil;
    }
    
    MyMenuItem* myMenuItem=[MyMenuItem node];
    [myMenuItem initWithNormalImage:normalFileName selectedImage:selectFileName];
    if (singleClickFun!=nil)
    {
        NSMethodSignature* singleClickSignature=[[t class] instanceMethodSignatureForSelector:singleClickFun];
        NSInvocation* singleClickInvocation=[NSInvocation invocationWithMethodSignature:singleClickSignature];
        [singleClickInvocation setTarget:t];
        [singleClickInvocation setSelector:singleClickFun];
        myMenuItem.singleClick=singleClickInvocation;
    }
    
    if (doubleClickFun!=nil)
    {
        NSMethodSignature* doubleClickSignature=[[t class] instanceMethodSignatureForSelector:doubleClickFun];
        NSInvocation* doubleClickInvocation=[NSInvocation invocationWithMethodSignature:doubleClickSignature];
        [doubleClickInvocation setTarget:t];
        [doubleClickInvocation setSelector:doubleClickFun];
        myMenuItem.doubleClick=doubleClickInvocation;
    }
    
    if (touchBeginFun!=nil)
    {
        NSMethodSignature* touchBeginSignature=[[t class] instanceMethodSignatureForSelector:touchBeginFun];
        NSInvocation* touchBeginInvocation=[NSInvocation invocationWithMethodSignature:touchBeginSignature];
        [touchBeginInvocation setTarget:t];
        [touchBeginInvocation setSelector:touchBeginFun];
        myMenuItem.touchBegin=touchBeginInvocation;
    }
    
    if (touchEndFun!=nil)
    {
        
        NSMethodSignature* touchEndSignature=[[t class] instanceMethodSignatureForSelector:touchEndFun];
        NSInvocation* touchEndInvocation=[NSInvocation invocationWithMethodSignature:touchEndSignature];
        [touchEndInvocation setTarget:t];
        [touchEndInvocation setSelector:touchEndFun];
        myMenuItem.touchEnd=touchEndInvocation;
    }
    return myMenuItem;
}

+(MyMenuItem*) myMenuItemWithNormalFile:(NSString *)normalFileName selectFile:(NSString *)selectFileName target:(id)t singleClick:(SEL)singleClickFun
{
    return [MyMenuItem myMenuItemWithNormalFile:normalFileName selectFile:selectFileName target:t singleClick:singleClickFun doubleClick:nil touchBegin:nil touchEnd:nil];
}

+(MyMenuItem*) myMenuItemWithNormalFile:(NSString *)normalFileName selectFile:(NSString *)selectFileName target:(id)t singleClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun
{
    return [MyMenuItem myMenuItemWithNormalFile:normalFileName selectFile:selectFileName target:t singleClick:singleClickFun doubleClick:doubleClickFun touchBegin:nil touchEnd:nil];
}

+(MyMenuItem*) myMenuItemWithNormalFile:(NSString *)normalFileName selectFile:(NSString *)selectFileName target:(id)t touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun
{
    return [MyMenuItem myMenuItemWithNormalFile:normalFileName selectFile:selectFileName target:t singleClick:nil doubleClick:nil touchBegin:touchBeginFun touchEnd:touchEndFun];
}

#pragma mark no select sprite

+(MyMenuItem*) myMenuItemWithFile:(NSString *)fileName target:(id)t singClick:(SEL)singleClickFun
{
    return [MyMenuItem myMenuItemWithNormalFile:fileName selectFile:nil target:t singleClick:singleClickFun doubleClick:nil touchBegin:nil touchEnd:nil];
}

+(MyMenuItem*) myMenuItemWithFile:(NSString *)fileName target:(id)t singClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun
{
    return [MyMenuItem myMenuItemWithNormalFile:fileName selectFile:nil target:t singleClick:singleClickFun doubleClick:doubleClickFun touchBegin:nil touchEnd:nil];
}

+(MyMenuItem*) myMenuItemWithFile:(NSString *)fileName target:(id)t touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun
{
    return [MyMenuItem myMenuItemWithNormalFile:fileName selectFile:nil target:t singleClick:nil doubleClick:nil touchBegin:touchBeginFun touchEnd:touchEndFun];
}

+(MyMenuItem*) myMenuItemWithFile:(NSString *)fileName target:(id)t singClick:(SEL)singleClickFun doubleClick:(SEL)doublleClickFun touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun
{
    return [MyMenuItem myMenuItemWithNormalFile:fileName selectFile:nil target:t singleClick:singleClickFun doubleClick:doublleClickFun touchBegin:touchBeginFun touchEnd:touchEndFun];
}



-(void) singleClickFun
{
    if (self.singleClick!=nil)
    {
        [self.singleClick setArgument:&self atIndex:2];
        [self.singleClick invoke];
    }
}

-(void) doubleClickFun
{
    if (self.doubleClick!=nil)
    {
        [self.doubleClick setArgument:&self atIndex:2];
        [self.doubleClick invoke];
    }
}

-(void) touchBeginFun
{
    if (self.touchBegin!=nil)
    {
        [self.touchBegin setArgument:&self atIndex:2];
        [self.touchBegin invoke];
    }
}

-(void) touchEndFun
{
    if (self.touchEnd!=nil)
    {
        [self.touchEnd setArgument:&self atIndex:2];
        [self.touchEnd invoke];
    }
}

-(id) init
{
    if (self=[super init])
    {
        
    }
    return self;
}

-(void) initWithNormalImage:(NSString*)normalI selectedImage:(NSString*)selectedI
{
    if( selectedI )
    {
        self.selectedImage = [CCSprite spriteWithFile:selectedI];
    }

    self.normalImage = [CCSprite spriteWithFile:normalI];
    
    CGSize s=[[CCDirector sharedDirector] winSize];
    anchorPoint_ = ccp(0.5f, 0.5f);
    position_=ccp(s.width/2,s.height/2);
    self.isEnabled = YES;
    isSelected_ = NO;
    [self setContentSize: [normalImage_ contentSize]];
    [self unselected];
}

-(void) setNormalImage:(CCSprite*)image
{
	if( image != normalImage_ ) {
		[self removeChild:normalImage_ cleanup:YES];
		[self addChild:image];
        
		normalImage_ = image;
        
        [self setContentSize: [normalImage_ contentSize]];
		
		[self updateImagesVisibility];
	}
}

-(void) setSelectedImage:(CCSprite*)image
{
	if( image != selectedImage_ ) {
		[self removeChild:selectedImage_ cleanup:YES];
		[self addChild:image];
        
		selectedImage_ = image;
		
		[self updateImagesVisibility];
	}
}


#pragma mark CCMenuItemSprite - CCRGBAProtocol protocol

-(CGRect) rect
{
	return CGRectMake(self.normalImage.position.x -self.normalImage.contentSize.width*self.anchorPoint.x,
					  self.normalImage.position.y -self.normalImage.contentSize.height*self.anchorPoint.y,
					  self.contentSize.width, self.contentSize.height);
}

-(BOOL) isEnable
{
    return isEnabled_;
}

- (void) setOpacity: (GLubyte)opacity
{
	[normalImage_ setOpacity:opacity];
	[selectedImage_ setOpacity:opacity];
}


-(GLubyte) opacity
{
	return [normalImage_ opacity];
}



-(void) selected
{
	isSelected_=YES;
    
	if( selectedImage_ ) {
		[normalImage_ setVisible:NO];
		[selectedImage_ setVisible:YES];
        
	} else { // there is not selected image
		[normalImage_ setVisible:YES];
		[selectedImage_ setVisible:NO];
	}
}

-(void) unselected
{
    isSelected_ = NO;
    
	[normalImage_ setVisible:YES];
	[selectedImage_ setVisible:NO];
}

-(void) setIsEnabled:(BOOL)enabled
{
	if( isEnabled_ != enabled ) {
        isEnabled_ = enabled;
		[self updateImagesVisibility];
	}
}


// Helper
-(void) updateImagesVisibility
{
	if( isEnabled_ )
    {
		[normalImage_ setVisible:YES];
		[selectedImage_ setVisible:NO];
	}
	else
    {
        [normalImage_ setVisible:YES];
        [selectedImage_ setVisible:NO];
	}
}



-(BOOL) itemForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
	CCSprite* item=self.normalImage;

		if ( [item visible] && [self isEnabled] )
        {
			CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [self rect];
			r.origin = CGPointZero;
            
			if( CGRectContainsPoint( r, local ) )
				return true;
		}
	return false;
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    isTouchBegin=false;
    if( state_ != kCCMenuStateWaiting || !visible_ || !self.isEnabled)
		return NO;
    
	if (![normalImage_ visible] || ![self isEnable]) return NO;

	if( [self itemForTouch:touch])
    {
        [self selected];

		state_ = kCCMenuStateTrackingTouch;
		return YES;
	}
	return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchEnded] -- invalid state");
	[self unselected];
    if  (self.touchEnd!=nil)
    {
        [self touchEndFun];
    }
    
    if ([touch tapCount]>=2)
    {
        if (self.doubleClick!=nil)
        {
            [self doubleClickFun];
        }
    }
    else if ([touch tapCount]==1)
    {
        if (self.singleClick!=nil)
        {
            [self singleClickFun];
        }
    }
	state_ = kCCMenuStateWaiting;
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"touch Cancel");
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchCancelled] -- invalid state");
    
	[self unselected];
    
	state_ = kCCMenuStateWaiting;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchMoved] -- invalid state");
    
	if (state_!=kCCMenuStateWaiting)
    {
		[self selected];
        
    
        if (self.touchBegin!=nil && !isTouchBegin)
        {
            isTouchBegin=true;
            [self touchBeginFun];
        }
	}
}

-(void) onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:-128 swallowsTouches:YES];
}

-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

@end
