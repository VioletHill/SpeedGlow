//
//  MwtjChooseLevelScene.h
//  SpeedGlow
//
//  Created by VioletHill on 13-3-14.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ChooseLevelScene.h"

@interface MwtjChooseLevelScene : ChooseLevelScene
{
    
}

@property (nonatomic, retain) NSInvocation* onPageMoved;
@property (strong,nonatomic) NSMutableArray* level;


+(CCScene*) scene;

@end
