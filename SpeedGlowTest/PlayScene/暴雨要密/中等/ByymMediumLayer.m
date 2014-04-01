//
//  ByymMidiumLevelLayer.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-13.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "ByymMediumLayer.h"
#import "Obstacle.h"


@implementation ByymMediumLayer


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
        CCSprite* title=[CCSprite spriteWithFile:@"Medium.png"];
        title.position=ccp(layerSize.width/2,layerSize.height-title.contentSize.height/2-22);
        [self addChild:title];
    }
    return self;
}



-(void) onEnterLayer
{
    [Obstacle sharedObstacle].gameLevel=kMEDIUM;
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
