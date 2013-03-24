//
//  EasyGameover.m
//  SpeedGlow
//
//  Created by VioletHill on 13-3-9.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "Gameover.h"
#import "Car.h"
#import "Obstacle.h"
#import "UserData.h"
#import "SettingScene.h"
#import "HelpScene.h"
#import "Setting.h"
#import "SimpleAudioEngine.h"



@implementation Gameover
{
    CGSize screenSize;
    CCSprite* frame;
}

static GameState _gameState;

+(void) setGameState:(GameState)gameState
{
    _gameState=gameState;
}

+(GameState) getGameState
{
    return _gameState;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Gameover *layer = [Gameover node];
	[scene addChild: layer];
	return scene;
    
}


-(void) addBack
{
    
    ////后退
    CCMenuItemImage* backMenuItem=[CCMenuItemImage itemWithNormalImage:@"Back.png" selectedImage:NULL target:self selector:@selector(returnLastScene:)];
    CCMenu* backMenu=[CCMenu menuWithItems:backMenuItem, nil];
    backMenu.position=ccp([backMenuItem contentSize].width/2, screenSize.height-[backMenuItem contentSize].height/2);
    [self addChild:backMenu];
}

-(void) addHelp
{
    //帮助
    CCMenuItemImage* helpMenuItem=[CCMenuItemImage itemWithNormalImage:@"Help.png" selectedImage:NULL target:self selector:@selector(pushToHelpScene:)];
    CCMenu* helpMenu=[CCMenu menuWithItems:helpMenuItem, nil];
    helpMenu.position=ccp(screenSize.width-[helpMenuItem contentSize].width/2, screenSize.height-[helpMenuItem contentSize].height/2);
    [self addChild:helpMenu];
}

-(void) pushToHelpScene:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    
    CCTransitionFade* fade=[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[HelpScene scene]];
    [[CCDirector sharedDirector] pushScene:fade];
}

-(void) callReturnLastScene:(id)pSender
{
    [[CCDirector sharedDirector] popScene];
}

-(void) returnLastScene:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"按键音一单击.mp3"];
    
    CCAction* action=[CCSequence actions:[CCScaleTo actionWithDuration:0.1 scale:0.25],[CCScaleTo actionWithDuration:0.05 scale:1],[CCCallFunc actionWithTarget:self selector:@selector(callReturnLastScene:)],
                      nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) addSun
{
    CCSprite* sun=[CCSprite spriteWithFile:@"Sun.png"];
    sun.anchorPoint=ccp(0,1);
    sun.position=ccp(372,screenSize.height-636);
    [self addChild:sun];
    
    int totSun=[[UserData sharedUserData] getMaxSunAtScene:[Obstacle sharedObstacle].gameScene andLevel:[Obstacle sharedObstacle].gameLevel];
    int haveSun=[[UserData sharedUserData] getSunAtScene:[Obstacle sharedObstacle].gameScene andLevel:[Obstacle sharedObstacle].gameLevel];
    
    CCSprite* totSunSprite1=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[@"SunNum" stringByAppendingFormat:@"%d",totSun/10]]];
    totSunSprite1.anchorPoint=ccp(0,1);
    totSunSprite1.position=ccp(550,screenSize.height-680);
    [self addChild:totSunSprite1];
    
    CCSprite* totSunSprite2=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[@"SunNum" stringByAppendingFormat:@"%d",totSun%10]]];
    totSunSprite2.anchorPoint=ccp(0,1);
    totSunSprite2.position=ccp(578,screenSize.height-680);
    [self addChild:totSunSprite2];
    
    CCSprite* sprite_=[CCSprite spriteWithFile:@"SunNum_.png"];
    sprite_.anchorPoint=ccp(0,1);
    sprite_.position=ccp(534,screenSize.height-680);
    [self addChild:sprite_];
    
    
    CCSprite* haveSunSprite1=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[@"SunNum" stringByAppendingFormat:@"%d",haveSun/10]]];
    haveSunSprite1.anchorPoint=ccp(0,1);
    haveSunSprite1.position=ccp(478,screenSize.height-680);
    [self addChild:haveSunSprite1];
    
    CCSprite* haveSunSprite2=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[@"SunNum" stringByAppendingFormat:@"%d",haveSun%10]]];
    haveSunSprite2.anchorPoint=ccp(0,1);
    haveSunSprite2.position=ccp(506,screenSize.height-680);
    [self addChild:haveSunSprite2];
}


-(void) addTitle
{
    CCSprite* sceneTitle;
    CCSprite* layerTitle;
    switch ([Obstacle sharedObstacle].gameScene)
    {
        case kYLFC:
            sceneTitle=[CCSprite spriteWithFile:@"YlfcTitle.png"];
            break;
        case kBYYM:
            sceneTitle=[CCSprite spriteWithFile:@"ByymTitle.png"];
            break;
        case kMWTJ:
            sceneTitle=[CCSprite spriteWithFile:@"MwtjTitle.png"];
            break;
        case kXBTW:
            sceneTitle=[CCSprite spriteWithFile:@"XbtwTitle.png"];
            break;
        default:
            break;
    }
    switch ([Obstacle sharedObstacle].gameLevel)
    {
        case kEASY:
            layerTitle=[CCSprite spriteWithFile:@"Easy.png"];
            break;
        case kMEDIUM:
            layerTitle=[CCSprite spriteWithFile:@"Medium.png"];
            break;
        case kHARD:
            layerTitle=[CCSprite spriteWithFile:@"Hard.png"];
            break;
        default:
            break;
    }
    sceneTitle.scale=layerTitle.scale=0.5;
    sceneTitle.position=ccp(100,450);
    [frame addChild:sceneTitle];
    layerTitle.position=ccp(300,450);
    [frame addChild:layerTitle];
}

#define rankSpace 80
#define startPositonX 50

#define minute1PositionX 160
#define minute2PositionX 210
#define minutePositionX  260
#define second1PositionX 310
#define second2PositionX 360
#define secondPositionX  410

#define startPositionY 350

-(void) frameChange:(id)pSender
{
    [frame removeAllChildrenWithCleanup:true];
    [frame setRotation:0];
    
    [self addTitle];
    
    CCSprite* firstRank=[CCSprite spriteWithFile:@"FirstRank.png"];
    firstRank.anchorPoint=ccp(0.5,0);
    firstRank.position=ccp(startPositonX,startPositionY);
    [frame addChild:firstRank];
    
    NSMutableArray* rank=[[UserData sharedUserData] getRankAtScene:[Obstacle sharedObstacle].gameScene andLevel:[Obstacle sharedObstacle].gameLevel];
    for (int i=0; i<[rank count]; i++)
    {
        int time=[(NSNumber*)[rank objectAtIndex:i] intValue];
        
        CCSprite* minute1=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"small%d",time/60/10]]];
        minute1.anchorPoint=ccp(0.5,0);
        [minute1 setPosition:ccp(minute1PositionX, startPositionY-i*rankSpace)];
        [frame addChild:minute1];
        
        CCSprite* minute2=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"small%d",time/60%10]]];
        minute2.anchorPoint=ccp(0.5,0);
        [minute2 setPosition:ccp(minute2PositionX, startPositionY-i*rankSpace)];
        [frame addChild:minute2];
        
        CCSprite* minute=[CCSprite spriteWithFile:@"Minute.png"];
        minute.anchorPoint=ccp(0.5,0);
        [minute setPosition:ccp(minutePositionX,startPositionY-i*rankSpace)];
        [frame addChild:minute];
        
        CCSprite* second1=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"small%d",time%60/10]]];
        second1.anchorPoint=ccp(0.5,0);
        [second1 setPosition:ccp(second1PositionX,startPositionY-i*rankSpace)];
        [frame addChild:second1];
        
        CCSprite* second2=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"small%d",time%60%10]]];
        second2.anchorPoint=ccp(0.5,0);
        [second2 setPosition:ccp(second2PositionX,startPositionY-i*rankSpace)];
        [frame addChild:second2];
        
        CCSprite* second=[CCSprite spriteWithFile:@"Second.png"];
        second.anchorPoint=ccp(0.5,0);
        [second setPosition:ccp(secondPositionX,startPositionY-i*rankSpace)];
        [frame addChild:second];
        
        if (i==0) continue;
    }
}

-(void) addSuccess
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"欢呼.mp3"];
    
    
    
    CCSprite* bg=[CCSprite spriteWithFile:@"Successful.png"];
    bg.position=ccp(screenSize.width/2,screenSize.height/2);
    [self addChild:bg];
    
    frame=[CCSprite spriteWithFile:@"FrameLayer.png"];
    [frame setPosition:ccp(screenSize.width/2,screenSize.height/2)];
    
    CCLabelTTF* finish=[CCLabelTTF labelWithString:@"hello" fontName:@"TimesNewRomanPSMT" fontSize:20];
    [frame addChild:finish];
    
    [self addChild:frame];
    
    [frame runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCRotateTo actionWithDuration:0.5 angleX:0 angleY:180],[CCCallFunc actionWithTarget:self selector:@selector(frameChange:)], nil]];
}

-(void) addFail
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"嘘声.mp3"];
}



-(id) init
{
    if (self=[super init])
    {
        screenSize=[[CCDirector sharedDirector] winSize];
        [[UserData sharedUserData] reflushSunAtScene:[Obstacle sharedObstacle].gameScene andLevel:[Obstacle sharedObstacle].gameLevel withSunNumber:[Car sharedCar].sun];
        [[UserData sharedUserData] reflushTime:[Car sharedCar].finishGameTime atScene:[Obstacle sharedObstacle].gameScene andLevel:[Obstacle sharedObstacle].gameLevel];
        if ([Gameover getGameState]==kSUCCESS)
        {
            switch ([Obstacle sharedObstacle].gameLevel)
            {
                case kEASY:
                    [[UserData sharedUserData] unlockAtScene:[Obstacle sharedObstacle].gameScene andLevel:kMEDIUM];
                    break;
                case kMEDIUM:
                    [[UserData sharedUserData] unlockAtScene:[Obstacle sharedObstacle].gameScene andLevel:kHARD];
                    break;
                default:
                    break;
            }
            [self addSuccess];
        }
        else
        {
            [self addFail];
        }
        
        [self addBack];
        [self addHelp];
        [self addSun];
        [self addTitle];
    }
    return self;
}

@end
