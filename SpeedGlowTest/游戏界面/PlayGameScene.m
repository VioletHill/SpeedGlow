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
#import "SpecialButton.h"
#import "UserData.h"
#import "Gameover.h"
#import <CoreMotion/CoreMotion.h>


#define sunCountPosition ccp(1000,600)


@implementation PlayGameScene
{
    int raceTime;
    
    CCSprite* raceTimeSecondSprite2;
    CCSprite* raceTimeSecondSprite1;
    
    CCSprite* raceTimeMinuteSprite1;
    CCSprite* raceTimeMinuteSprite2;
    
    int startSwipe;
    WhichObstacle obstacle[40];        //障碍物种类
    float obstacleDistance[40];       //障碍物之间距离
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
    
    CCSprite* pauseBackgroundSprite;
    CCMenu* resumeMenu;
    
    CCMenu* normalSpeedMenu;
    CCMenu* speedUpMenu;
    
    CMMotionManager* motionManager;
    BOOL isTurn;
    
    BOOL isPause;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	PlayGameScene *layer = [PlayGameScene node];
	[scene addChild: layer];
	return scene;
    
}

#pragma mark 载入地图
-(float) getRandomDistance
{
    int randomDistance=arc4random()%(1100-165);
    float distance=(float) randomDistance/10.0+16.6;
    return distance;
    
}

-(void) loadYlfcSceneMap
{
    totalObstacle=26;
    
    
    //随机载入地图
    //10个障碍
    //10个拐角
    //4个太阳
    //2个红绿灯
    
    
    //辅助数组  让产生随机数不重复，并且一次产生结束
    WhichObstacle obstacleArray[totalObstacle];
    for (int i=0; i<10; i++)   obstacleArray[i]=kBARRIER;
    for (int i=0; i<10; i++)   obstacleArray[i+10]=kTURN;
    for (int i=0; i<4; i++)    obstacleArray[i+20]=kSUN;
    for (int i=0; i<2; i++)    obstacleArray[i+24]=kTRAFFIC_LIGHT;

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
                distance=obstacleDistance[i]+barrierTotalTime*accelerateSpeed;
                break;
            case kTURN:
                obstacle[i]=kTURN;
                obstacleDistance[i]=distance+[self getRandomDistance];
                distance=obstacleDistance[i]+turnTwoTotalTime*accelerateSpeed;
                break;
            case kSUN:
                obstacle[i]=kSUN;
                obstacleDistance[i]=distance+[self getRandomDistance];
                distance=obstacleDistance[i]+sunTotalTime*accelerateSpeed;
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
    
}


-(void) loadByymSceneMap
{
    
}

#pragma mark startGo

-(void) startGo:(id)pSender
{
    [[Car sharedCar] start:kLEFT_LAND];

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
    [[SimpleAudioEngine sharedEngine] playEffect:@"321Go.mp3"];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3],[CCCallFunc actionWithTarget:self selector:@selector(startGo:)],nil]];
}

-(void) start
{
    isPause=false;
    indexObstacle=0;
    [Car sharedCar].nowDistance=0;
    [Car sharedCar].speed=noSpeed;
    [Car sharedCar].isNeedStop=true;
    [self unscheduleAllSelectors];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(ready:)],nil]];
    
    switch ([Obstacle sharedObstacle].gameScene) {
        case kYLFC:
            [self loadYlfcSceneMap];
            break;
        case kBYYM:
            [self loadByymSceneMap];
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

-(id) init
{
    if (self=[super init])
    {
        screenSize=[[CCDirector sharedDirector] winSize];
        
        [self addSpeedMenu];
        
        //暂停按键
        CCMenuItemImage *pauseItem=[CCMenuItemImage itemWithNormalImage:@"Pause.png" selectedImage:nil target:self selector:@selector(pauseGame:)];
        CCMenu *pauseMenu=[CCMenu menuWithItems:pauseItem, nil];
        pauseItem.anchorPoint=ccp(0,1);
        pauseMenu.anchorPoint=ccp(0,1);
        pauseMenu.position=ccp(0,screenSize.height);
        [self addChild:pauseMenu];
//        
//        SpecialButton* pause=[SpecialButton specialButtonWithFile:@"Pause.png" target:self singClick:@selector(pauseGame:)];
//        pause.anchorPoint=ccp(0,1);
//        pause.position=ccp(0,screenSize.height);
//        [self addChild:pause];

        
        //加入raceTime
        [self addRaceTime];
        
        
        //加入所有障碍物
        [self addBarrier];
    
        //暂停界面
        pauseBackgroundSprite=[CCSprite spriteWithFile:@"PauseBackground.png"];
        pauseBackgroundSprite.position=ccp(screenSize.width/2,screenSize.height/2);
        [pauseBackgroundSprite setVisible:false];
        [self addChild:pauseBackgroundSprite];
        
        CCMenuItemImage* resumeItem=[CCMenuItemImage itemWithNormalImage:@"Resume.png" selectedImage:nil target:self selector:@selector(resumeGame:)];
        
        resumeMenu=[CCMenu menuWithItems:resumeItem, nil];
        resumeMenu.position=ccp(screenSize.width/2,screenSize.height/2);
        [resumeMenu setVisible:false];
        [self addChild:resumeMenu];
        
    }
    return self;
}

-(void) updateTime:(ccTime)delay
{
    raceTime++;
    [raceTimeSecondSprite1 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"small%d",(raceTime%60)/10] ]];
    [raceTimeSecondSprite2 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"small%d",(raceTime%60)%10] ]];
}

-(void) updateDistance:(ccTime)delay
{
    if ([Car sharedCar].isNeedStop) return ;
    [Car sharedCar].nowDistance=[Car sharedCar].nowDistance+[Car sharedCar].speed*0.1;

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
                [self finishGame];
            default:
                break;
        }
        indexObstacle++;
    }
}

//到达终点
-(void) finishGame
{
    CCTransitionFade* fade=[CCTransitionMoveInL transitionWithDuration:0.1 scene:[Gameover scene]];
    [[CCDirector sharedDirector] replaceScene:fade];
}

//障碍物事件触发
-(void) startBarrier
{
    [barrierSprite setVisible:true];
    CCActionInterval* spriteAction=[CCSequence actions:[CCFadeIn actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1], nil];
    [barrierSprite runAction:[CCRepeatForever actionWithAction:spriteAction]];
    
    CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:barrierTotalTime],[CCCallFunc actionWithTarget:self selector:@selector(endBarrer:)],nil];
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
    CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:sunTotalTime+0.05],[CCCallFunc actionWithTarget:self selector:@selector(endSun:)],nil];
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
        CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:sunTotalTime+0.1],[CCCallFunc actionWithTarget:self selector:@selector(endSun:)],nil];
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
            bezier.controlPoint_2 = ccp(900, 600);
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
        
        if ([Obstacle sharedObstacle].gameScene==kYLFC)
        {
            CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:turnTwoTotalTime],[CCCallFunc actionWithTarget:self selector:@selector(endTurnLeft:)],nil];
            [[[CCDirector sharedDirector] runningScene] runAction:removeSprite];
            
            [[Obstacle sharedObstacle] startTurnTwoLeft];
        }
        else
        {
            
        }
    }
    else
    {
        [turnRightSprite setVisible:true];
        CCActionInterval* spriteAction=[CCSequence actions:[CCFadeIn actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1], nil];
        [turnRightSprite runAction:[CCRepeatForever actionWithAction:spriteAction]];
        if ([Obstacle sharedObstacle].gameScene==kYLFC)
        {
            CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:turnTwoTotalTime],[CCCallFunc actionWithTarget:self selector:@selector(endTurnRight:)],nil];
            [[[CCDirector sharedDirector] runningScene] runAction:removeSprite];
            
            [[Obstacle sharedObstacle] startTurnTwoRight];
        }
        else
        {
            
        }
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

//红绿灯事件触发
-(void) startTraffic
{
    int random=arc4random()%2;
    if (random==0)   //R2G
    {
        [redLightSprite setVisible:true];
        CCActionInterval* spriteAction=[CCSequence actions:[CCFadeIn actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1], nil];
        [redLightSprite runAction:[CCRepeatForever actionWithAction:spriteAction]];
        
        CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:trafficLightTime],[CCCallFunc actionWithTarget:self selector:@selector(endTrafficLightR2G:)],nil];
        [[[CCDirector sharedDirector] runningScene] runAction:removeSprite];
        
        [[Obstacle sharedObstacle] startRed2Green];
    }
    else            //G2R
    {
        [greenLightSprite setVisible:true];
        CCActionInterval* spriteAction=[CCSequence actions:[CCFadeIn actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1], nil];
        [greenLightSprite runAction:[CCRepeatForever actionWithAction:spriteAction]];
        
        CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:trafficLightTime],[CCCallFunc actionWithTarget:self selector:@selector(endTrafficLightG2R:)],nil];
        [[[CCDirector sharedDirector] runningScene] runAction:removeSprite];
        
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
    if (isPause) return NO;
    
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
    if (fabs(accelerationY)>0.35)
    {
        if (isTurn) return;
        else if (accelerationY>0.35)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"拐弯音效.mp3"];
            [[Car sharedCar] turnRight];
            isTurn=true;
        
        }
        else if (accelerationY<-0.35)
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
    [[CCDirector sharedDirector] resume];
    [[SimpleAudioEngine sharedEngine] resumeAllEffect];
   // [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    
    [pauseBackgroundSprite setVisible:false];

    [normalSpeedMenu setEnabled:true];
    [speedUpMenu setEnabled:true];
    
    [resumeMenu setVisible:false];
    
    isPause=false;
}

-(void) pauseGame:(id)pSender
{
    isPause=true;
    [[CCDirector sharedDirector] pause];
    [[SimpleAudioEngine sharedEngine] pauseAllEffect];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    
    [normalSpeedMenu setEnabled:false];
    [speedUpMenu setEnabled:false];
    
    [pauseBackgroundSprite setVisible:true];
    [resumeMenu setVisible:true];
}

-(void) onEnter
{
    [super onEnter];
    [self start];
    //  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"BGM.mp3"];
    // [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.1];
}

-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [[SimpleAudioEngine sharedEngine] stopAllEffect];
    [super onExit];
}

@end
