//
//  PlayScene.h
//  SpeedGlowTest
//
//  Created by 邱峰 on 13-1-9.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayScene : CCLayer {
    
}

+(CCScene *) scene;
@property (nonatomic, retain) NSInvocation* onPageMoved;
@property (nonatomic, strong) NSMutableArray* playLayer;

@end
