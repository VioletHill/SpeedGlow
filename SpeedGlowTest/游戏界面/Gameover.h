//
//  EasyGameover.h
//  SpeedGlow
//
//  Created by VioletHill on 13-3-9.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
    kSUCCESS,
    kFAIL,
}GameState;

@interface Gameover : CCLayer

+(CCScene *) scene;

+(void) setGameState:(GameState)gameState;
+(GameState) getGameState;

@end
