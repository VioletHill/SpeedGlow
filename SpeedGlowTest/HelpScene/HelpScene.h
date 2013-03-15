//
//  HelpLayer.h
//  SpeedGlow
//
//  Created by 邱峰 on 12-12-31.
//  Copyright 2012年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HelpScene : CCLayer
{
}

+(CCScene *) scene;

@property (nonatomic, strong) NSMutableArray* helpLayer;
@property (nonatomic, retain) NSInvocation *onPageMoved;

@end
