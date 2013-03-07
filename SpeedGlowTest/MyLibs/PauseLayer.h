//
//  PauseLayer.h
//  SpeedGlow
//
//  Created by VioletHill on 13-3-7.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface PauseLayerProtocol: CCNode

-(void)pauseLayerDidPause;
-(void)pauseLayerDidUnpause;

@end

@interface PauseLayer : CCLayerColor
{
    PauseLayerProtocol * delegate;
}

@property (nonatomic,assign)PauseLayerProtocol * delegate;
+ (id) layerWithColor:(ccColor4B)color delegate:(PauseLayerProtocol *)_delegate;
- (id) initWithColor:(ccColor4B)c delegate:(PauseLayerProtocol *)_delegate;
-(void)pauseDelegate;

@end

