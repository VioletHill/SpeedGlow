//
//  MwtjHardLevelLayer.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-14.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "MwtjHardLayer.h"
#import "UserData.h"

@implementation MwtjHardLayer

-(id) init
{
    if (self=[super init])
    {
        [self setContentSize:CGSizeMake(478,484)];
        layerSize=[self contentSize];
        
        //frame
        CCSprite* frame=[CCSprite spriteWithFile:@"FrameLayer.png"];
        frame.position=ccp(layerSize.width/2,layerSize.height/2);
        [self addChild:frame];
        
        //title
        CCSprite* title=[CCSprite spriteWithFile:@"Hard.png"];
        title.position=ccp(layerSize.width/2,layerSize.height-title.contentSize.height/2-22);
        [self addChild:title];
    }
    return self;
}


-(void) onEnterLayer
{
    [Obstacle sharedObstacle].gameLevel=kHARD;
    [super onEnterLayer];
}

-(void) onExitLayer
{
    [super onExitLayer];
    
}

-(void) onClick
{
    [self startGame];
}

@end
