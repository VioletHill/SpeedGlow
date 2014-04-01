//
//  Setting.h
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-28.
//  Copyright (c) 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject

@property (nonatomic,readwrite) BOOL isNeedBackgroundMusic;
@property (nonatomic,readwrite) BOOL isNeedEffect;


+(Setting*) sharedSetting ;
@end
