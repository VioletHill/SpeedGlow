//
//  HelpScrollLayer.h
//  SpeedGlow
//
//  Created by 邱峰 on 13-1-1.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface HelpScrollLayer : CCLayerColor
{
    ALuint nowEffect;
}

-(void) onEnterLayer;
-(void) onExitLayer;
-(void) nextOrder;
-(void) lastOrder;
@end
