//
//  OperatorLayer.m
//  SpeedGlow
//
//  Created by 邱峰 on 13-1-1.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "OperateLayer.h"


@implementation OperatorLayer
{
    CGSize layerSize;
    CCLabelTTF* operateLabel[4];
    CCSprite* ipad;
    int totalOperate;
    int operateCurrent;
    bool isChangeOrder;
    bool isStopAction;
}

-(void) addPad
{
    isChangeOrder=false;
    operateCurrent=0;
    totalOperate=2;
    
    ipad=[CCSprite spriteWithFile:@"iPad.png"];
    ipad.position=ccp(layerSize.width/2,layerSize.height/2);
    [self addChild:ipad];
}

-(id) init
{
    if ([super init]!=nil)
    {
        [self setContentSize:CGSizeMake(478, 484)];
        layerSize=[self contentSize];
//        CCSprite* sprite=[CCSprite spriteWithFile:@"OperateLayer.png"];
//        sprite.position=CGPointMake(layerSize.width/2,layerSize.height/2);
//        
//        [self addChild:sprite];
//        
//        [self addPad];
        
        //frame
        CCSprite* frame=[CCSprite spriteWithFile:@"FrameLayer.png"];
        frame.position=ccp(layerSize.width/2,layerSize.height/2);
        [self addChild:frame];
    }
    
    return self;
}


-(void) isNeedStop:(CCNode*) pSender
{
    if (isStopAction) [ipad stopAllActions];
}

-(CCActionInterval *) rotateAction
{
    CCActionInterval* action=[CCSequence actions:[CCRotateBy actionWithDuration:0.5 angle:20],[CCRotateBy actionWithDuration:0.5 angle:-20],[CCCallFunc actionWithTarget:self selector:@selector(isNeedStop:)],[CCRotateBy actionWithDuration:0.5 angle:-20],[CCRotateBy actionWithDuration:0.5 angle:20],[CCCallFunc actionWithTarget:self selector:@selector(isNeedStop:)],nil];
    return  action;
}

-(CCActionInterval*) scaleAction
{
    CCActionInterval* action=[CCSequence actions:[CCScaleTo actionWithDuration:0.5 scale:1.2],[CCScaleTo actionWithDuration:0.5 scale:1.0],[CCCallFunc actionWithTarget:self selector:@selector(isNeedStop:)],nil];
    return action;
}

-(void) runCurrentAction:(CCNode*) pSender
{
    switch (operateCurrent)
    {
        case 0:
            [ipad runAction:[CCRepeatForever actionWithAction:[self rotateAction]]];
            break;
        case 1:
            [ipad runAction:[CCRepeatForever actionWithAction:[self scaleAction]]];
            break;
        default:
            break;
    }
    isStopAction=false;
    isChangeOrder=false;
}

-(void) nextOrder
{
    if (isStopAction) return;
    if (isChangeOrder) return;
    if (operateCurrent==totalOperate-1) return;
    isChangeOrder=true;
    operateCurrent++;
    
    isStopAction=true;
    [self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:1] two:[CCCallFunc actionWithTarget:self selector:@selector(runCurrentAction:)]]];
    
}

-(void) lastOrder
{
    if (isStopAction) return;
    if (isChangeOrder) return;
    if (operateCurrent==0) return;
    isChangeOrder=true;
    operateCurrent--;
    
    isStopAction=true;
    [self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:1] two:[CCCallFunc actionWithTarget:self selector:@selector(runCurrentAction:)]]];
}


-(void) onEnterLayer
{
    isStopAction=false;
}

-(void) onExitLayer
{
    isStopAction=true;
}



@end
