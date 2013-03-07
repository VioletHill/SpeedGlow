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
#import "PauseLayer.h"


@implementation PlayGameScene
{
    int startSwipe;
    WhichObstacle obstacle[40];        //障碍物种类
    float obstacleDistance[40];       //障碍物之间距离
    int totalObstacle;
    int streetLenth;
    int indexObstacle;
    
    CCSprite* turnLeftSprite;
    CCSprite* turnRightSprite;
    CCSprite* sunSprite;
    CCSprite* barrierSprite;
    CCSprite* greenLightSprite;
    CCSprite* redLightSprite;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	PlayGameScene *layer = [PlayGameScene node];
	[scene addChild: layer];
	return scene;
    
}

-(void) updateRo:(ccTime)delta
{
    //NSLog(@"%f",[[Obstacle sharedObstacle] getRotationRate]);
    [[Obstacle sharedObstacle] getRotationRate];
  //  [[Obstacle sharedObstacle] getRotationRateByAcceleor];
}

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
                distance=obstacleDistance[i]+trafficeLightTime*accelerateSpeed;
                break;
            default:
                break;
        }
        //把最后一个障碍物给第一个 这样可以保证生成效率
        obstacleArray[which]=obstacleArray[x-1];
    }
}

-(void) startGo:(id)pSender
{
    [[Car sharedCar] start:kLEFT_LAND];
    
    [self schedule:@selector(updateDistance:) interval:0.1];
    [self schedule:@selector(updateObstacle:) interval:0.1];
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) ready:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"321Go.mp3"];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3],[CCCallFunc actionWithTarget:self selector:@selector(startGo:)],nil]];
}

-(void) start
{
    indexObstacle=0;
    [Car sharedCar].nowDistance=0;
    [Car sharedCar].speed=noSpeed;
    [Car sharedCar].isNeedStop=true;
    [self unscheduleAllSelectors];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(ready:)],nil]];
    [self loadYlfcSceneMap];
}
-(void) addBarrier
{
    CGSize screenSize=[[CCDirector sharedDirector] winSize];
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

-(id) init
{
    if (self=[super init])
    {
    
        CCMenuItemImage* stopItem=[CCMenuItemImage itemWithNormalImage:@"Stop.png" selectedImage:nil target:self selector:@selector(lowSpeed:)];
        CCMenu* stopMenu=[CCMenu menuWithItems:stopItem, nil];
        stopMenu.position=ccp(100,100);
        [self addChild:stopMenu];
        
        CCMenuItemImage *pauseItem=[CCMenuItemImage itemWithNormalImage:@"Pause.png" selectedImage:nil target:self selector:@selector(pauseGame:)];
        CCMenu *pauseMenu=[CCMenu menuWithItems:pauseItem, nil];
        pauseMenu.position=ccp(100,600);
        [self addChild:pauseMenu];
        
        
        [self addBarrier];
        [self start];

    }
    return self;
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
            default:
                break;
        }
        indexObstacle++;
    }
}


-(void) pauseGame:(id)pSender
{
    NSLog(@"asfsd");
   // NSLog(@"pause");
   // [[CCDirector sharedDirector] pause];
    //ccColor4B c = {0,0,0,150};

   // [PauseLayer layerWithColor:c delegate:self];
  //  [[SimpleAudioEngine sharedEngine] pauseAllEffect];
  //  [[SimpleAudioEngine sharedEngine] pauseAllEffect];
 
    
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
    [sunSprite setVisible:true];
    CCActionInterval* spriteAction=[CCSequence actions:[CCFadeIn actionWithDuration:0.1],[CCFadeOut actionWithDuration:0.1], nil];
    [sunSprite runAction:[CCRepeatForever actionWithAction:spriteAction]];
    
    CCAction* removeSprite=[CCSequence actions:[CCDelayTime actionWithDuration:sunTotalTime],[CCCallFunc actionWithTarget:self selector:@selector(endSun:)],nil];
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

-(void) endSun:(id)pSender
{
    [sunSprite stopAllActions];
    [sunSprite setVisible:false];
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
    
}

-(void) lowSpeed:(id)pSender
{
    if ([Car sharedCar].isNeedStop) return ;
    [Car sharedCar].speed=normalSpeed;
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{    
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
  
	
    if ( (newX - startSwipe< -20) && [Car sharedCar].isChangeLand==false )
    {
        [[Car sharedCar] changeLandFromL2R];
    }
    else if ( (newX - startSwipe > 20) && [Car sharedCar].isChangeLand==false )
    {
        [[Car sharedCar] changeLandFromR2L];
    }


}

@end
