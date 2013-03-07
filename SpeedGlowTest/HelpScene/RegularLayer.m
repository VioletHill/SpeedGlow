//
//  RegularLayer.m
//  SpeedGlow
//
//  Created by 邱峰 on 13-1-1.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "RegularLayer.h"


@implementation RegularLayer
{
    CGSize layerSize;
}

-(id) init
{
    if ([super init]!=nil)
    {
        [self setContentSize:CGSizeMake(478, 484)];
        layerSize=[self contentSize];
//        CCSprite* sprite=[CCSprite spriteWithFile:@"MusicEffictLayer.png"];
//        sprite.position=CGPointMake(layerSize.width/2,layerSize.height/2);
//        
//       [self addChild:sprite];
        
        //frame
        CCSprite* frame=[CCSprite spriteWithFile:@"FrameLayer.png"];
        frame.position=ccp(layerSize.width/2,layerSize.height/2);
        [self addChild:frame];

    }
    return self;
}

-(void) nextOrder
{
    NSLog(@"3");
}

-(void) lastOrder
{
    
}

-(void) onEnterLayer
{
    NSLog(@"enter3");
}

-(void) onExitLayer
{
    NSLog(@"exit3");
}

@end
