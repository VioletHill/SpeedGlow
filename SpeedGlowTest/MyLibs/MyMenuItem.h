//
//  MyMenuItem.h
//  SpeedGlow
//
//  Created by VioletHill on 13-3-9.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface MyMenuItem : CCMenuItem
{
    void (^singleBlock_)(id sender);
    void (^doubleBlock_)(id sender);
    void (^touchBeginBlcok_)(id sender);
    void (^touchEndBlock_)(id sender);
}


+(id) itemWithSingBlock:(void(^)(id sender))block;
@end
