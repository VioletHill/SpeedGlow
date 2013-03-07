//
//  PauseLayer.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-7.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "PauseLayer.h"

@implementation PauseLayer

@synthesize delegate;
+ (id) layerWithColor:(ccColor4B)color delegate:(id)_delegate
{
    
    return [[[self alloc] initWithColor:color delegate:_delegate] autorelease];
}

- (id) initWithColor:(ccColor4B)c delegate:(id)_delegate {
    self = [super initWithColor:c];
    if (self != nil) {
        CGSize wins = [[CCDirector sharedDirector] winSize];
        delegate = _delegate;
        [self pauseDelegate];
        CCSprite * background = [CCSprite spriteWithFile:@"pause_background.png"];
        [self addChild:background];
        CCMenuItemImage *resume = [CCMenuItemImage itemFromNormalImage:@"pause_btn_resume.png"              selectedImage:@"pause_btn_resume_dwn.png"             target:self              selector:@selector(doResume:)];
        CCMenu * menu = [CCMenu menuWithItems:resume,nil];        [menu setPosition:ccp(0,0)];
        [resume setPosition:ccp([background boundingBox].size.width/2,[background boundingBox].size.height/2)];
        [background addChild:menu];
        [background setPosition:ccp(wins.width/2,wins.height/2)];
    }
    return self;
}

-(void)pauseDelegate{
    if([delegate respondsToSelector:@selector(pauseLayerDidPause)])        [delegate pauseLayerDidPause];
    [delegate onExit];
    [delegate.parent addChild:self z:10];
}
-(void)doResume: (id)sender{
    [delegate onEnter];
    if([delegate respondsToSelector:@selector(pauseLayerDidUnpause)])
        [delegate pauseLayerDidUnpause];
    [self.parent removeChild:self cleanup:YES];
}
-(void)dealloc{
    [super dealloc];
}

@end
