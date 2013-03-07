//
//  Setting.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-28.
//  Copyright (c) 2013年 VioletHill. All rights reserved.
//

#import "Setting.h"

@implementation Setting
@synthesize isNeedBackgroundMusic=_isNeedBackgroundMusic;
@synthesize isNeedEffect=_isNeedEffect;

static Setting* setting;

+(Setting*) sharedSetting
{
    if (setting==nil)
    {
        setting=[[Setting alloc] init];
    }
    return setting;
}


-(id) init
{
    _isNeedEffect=true;
    return self;
}


@end
