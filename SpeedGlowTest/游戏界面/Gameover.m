//
//  EasyGameover.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-9.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "Gameover.h"
#import "Car.h"
#import "Obstacle.h"
#import "UserData.h"
#import "SimpleAudioEngine.h"


#define YlfcTime 150

@implementation Gameover

+(CCScene *) scene
{
    
	CCScene *scene = [CCScene node];
	Gameover *layer = [Gameover node];
	[scene addChild: layer];
	return scene;
    
}

-(void) addSuccess
{
    
}

-(void) addFail
{
    
}

-(id) init
{
    if (self=[super init])
    {
        [[UserData sharedUserData] reflushSunAtScene:[Obstacle sharedObstacle].gameScene andLevel:[Obstacle sharedObstacle].gameLevel withSunNumber:[Car sharedCar].sun];
        if ([Car sharedCar].finishGameTime>YlfcTime)    //失败
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"嘘声.mp3"];
        }
        else
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"欢呼.mp3"];
       
            [self addSuccess];
        }
    }
    return self;
}

@end
