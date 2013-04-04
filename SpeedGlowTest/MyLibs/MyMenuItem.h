//
//  MyMenuItem.h
//  SpeedGlow
//
//  Created by VioletHill on 13-4-2.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


/*
 singleClick 单击时间
 doubleClick 双击事件
 touchBegin  手指在菜单上开始停留
 touchEnd    手指在菜单上停留结束
 */

//    touchBegin touchEnd 不会触发 singleClick

@interface MyMenuItem : CCLayer <CCTargetedTouchDelegate>
{
    NSInvocation* doubleClick;
    NSInvocation* singleClick;
    NSInvocation* touchBegin;
    NSInvocation* touchEnd;
    tCCMenuState state_;
	//MyMenuItem	*selectedItem_;
    BOOL isEnabled_;
	BOOL isSelected_;
    BOOL isTouchBegin;
    
    CCSprite* normalImage_;
    CCSprite* selectedImage_;
}

@property (nonatomic, retain) NSInvocation *doubleClick;
@property (nonatomic, retain) NSInvocation *singleClick;
@property (nonatomic, retain) NSInvocation *touchBegin;
@property (nonatomic, retain) NSInvocation *touchEnd;
@property (nonatomic, readwrite) BOOL isEnabled;

// weak references

/** the image used when the item is not selected */
@property (nonatomic,readwrite,assign) CCSprite* normalImage;
/** the image used when the item is selected */
@property (nonatomic,readwrite,assign) CCSprite* selectedImage;



+(MyMenuItem*) myMenuItemWithNormalFile:(NSString*)normalFileName selectFile:(NSString*)selectFileName target:(id)t singleClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun;

+(MyMenuItem*) myMenuItemWithNormalFile:(NSString *)normalFileName selectFile:(NSString *)selectFileName target:(id)t singleClick:(SEL)singleClickFun;

+(MyMenuItem*) myMenuItemWithNormalFile:(NSString*)normalFileName selectFile:(NSString*)selectFileName target:(id)t singleClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun;

+(MyMenuItem*) myMenuItemWithNormalFile:(NSString *)normalFileName selectFile:(NSString *)selectFileName target:(id)t touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun;

+(MyMenuItem*) myMenuItemWithFile:(NSString*)fileName target:(id)t singClick:(SEL)singleClickFun;

+(MyMenuItem*) myMenuItemWithFile:(NSString*)fileName target:(id)t singClick:(SEL)singleClickFun doubleClick:(SEL)doubleClickFun;

+(MyMenuItem*) myMenuItemWithFile:(NSString *)fileName target:(id)t touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun;

+(MyMenuItem*) myMenuItemWithFile:(NSString *)fileName target:(id)t singClick:(SEL)singleClickFun doubleClick:(SEL)doublleClickFun touchBegin:(SEL)touchBeginFun touchEnd:(SEL)touchEndFun;


-(CGRect) rect;
-(void) selected;
-(void) unselected;
-(void) setIsEnabled:(BOOL)enabled;
-(BOOL) isEnabled;

@end
