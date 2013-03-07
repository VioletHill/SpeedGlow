//
//  HelpScrollLayer.h
//  SpeedGlow
//
//  Created by 邱峰 on 13-1-1.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HelpScrollLayer : CCLayerColor
{
    
}

-(void) onEnterLayer;
-(void) onExitLayer;
-(void) nextOrder;
-(void) lastOrder;
@end
