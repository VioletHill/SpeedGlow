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



@implementation Gameover

static GameState _gameState;

+(void) setGameState:(GameState)gameState
{
    _gameState=gameState;
}

+(GameState) getGameState
{
    return _gameState;
}

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
        
        if ([Gameover getGameState]==kSUCCESS)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"欢呼.mp3"];
            [self addSuccess];
        }
        else
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"嘘声.mp3"];
        }
    }
    return self;
}

@end
