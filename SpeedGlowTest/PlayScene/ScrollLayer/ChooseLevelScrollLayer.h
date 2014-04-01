//
//  ChooseLevel.h
//  SpeedGlow
//
//  Created by VioletHill on 13-3-12.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface ChooseLevelScrollLayer: CCLayerColor
{
    CGSize layerSize;
}


-(void) onEnterLayer;
-(void) onExitLayer;
-(void) onClick;

-(void) lockLevel;
-(void) unlockLevel;
-(void) startGame;

@end
