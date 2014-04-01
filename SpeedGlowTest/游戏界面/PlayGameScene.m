//
//  EasyLevelPlay.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-26.
//  Copyright 2013年 VioletHill. All rights reserved.
//

#import "PlayGameScene.h"
#import "Obstacle.h"
#import "SimpleAudioEngine.h"
#import "Car.h"
#import "UserData.h"
#import "Gameover.h"
#import "Load.h"
#import <CoreMotion/CoreMotion.h>


#define processStartPosition ccp(200,100)
#define processEndPosition ccp(650,100)

#define sunCountPosition ccp(1000,600)


@implementation PlayGameScene
{
    float finalDistance;
    
    int raceTime;
    
    CCSprite* raceTimeSecondSprite2;
    CCSprite* raceTimeSecondSprite1;
    
    CCSprite* raceTimeMinuteSprite1;
    CCSprite* raceTimeMinuteSprite2;
    
    int startSwipe;
    WhichObstacle obstacle[60];        //障碍物种类
    float obstacleDistance[60];       //障碍物之间距离
    int totalObstacle;
    int streetLenth;
    int indexObstacle;
    
    CGSize screenSize;
    
    CCSprite* turnLeftSprite;
    CCSprite* turnRightSprite;
    CCSprite* sunSprite;
    CCSprite* barrierSprite;
    CCSprite* greenLightSprite;
    CCSprite* redLightSprite;
    
    CCSprite* processSprite;    //完成进度
    
    CCSprite* pauseBackgroundSprite;
    CCMenu* resumeMenu;
    CCMenu* againMenu;
    CCMenu* mainMenu;
    
    CCMenu* normalSpeedMenu;
    CCMenu* speedUpMenu;
    
    CMMotionManager* motionManager;
    BOOL isTurn;
    
    
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	PlayGameScene *layer = [PlayGameScene node];
	[scene addChild: layer];
	return scene;
    
}

#pragma mark 载入地图
-(float) getEasyRandomDistance
{
    int randomDistance=arc4random()%(1100-165);
    float distance=(float) randomDistance/10.0+36.6;
    return distance;
}

-(float) getMidiunRandomDistance
{
    int randomDistance=arc4random()%(900-165);
    float distance=(float) randomDistance/10.0+26.6;
    return distance;
}

-(float) getHardRandomDistance
{
    int randomDistance=arc4random()%(700-165);
    float distance=(float) randomDistance/10.0+16.6;
    return distance;
}

-(float) getRandomDistance
{
    float randomDistance;
    
    switch ([Obstacle sharedObstacle].gameLevel)
    {
        case kEASY:
            randomDistance=[self getEasyRandomDistance];
            break;
        case kMEDIUM:
            randomDistance=[self getMidiunRandomDistance];
            break;
        case kHARD:
            randomDistance=[self getHardRandomDistance];
            break;
        default:
            break;
    }
    return randomDistance;
}

-(void) loadMapWithBarrier:(int)barrierTot Turn:(int)turnTot Sun:(int)sunTot TrafficLight:(int)lightTot
{
    //障碍物总数
    totalObstacle=barrierTot+turnTot+sunTot+lightTot;
    
    //随机载入地图
    
    //辅助数组  让产生随机数不重复，并且一次产生结束
    WhichObstacle obstacleArray[totalObstacle];
    
    
    for (int i=0; i<barrierTot; i++)   obstacleArray[i]=kBARRIER;
    for (int i=0; i<turnTot; i++)   obstacleArray[i+barrierTot]=kTURN;
    for (int i=0; i<sunTot; i++)    obstacleArray[i+barrierTot+turnTot]=kSUN;
    for (int i=0; i<lightTot; i++)    obstacleArray[i+barrierTot+turnTot+sunTot]=kTRAFFIC_LIGHT;
        
    switch ([[Obstacle sharedObstacle] gameScene])
    {
        case kYLFC:
            [Obstacle sharedObstacle].sunTotalTime=sunSingleTime*4;
            [Obstacle sharedObstacle].barrierTotalTime=barrierSingleTime*3;
            [Obstacle sharedObstacle].turnTotalTime=turnSingleTime*2;
            break;
        case kBYYM:
            [Obstacle sharedObstacle].sunTotalTime=sunSingleTime*3;
            [Obstacle sharedObstacle].barrierTotalTime=barrierSingleTime*1.5;
            [Obstacle sharedObstacle].turnTotalTime=turnSingleTime*2;
            break;
        case kMWTJ:
            [Obstacle sharedObstacle].sunTotalTime=sunSingleTime*2;
            [Obstacle sharedObstacle].barrierTotalTime=barrierSingleTime*1.5;
            [Obstacle sharedObstacle].turnTotalTime=turnSingleTime*1;
            break;
        case kXBTW:
            [Obstacle sharedObstacle].sunTotalTime=sunSingleTime*2;
            [Obstacle sharedObstacle].barrierTotalTime=barrierSingleTime*1;
            [Obstacle sharedObstacle].turnTotalTime=turnSingleTime*1;
        default:
            break;
    }
    
    int x=totalObstacle;
    float distance=0;
    for (int i=0; i<totalObstacle; i++,x--)
    {
        int which=arc4random()%x;

        
        switch (obstacleArray[which])
        {
            case kBARRIER:
                obstacle[i]=kBARRIER;
                obstacleDistance[i]=distance+[self getRandomDistance];
                distance=obstacleDistance[i]+[Obstacle sharedObstacle].barrierTotalTime*accelerateSpeed;
                break;
                
            case kTURN:
                obstacle[i]=kTURN;
                obstacleDistance[i]=distance+[self getRandomDistance];
                distance=obstacleDistance[i]+[Obstacle sharedObstacle].turnTotalTime*accelerateSpeed;
                break;
                
            case kSUN:
                obstacle[i]=kSUN;
                obstacleDistance[i]=distance+[self getRandomDistance];
                distance=obstacleDistance[i]+[Obstacle sharedObstacle].sunTotalTime*accelerateSpeed;
                break;
                
            case kTRAFFIC_LIGHT:
                obstacle[i]=kTRAFFIC_LIGHT;
                obstacleDistance[i]=distance+[self getRandomDistance];
                distance=obstacleDistance[i]+trafficTotalTime*accelerateSpeed;
                break;
                
            default:
                break;
        }
        //把最后一个障碍物给第一个 这样可以保证生成效率
        obstacleArray[which]=obstacleArray[x-1];
    }
    //终点
    obstacle[totalObstacle++]=kFINAL;
    obstacleDistance[totalObstacle-1]=distance+[self getRandomDistance];
    finalDistance=obstacleDistance[totalObstacle-1];
  //  NSLog(@"%f",obstacleDistance[totalObstacle-1]);

}
-(void) loadYlfcSceneMap
{
    switch ([Obstacle sharedObstacle].gameLevel)
    {
        case kEASY:
            [self loadMapWithBarrier:7 Turn:7 Sun:4 TrafficLight:0];
            break;
        case kMEDIUM:
            [self loadMapWithBarrier:9 Turn:8 Sun:4 TrafficLight:0];
            break;
        case kHARD:
            [self loadMapWithBarrier:10 Turn:9 Sun:4 TrafficLight:0];
        default:
            break;
    }
}


-(void) loadByymSceneMap
{

    switch ([Obstacle sharedObstacle].gameLevel)
    {
        case kEASY:
            [self loadMapWithBarrier:10 Turn:13 Sun:4 TrafficLight:1];
            break;
        case kMEDIUM:
            [self loadMapWithBarrier:13 Turn:13 Sun:4 TrafficLight:2];
            break;
        case kHARD:
            [self loadMapWithBarrier:16 Turn:14 Sun:4 TrafficLight:2];
            break;
        default:
            break;
    }


}


-(void) loadMwtjSceneMap
{
    switch ([Obstacle sharedObstacle].gameLevel)
    {
        case kEASY:
            [self loadMapWithBarrier:13 Turn:13 Sun:4 TrafficLight:3];
            break;
        case kMEDIUM:
            [self loadMapWithBarrier:15 Turn:15 Sun:4 TrafficLight:3];
            break;
        case kHARD:
            [self loadMapWithBarrier:18 Turn:19 Sun:4 TrafficLight:4];
            break;
        default:
            break;
    }
}

-(void) loadXbtwSceneMap
{
    switch ([Obstacle sharedObstacle].gameLevel)
    {
        case kEASY:
            [self loadMapWithBarrier:15 Turn:15 Sun:4 TrafficLight:3];
            break;
        case kMEDIUM:
            [self loadMapWithBarrier:17 Turn:16 Sun:4 TrafficLight:4];
            break;
        case kHARD:
            [self loadMapWithBarrier:20 Turn:20 Sun:4 TrafficLight:6];
            break;
        default:
            break;
    }
}

#pragma mark startGo

-(void) startGo:(id)pSender
{
    [[Car sharedCar] start:kLEFT_LAND];
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1];
    //初始化时间
    raceTime=0;
    
    //开启更新距离
    [self schedule:@selector(updateDistance:) interval:0.1];
    
    //开启更新障碍物
    [self schedule:@selector(updateObstacle:) interval:0.1];
    
    //开启更新raceTime
    [self schedule:@selector(updateTime:) interval:1];
    
    //开启重力检查
    isTurn=false;
    motionManager=[[CMMotionManager alloc] init];
    [motionManager startAccelerometerUpdates];
    motionManager.accelerometerUpdateInterval=0.1;
    [self schedule:@selector(checkTurn:) interval:0.1];
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) ready:(id)pSender
{
    switch ([Obstacle sharedObstacle].gameScene) {
        case kYLFC:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"1夜路飞车.mp3" loop:false];
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:14],[CCCallFunc actionWithTarget:self selector:@selector(startGo:)],nil]];
            break;
        case kBYYM:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"2暴雨要密.mp3" loop:false];
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:27.5],[CCCallFunc actionWithTarget:self selector:@selector(startGo:)],nil]];
            break;
        case kMWTJ:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"3迷雾通缉.mp3" loop:false];
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:20],[CCCallFunc actionWithTarget:self selector:@selector(startGo:)],nil]];
            break;
        case kXBTW:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"4雪崩逃亡.mp3" loop:false];
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:36],[CCCallFunc actionWithTarget:self selector:@selector(startGo:)] ,nil]];
            break;
        default:
            break;
    }


}

-(void) start
{
    indexObstacle=0;
    [Car sharedCar].nowDistance=0;
    [Car sharedCar].speed=noSpeed;
    [Car sharedCar].isNeedStop=true;
    [self unscheduleAllSelectors];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(ready:)],nil]];
    
    switch ([Obstacle sharedObstacle].gameScene)
    {
        case kYLFC:
            [self loadYlfcSceneMap];
            break;
        case kBYYM:
            [self loadByymSceneMap];
            break;
        case kMWTJ:
            [self loadMwtjSceneMap];
            break;
        case kXBTW:
            [self loadXbtwSceneMap];
            break;
        default:
            break;
    }
    
}


-(void) addBarrier
{
    CGPoint screenCenter;
    screenCenter=ccp(screenSize.width/2,screenSize.height/2);
    
    sunSprite=[CCSprite spriteWithFile:@"Sun.png"];
    sunSprite.position=screenCenter;
    [sunSprite setVisible:false];
    [self addChild:sunSprite];
    
    turnLeftSprite=[CCSprite spriteWithFile:@"TurnLeft.png"];
    turnLeftSprite.position=screenCenter;
    [turnLeftSprite setVisible:false];
    [self addChild:turnLeftSprite];
    
    turnRightSprite=[CCSprite spriteWithFile:@"TurnRight.png"];
    turnRightSprite.position=screenCenter;
    [turnRightSprite setVisible:false];
    [self addChild:turnRightSprite];
    
    barrierSprite=[CCSprite spriteWithFile:@"Barrier.png"];
    barrierSprite.position=screenCenter;
    [barrierSprite setVisible:false];
    [self addChild:barrierSprite];
    
    greenLightSprite=[CCSprite spriteWithFile:@"GreenLight.png"];
    greenLightSprite.position=screenCenter;
    [greenLightSprite setVisible:false];
    [self addChild:greenLightSprite];
    
    redLightSprite=[CCSprite spriteWithFile:@"RedLight.png"];
    redLightSprite.position=screenCenter;
    [redLightSprite setVisible:false];
    [self addChild:redLightSprite];
    
}

-(void) addRaceTime
{

    //time
    
    //秒数十位

    raceTimeSecondSprite1=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"small0"] ];
    raceTimeSecondSprite1.anchorPoint=ccp(1,1);
    raceTimeSecondSprite1.position=ccp(screenSize.width-raceTimeSecondSprite1.contentSize.width*3,screenSize.height-raceTimeSecondSprite1.contentSize.height);
    [self addChild:raceTimeSecondSprite1];
    
    //秒数个位
    raceTimeSecondSprite2=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"small0"] ];
    raceTimeSecondSprite2.anchorPoint=ccp(1,1);
    raceTimeSecondSprite2.position=ccp(screenSize.width-raceTimeSecondSprite2.contentSize.width*2,screenSize.height-raceTimeSecondSprite2.contentSize.height);
    [self addChild:raceTimeSecondSprite2];
    //////////////////////////////////
        
}

-(void) addSpeedMenu
{
    //正常速度键
    CCMenuItemImage* normalItem=[CCMenuItemImage itemWithNormalImage:@"Stop.png" selectedImage:nil target:self selector:@selector(normalSpeedMenu:)];
    normalSpeedMenu=[CCMenu menuWithItems:normalItem, nil];
    normalItem.anchorPoint=ccp(0,0);
    [normalSpeedMenu setAnchorPoint:ccp(0,0)];
    normalSpeedMenu.position=ccp(0,0);
    [self addChild:normalSpeedMenu];
    
    //加速键
    CCMenuItemImage* speedUpItem=[CCMenuItemImage itemWithNormalImage:@"SpeedUp.png" selectedImage:nil target:self selector:@selector(speedUpMenu:)];
    speedUpMenu=[CCMenu menuWithItems:speedUpItem, nil];
    speedUpItem.anchorPoint=ccp(1,0);
    speedUpMenu.anchorPoint=ccp(1,0);
    speedUpMenu.position=ccp(screenSize.width,0);
    [self addChild:speedUpMenu];
}

-(void) addPause
{
    
    //暂停按键
    CCMenuItemImage *pauseItem=[CCMenuItemImage itemWithNormalImage:@"Pause.png" selectedImage:nil target:self selector:@selector(pauseGame:)];
    CCMenu *pauseMenu=[CCMenu menuWithItems:pauseItem, nil];
    pauseItem.anchorPoint=ccp(0,1);
    pauseMenu.anchorPoint=ccp(0,1);
    pauseMenu.position=ccp(0,screenSize.height);
    [self addChild:pauseMenu];

    
    //暂停界面
    pauseBackgroundSprite=[CCSprite spriteWithFile:@"PauseBackground.png"];
    pauseBackgroundSprite.position=ccp(screenSize.width/2,screenSize.height/2);
    [pauseBackgroundSprite setVisible:false];
    [self addChild:pauseBackgroundSprite];
    
    CCMenuItemImage* resumeItem=[CCMenuItemImage itemWithNormalImage:@"Resume.png" selectedImage:nil target:self selector:@selector(resumeGame:)];
    
    resumeMenu=[CCMenu menuWithItems:resumeItem, nil];
    resumeMenu.position=ccp(screenSize.width/2,screenSize.height/2);
    [resumeMenu setVisible:false];
    [resumeMenu setEnabled:false];
    [self addChild:resumeMenu];
    
    //重新开始
    againMenu=[CCMenu menuWithItems:[CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"重新游戏" fontName:@"TimesNewRomanPSMT" fontSize:30] target:self selector:@selector(againMenu:)], nil];
    [againMenu setPosition:ccp(100,100)];
    [self addChild:againMenu];
    [againMenu setVisible:false];
    [againMenu setEnabled:false];
    
    //主菜单
    mainMenu=[CCMenu menuWithItems:[CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"主菜单" fontName:@"TimesNewRomanPSMT" fontSize:30] target:self selector:@selector(mainMenu:)], nil];
    [mainMenu setPosition:ccp(screenSize.width-mainMenu.contentSize.height,100)];
    [mainMenu setVisible:false];
    [mainMenu setEnabled:false];
    [self addChild:mainMenu];
}

-(void) addProcess
{
    processSprite=[CCSprite spriteWithFile:@"Process.png"];
    processSprite.position=processStartPosition;
    [self addChild:processSprite];
}

-(id) init
{
    if (self=[super init])
    {
        screenSize=[[CCDirector sharedDirector] winSize];
        
        [self addSpeedMenu];
        
        //加入raceTime
        [self addRaceTime];
        
        //加入所有障碍物
        [self addBarrier];
    
        [self addPause];
        
        [self addProcess];
        
    }
    return self;
}

-(void) updateTime:(ccTime)delay
{
    if (![[Car sharedCar] getIsPlayCarSpeedSound])
    {
        //openAL提供的loop貌似只支持18次循环音效？
        [[Car sharedCar] playCarEffect];
    }

    raceTime++;
    [raceTimeSecondSprite1 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"small%d",(raceTime%60)/10] ]];
    [raceTimeSecondSprite2 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"small%d",(raceTime%60)%10] ]];
}

-(void) updateDistance:(ccTime)delay
{
    if ([Car sharedCar].isNeedStop) return ;
    [Car sharedCar].nowDistance=[Car sharedCar].nowDistance+[Car sharedCar].speed*0.1;
    processSprite.position=ccp(processStartPosition.x+[Car sharedCar].nowDistance/finalDistance*(processEndPosition.x-processStartPosition.x),processSprite.position.y);
}

-(void) updateObstacle:(ccTime)delay
{
    if (fabs([Car sharedCar].nowDistance-obstacleDistance[indexObstacle])<accelerateSpeed*0.1)
    {
        switch (obstacle[indexObstacle])
        {
            case kBARRIER:
                [self startBarrier];
                break;
            case kTURN:
                [self startTurn];
                break;
            case kTRAFFIC_LIGHT:
                [self startTraffic];
                break;
            case kSUN:
                [self startSun];
                break;
            case kFINAL:
                [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
                [self finishGame];
                [self unscheduleAllSelectors];
            default:
                break;
        }
        indexObstacle++;
    }
}

//到达终点
-(void) finishGame
{
    [Car sharedCar].finishGameTime=raceTime;
    CCTransitionFade* fade=[CCTransitionMoveInL transitionWithDuration:0.1 scene:[Gameover scene]];
    [[CCDirector sharedDirector] replaceScene:fade];
}

//障碍物事件触发
-(void) startBarrier
{
    [barrierSprite setVisible:true];
    CCActionInterval* spriteAction=[CCSequence actions:[CCFadeIn actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1], nil];
    [barrierSprite runAction:[CCRepeatForever actionWithAction:spriteAction]];
    
    CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].barrierTotalTime],[CCCallFunc actionWithTarget:self selector:@selector(endBarrer:)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:removeSprite];
    
    int random=arc4random()%2;
    if (random==0)
    {
        [[Obstacle sharedObstacle] startBarrierL];
    }
    else
    {
        [[Obstacle sharedObstacle] startBarrierR];
    }
}

-(void) endBarrer:(id)pSender
{
    [barrierSprite stopAllActions];
    [barrierSprite setVisible:false];
}

//太阳时间触发
-(void) startSun
{
    [Car sharedCar].isEatSun=false;
    [Car sharedCar].isFinishSun=false;
    
    [sunSprite setVisible:true];
    CCActionInterval* spriteAction=[CCSequence actions:[CCFadeIn actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1], nil];
    [sunSprite runAction:[CCRepeatForever actionWithAction:spriteAction]];
    CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].sunTotalTime+0.05],[CCCallFunc actionWithTarget:self selector:@selector(endSun:)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:removeSprite];
    
    int random=arc4random()%2;
    if (random==0)
    {
        [[Obstacle sharedObstacle] startSunL];
    }
    else
    {
        [[Obstacle sharedObstacle] startSunR];
    }
}

-(void) bezierDone:(id)pSender
{
    [sunSprite stopAllActions];
    [sunSprite setVisible:false];
    sunSprite.scale=1;
    sunSprite.position=ccp(screenSize.width/2,screenSize.height/2);
}

-(void) endSun:(id)pSender
{
    if (![Car sharedCar].isFinishSun)    //如果太阳检测时间没有结束 0.1s后回调自己
    {
        CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].sunTotalTime+0.1],[CCCallFunc actionWithTarget:self selector:@selector(endSun:)],nil];
        [[[CCDirector sharedDirector] runningScene] runAction:removeSprite];
    }
    else
    {
        [sunSprite stopAllActions];
        if (![Car sharedCar].isEatSun)   [sunSprite setVisible:false];
        else                            //吃到太阳 播放动作  
        {
            [sunSprite stopAllActions];
            
            ccBezierConfig bezier;
            bezier.controlPoint_1 = sunSprite.position;
            int sx=sunSprite.position.x;
            int ex=1050;
            int ey=750;
            int sy=sunSprite.position.y;
            bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5+200);
            bezier.endPosition = sunCountPosition;
            CCAction* action=[CCSequence actions:[CCSpawn actions:[CCBezierTo actionWithDuration:0.5 bezier:bezier], [CCScaleTo actionWithDuration:0.5 scale:0.5],nil], [CCCallFunc actionWithTarget:self selector:@selector(bezierDone:)],nil];
            [sunSprite runAction:action];
        }

    }
}

//转弯事件触发
-(void) startTurn
{
    int random=arc4random()%2;
    if (random==0)
    {
        [turnLeftSprite setVisible:true];
         CCActionInterval* spriteAction=[CCSequence actions:[CCFadeIn actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1], nil];
        [turnLeftSprite runAction:[CCRepeatForever actionWithAction:spriteAction]];
        
        CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].turnTotalTime],[CCCallFunc actionWithTarget:self selector:@selector(endTurnLeft:)],nil];
        [[[CCDirector sharedDirector] runningScene] runAction:removeSprite];
            
        [[Obstacle sharedObstacle] startTurnLeft];
    }
    else
    {
        [turnRightSprite setVisible:true];
        CCActionInterval* spriteAction=[CCSequence actions:[CCFadeIn actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1], nil];
        [turnRightSprite runAction:[CCRepeatForever actionWithAction:spriteAction]];
        
        CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].turnTotalTime],[CCCallFunc actionWithTarget:self selector:@selector(endTurnRight:)],nil];
        [[[CCDirector sharedDirector] runningScene] runAction:removeSprite];
            
        [[Obstacle sharedObstacle] startTurnRight];
    }
  
}

-(void) endTurnLeft:(id)pSender
{
    [turnLeftSprite stopAllActions];
    [turnLeftSprite setVisible:false];
}

-(void) endTurnRight:(id)pSender
{
    [turnRightSprite stopAllActions];
    [turnRightSprite setVisible:false];
}

-(void) showSprite:(id)pSender data:(void*)data
{
    CCSprite* sprite=(CCSprite*)data;
    [sprite setVisible:true];
}
//红绿灯事件触发
-(void) startTraffic
{
    int random=arc4random()%2;
    if (random==0)   //R2G
    {
        CCActionInterval* spriteAction=[CCSequence actions:[CCDelayTime actionWithDuration:trafficReadyTime],[CCCallFuncND actionWithTarget:self selector:@selector(showSprite:data:) data:(void*)redLightSprite],[CCBlink actionWithDuration:((float)trafficLightTime)/4*3 blinks:3],[CCCallFunc actionWithTarget:self selector:@selector(endTrafficLightR2G:)],nil];
        [redLightSprite runAction:spriteAction];
                
        [[Obstacle sharedObstacle] startRed2Green];
    }
    else            //G2R
    {
        CCActionInterval* spriteAction=[CCSequence actions:[CCDelayTime actionWithDuration:trafficReadyTime],[CCCallFuncND actionWithTarget:self selector:@selector(showSprite:data:) data:(void*)greenLightSprite],[CCBlink actionWithDuration:((float)trafficLightTime)/4*3 blinks:3],[CCCallFunc actionWithTarget:self selector:@selector(endTrafficLightG2R:)],nil];
        [greenLightSprite runAction:[CCRepeatForever actionWithAction:spriteAction]];
        
        [[Obstacle sharedObstacle] startGreen2Red];
    }
}

-(void) endTrafficLightR2G:(id)pSender
{
    [redLightSprite stopAllActions];
    [redLightSprite setVisible:false];
}

-(void) endTrafficLightG2R:(id)pSender
{
    [greenLightSprite stopAllActions];
    [greenLightSprite setVisible:false];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([[CCDirector sharedDirector] isPaused]) return NO;
    
    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	startSwipe = touchPoint.x;
	return YES;
}


-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    int newX = touchPoint.x;
  
    if ( (newX - startSwipe< -20) && [Car sharedCar].isChangeLand==false )  //右向左滑屏
    {
        [[Car sharedCar] changeLandFromR2L];
    }
    else if ( (newX - startSwipe > 20) && [Car sharedCar].isChangeLand==false ) // 左向右滑屏
    {
        [[Car sharedCar] changeLandFromL2R];
    }


}

-(void) checkTurn:(ccTime)delay
{
    if (![Car sharedCar].isNeedTurnRight && ![Car sharedCar].isNeedTurnLeft) return;
    CMAccelerometerData *newestAccel = motionManager.accelerometerData;
    double accelerationY = newestAccel.acceleration.y;
    if (fabs(accelerationY)>0.30)
    {
        if (isTurn) return;
        else if (accelerationY>0.30)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"拐弯音效.mp3"];
            [[Car sharedCar] turnRight];
            isTurn=true;
        
        }
        else if (accelerationY<-0.30)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"拐弯音效.mp3"];
            [[Car sharedCar] turnLeft];
            isTurn=true;
        }
    }
    else            //转弯动作完成，设备被摆正
    {
        if (isTurn) isTurn=false;
    }
}





#pragma mark  pause

-(void) againMenu:(id)pSender
{
    [[CCDirector sharedDirector] replaceScene:[Load scene]];
}

-(void) mainMenu:(id)pSender
{
    [[CCDirector sharedDirector] popToRootScene];
}

-(void) speedUpMenu:(id) pSender
{
    if ([Car sharedCar].isNeedStop) return;
    if ([Car sharedCar].speed==accelerateSpeed) return;
    [[Car sharedCar] speedUpStart];
    
}

-(void) normalSpeedMenu:(id)pSender
{
    if ([Car sharedCar].isNeedStop) return ;
    if ([Car sharedCar].speed==normalSpeed) return ;
    [[Car sharedCar] normalSpeedStart];
    
}

-(void) resumeGame:(id)pSender
{
    [pauseBackgroundSprite setVisible:false];

    [normalSpeedMenu setEnabled:true];
    [speedUpMenu setEnabled:true];
    [processSprite setVisible:true];
    
    [resumeMenu setVisible:false];
    [resumeMenu setEnabled:false];
    
    [againMenu setEnabled:false];
    [againMenu setVisible:false];
    
    [mainMenu setEnabled:false];
    [mainMenu setVisible:false];
    
    [[CCDirector sharedDirector] resume];
    [[SimpleAudioEngine sharedEngine] resumeAllEffect];
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];

}

-(void) pauseGame:(id)pSender
{
    [[CCDirector sharedDirector] pause];
    [[SimpleAudioEngine sharedEngine] pauseAllEffect];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    
    [normalSpeedMenu setEnabled:false];
    [speedUpMenu setEnabled:false];
    [processSprite setVisible:false];
    
    [pauseBackgroundSprite setVisible:true];
    
    [resumeMenu setEnabled:true];
    [resumeMenu setVisible:true];
    
    [againMenu setVisible:true];
    [againMenu setEnabled:true];
    
    [mainMenu setVisible:true];
    [mainMenu setEnabled:true];
}

-(void) onEnter
{
    [super onEnter];
    [self start];
}

-(void) onExit
{
    if ([[CCDirector sharedDirector] isPaused]) [[CCDirector sharedDirector] resume];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[SimpleAudioEngine sharedEngine] stopAllEffect];

    [self stopAllActions];
    [super onExit];
}

@end
