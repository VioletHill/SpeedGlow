//
//  ChooseLevel.h
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-25.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface YlfcChooseLevelScene : CCLayer
{
    
}

@property (nonatomic, retain) NSInvocation* onPageMoved;
@property (strong,nonatomic) NSMutableArray* level;


+(CCScene*) scene;


@end
