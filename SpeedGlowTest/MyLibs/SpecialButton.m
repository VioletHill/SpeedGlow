//
//  SpecialButton.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-5.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "SpecialButton.h"


@implementation SpecialButton
{
    NSString* normalName;
    NSString* selectName;
}

@synthesize doubleClick;
@synthesize singleClick;
@synthesize touchBegin;
@synthesize touchEnd;


+(id) menuWithItems: (CCMenuItem*) item vaList: (va_list) args
{
	NSMutableArray *array = nil;
	if( item ) {
		array = [NSMutableArray arrayWithObject:item];
		CCMenuItem *i = va_arg(args, CCMenuItem*);
		while(i) {
			[array addObject:i];
			i = va_arg(args, CCMenuItem*);
		}
	}
	
	return [[[self alloc] initWithArray:array] autorelease];
}

+(SpecialButton*) specialButtonWithNormalFile:(NSString*)normalFileName selectFile:(NSString*)selectFileName target:(id)t singleClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun
{
    if (t==nil)
    {
        NSLog(@"target is nil");
        return nil;
    }

   // SpecialButton* specialButton=[SpecialButton spriteWithFile:normalFileName];
    SpecialButton* specialButton=[SpecialButton menuWithItems:nil];
    specialButton->normalName=normalFileName;
    specialButton->selectName=selectFileName;
    if (selectFileName!=nil) selectFileName=[CCSprite spriteWithFile:selectFileName];
    
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:specialButton priority:0 swallowsTouches:YES];

    if (singleClickFun!=nil)
    {
        NSMethodSignature* singleClickSignature=[[t class] instanceMethodSignatureForSelector:singleClickFun];
        NSInvocation* singleClickInvocation=[NSInvocation invocationWithMethodSignature:singleClickSignature];
        [singleClickInvocation setTarget:t];
        [singleClickInvocation setSelector:singleClickFun];
        specialButton.singleClick=singleClickInvocation;
    }
    
    if (doubleClickFun!=nil)
    {
        NSMethodSignature* doubleClickSignature=[[t class] instanceMethodSignatureForSelector:doubleClickFun];
        NSInvocation* doubleClickInvocation=[NSInvocation invocationWithMethodSignature:doubleClickSignature];
        [doubleClickInvocation setTarget:t];
        [doubleClickInvocation setSelector:doubleClickFun];
        specialButton.doubleClick=doubleClickInvocation;
    }
    
    if (touchBeginFun!=nil)
    {
        NSMethodSignature* touchBeginSignature=[[t class] instanceMethodSignatureForSelector:touchBeginFun];
        NSInvocation* touchBeginInvocation=[NSInvocation invocationWithMethodSignature:touchBeginSignature];
        [touchBeginInvocation setTarget:t];
        [touchBeginInvocation setSelector:touchBeginFun];
        specialButton.touchBegin=touchBeginInvocation;
    }
    
    if (touchEndFun!=nil)
    {

        NSMethodSignature* touchEndSignature=[[t class] instanceMethodSignatureForSelector:touchEndFun];
        NSInvocation* touchEndInvocation=[NSInvocation invocationWithMethodSignature:touchEndSignature];
        [touchEndInvocation setTarget:t];
        [touchEndInvocation setSelector:touchEndFun];
        specialButton.touchEnd=touchEndInvocation;
    }
    
    
    return specialButton;
}

+(SpecialButton*) specialButtonWithNormalFile:(NSString *)normalFileName selectFile:(NSString *)selectFileName target:(id)t singleClick:(SEL)singleClickFun
{
    return [SpecialButton specialButtonWithNormalFile:normalFileName selectFile:selectFileName target:t singleClick:singleClickFun doubleClick:nil touchBegin:nil touchEnd:nil];
}

+(SpecialButton*) specialButtonWithNormalFile:(NSString *)normalFileName selectFile:(NSString *)selectFileName target:(id)t singleClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun
{
    return [SpecialButton specialButtonWithNormalFile:normalFileName selectFile:selectFileName target:t singleClick:singleClickFun doubleClick:doubleClickFun touchBegin:nil touchEnd:nil];
}

+(SpecialButton*) specialButtonWithNormalFile:(NSString *)normalFileName selectFile:(NSString *)selectFileName target:(id)t touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun
{
    return [SpecialButton specialButtonWithNormalFile:normalFileName selectFile:selectFileName target:t singleClick:nil doubleClick:nil touchBegin:touchBeginFun touchEnd:touchEndFun];
}

#pragma mark no select sprite

+(SpecialButton*) specialButtonWithFile:(NSString *)fileName target:(id)t singClick:(SEL)singleClickFun
{
    return [SpecialButton specialButtonWithNormalFile:fileName selectFile:nil target:t singleClick:singleClickFun doubleClick:nil touchBegin:nil touchEnd:nil];
}

+(SpecialButton*) specialButtonWithFile:(NSString *)fileName target:(id)t singClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun
{
    return [SpecialButton specialButtonWithNormalFile:fileName selectFile:nil target:t singleClick:singleClickFun doubleClick:doubleClickFun touchBegin:nil touchEnd:nil];
}

+(SpecialButton*) specialButtonWithFile:(NSString *)fileName target:(id)t touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun
{
    return [SpecialButton specialButtonWithNormalFile:fileName selectFile:nil target:t singleClick:nil doubleClick:nil touchBegin:touchBeginFun touchEnd:touchEndFun];
}

+(SpecialButton*) specialButtonWithFile:(NSString *)fileName target:(id)t singClick:(SEL)singleClickFun doubleClick:(SEL)doublleClickFun touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun
{
    return [SpecialButton specialButtonWithNormalFile:fileName selectFile:nil target:t singleClick:singleClickFun doubleClick:doublleClickFun touchBegin:touchBeginFun touchEnd:touchEndFun];
}

-(void) singleClickFun
{
    NSLog(@"singleClick");
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

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"touchBegin");
    if (self->selectName!=nil)   [self touchBeginFun];
    if (self.touchBegin!=nil)
    {
        [self onSelect];
    }
    
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([touch tapCount]==1 && self.singleClick!=nil)
    {
        [self singleClickFun];
    }
    else if ([touch tapCount]==2 && self.doubleClick!=nil)
    {
        [self doubleClickFun];
    }
    
    if (self.touchEnd!=nil)
    {
        [self touchEndFun];
    }
    if (self->selectName!=nil)  [self cancelSelect];
}

-(void) onSelect
{
   // [self setTexture:[[CCTextureCache sharedTextureCache] addImage:self->selectName]];
}

-(void) cancelSelect
{
 //   [self setTexture:[[CCTextureCache sharedTextureCache] addImage:self->normalName]];

}

-(void) onExit
{
  //  [[CCTouchDispatcher sharedDispatche] removeDelegate:self];
	[super onExit];
}

@end
