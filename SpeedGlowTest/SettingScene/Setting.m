//
//  Setting.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-28.
//  Copyright (c) 2013年 VioletHill. All rights reserved.
//

#import "Setting.h"
#import "UserData.h"

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
    self.isNeedBackgroundMusic=[[UserData sharedUserData] isNeedBg];
    self.isNeedEffect=[[UserData sharedUserData] isNeedEffect];
    return self;
}


@end
