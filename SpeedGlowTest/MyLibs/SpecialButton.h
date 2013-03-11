//
//  SpecialButton.h
//  SpeedGlow
//
//  Created by VioletHill on 13-3-5.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SpecialButton : CCMenu
{
    NSInvocation* doubleClick;
    NSInvocation* singleClick;
    NSInvocation* touchBegin;
    NSInvocation* touchEnd;
}

@property (nonatomic, retain) NSInvocation *doubleClick;
@property (nonatomic, retain) NSInvocation *singleClick;
@property (nonatomic, retain) NSInvocation *touchBegin;
@property (nonatomic, retain) NSInvocation *touchEnd;


+(SpecialButton*) specialButtonWithNormalFile:(NSString*)normalFileName selectFile:(NSString*)selectFileName target:(id)t singleClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun;

+(SpecialButton*) specialButtonWithNormalFile:(NSString *)normalFileName selectFile:(NSString *)selectFileName target:(id)t singleClick:(SEL)singleClickFun;

+(SpecialButton*) specialButtonWithNormalFile:(NSString*)normalFileName selectFile:(NSString*)selectFileName target:(id)t singleClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun;

+(SpecialButton*) specialButtonWithNormalFile:(NSString *)normalFileName selectFile:(NSString *)selectFileName target:(id)t touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun;

+(SpecialButton*) specialButtonWithFile:(NSString*)fileName target:(id)t singClick:(SEL)singleClickFun;

+(SpecialButton*) specialButtonWithFile:(NSString*)fileName target:(id)t singClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun;

+(SpecialButton*) specialButtonWithFile:(NSString *)fileName target:(id)t touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun;

+(SpecialButton*) specialButtonWithFile:(NSString *)fileName target:(id)t singClick:(SEL)singleClickFun doubleClick:(SEL)doublleClickFun touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun;


@end
