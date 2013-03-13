//
//  PlayLayer.h
//  SpeedGlowTest
//
//  Created by 邱峰 on 13-1-9.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "Setting.h"

@interface ChooseSceneScrollLayer : CCLayerColor
{
    ALuint nowEffect;
}

-(void) onEnterLayer;
-(void) onExitLayer;
-(void) onClick;

@end
