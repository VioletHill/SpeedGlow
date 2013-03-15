//
//  ChooseLevelScene.h
//  SpeedGlow
//
//  Created by VioletHill on 13-3-14.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Obstacle.h"

@interface ChooseLevelScene : CCLayer
{
    CGSize screenSize;
    CGSize layerSize;
    int nowPageIndex;
}

-(void) reflushSunNumAtScene:(GameScene)gameScene andTotSun:(int)totSun;
-(void) addBack;
-(void) addHelp;
-(void) addSun;

@end
