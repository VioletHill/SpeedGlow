//
//  Obstacle.m
//  SpeedGlowTest
//
//  Created by VioletHill on 13-2-26.
//  Copyright (c) 2013年 VioletHill. All rights reserved.
//

#import "Obstacle.h"
#import "SimpleAudioEngine.h"
#import "cocos2d.h"
#import "Car.h"
#import <CoreMotion/CoreMotion.h>

@implementation Obstacle
{
    float startDistance;
    
    ALuint barrierEffect;
    ALuint turnEffect;
    ALuint sunEffect;
}

@synthesize barrierL=_barrierL;
@synthesize barrierR=_barrierR;
@synthesize gameScene=_gameScene;
@synthesize sunTotalTime=_sunTotalTime;
@synthesize barrierTotalTime=_barrierTotalTime;
@synthesize turnTotalTime=_turnTotalTime;

static Obstacle* obstacle;

+(Obstacle*) sharedObstacle
{
    if (obstacle==nil)
    {
        obstacle=[[Obstacle alloc] init];
    }
    return obstacle;
}



-(id) init
{
    if (self=[super init])
    {
        
    }
    
    return  self;
}

-(double) getRotationRate
{
   // CMRotationRate rotationRate=motionManager.deviceMotion.rotationRate;
 //   NSLog(@"%f %f %f\n\n",rotationRate.x,rotationRate.y,rotationRate.z);
    
    ///xy 旋转角度   z翻转角度
//    double gravityX = motionManager.deviceMotion.gravity.x;
//    double gravityY = motionManager.deviceMotion.gravity.y;
//    double gravityZ = motionManager.deviceMotion.gravity.z;
//    
//    double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
//    
//    double xyTheta = atan2(gravityX,gravityY)/M_PI*180.0;
//   // double xzTheta = atan2(gravityZ, gravityX)/M_PI*180.0;
//  //  double yzTheta = atan2(gravityZ, gravityY)/M_PI*180.0;
//  //  NSLog(@"%f %f",xyTheta,zTheta);
//     NSLog(@"%f %f %f %f %f",gravityX*10,gravityY*10,gravityZ*10,xyTheta,zTheta);
//   // motionManager.deviceMotion.attitude
//    return rotationRate.y;
   // return motionManager.deviceMotion.attitude.roll;
  //  CMAccelerometerData *newestAccel = motionManager.accelerometerData;
   // double accelerationX = newestAccel.acceleration.x;
   // double accelerationY = newestAccel.acceleration.y;
   // double accelerationZ = newestAccel.acceleration.z;
   // if (accelerationZ>0.5 || accelerationX>0.5 || accelerationY>0.5)
   //     NSLog(@"%f %f %f",accelerationX,accelerationY,accelerationZ);
 //   NSLog(@"%f %f %f",motionManager.deviceMotion.attitude.roll,motionManager.deviceMotion.attitude.pitch,motionManager.deviceMotion.attitude.yaw);
  //  CMRotationRate* rotation;
   // [rota];
    return 0;
}

#pragma mark barrier
/*
 障碍物规则
 在播放完音效后
 检测所在车道，如果与所在车道一致，则碰撞障碍物，并随机产生碰撞类型
 否则躲避障碍物
 */
-(void) playEffectBox:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"货箱.mp3"];
}

-(void) playEffectSign:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"路牌.mp3"];
}

-(void) playEffectCat:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"猫咪.mp3"];
}

-(void) playEffectTree:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"倒下的树.mp3"];
}

-(void) playEffectCar:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"车辆.mp3"];
}

-(void) playEffectThunder:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"雷电.mp3"];
}

-(void) playEffectStone:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"大石头.mp3"];
}

-(void) playEffectBicycle:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"自行车.mp3"];
}

-(void) playEffectHouse:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"木屋.mp3"];
}

-(void) playEffectSnow:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"陷入雪堆.mp3"];
}

-(void) playEffectHuman:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"行人.mp3"];
}

-(void) collisionBarrier
{
    if (self.gameScene==kYLFC)
    {
        int value = arc4random() % 3;
        CCAction* action;
        switch (value)
        {
            case 0:
                [[Car sharedCar] collisionBox];
                [[SimpleAudioEngine sharedEngine] playEffect:@"撞到路障.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectBox:)], nil];
                break;
            case 1:
                 [[Car sharedCar] collisionBox];
                [[SimpleAudioEngine sharedEngine] playEffect:@"撞到路障.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectSign:)], nil];
                break;
            case 2:
                [[Car sharedCar] collisionCat];
                [[SimpleAudioEngine sharedEngine] playEffect:@"猫咪的惨叫.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectCat:)],nil];
                break;
        }
        [[[CCDirector sharedDirector] runningScene] runAction:action];
    }
    else if (self.gameScene==kBYYM)
    {
        int value = arc4random() % 3;
        CCAction* action;
        switch (value)
        {
            case 0:
                [[Car sharedCar] collisionBox];
                [[SimpleAudioEngine sharedEngine] playEffect:@"撞到路障.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectBox:)], nil];
                break;
            case 1:
                [[Car sharedCar] collisionCar];
                [[SimpleAudioEngine sharedEngine] playEffect:@"撞到路障.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectCar:)], nil];
                break;
            case 2:
                [[Car sharedCar] collisionThunder];
                [[SimpleAudioEngine sharedEngine] playEffect:@"雷声.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectThunder:)],nil];
                break;
        }
        [[[CCDirector sharedDirector] runningScene] runAction:action];
    }
    else if (self.gameScene==kMWTJ)
    {
        int value = arc4random() % 3;
        CCAction* action;
        switch (value)
        {
            case 0:
                [[Car sharedCar] collisionBox];
                [[SimpleAudioEngine sharedEngine] playEffect:@"撞到路障.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectBox:)], nil];
                break;
            case 1:
                [[Car sharedCar] collisionStone];
                [[SimpleAudioEngine sharedEngine] playEffect:@"撞到路障.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectStone:)], nil];
                break;
            case 2:
                [[Car sharedCar] collisionBicycle];
                [[SimpleAudioEngine sharedEngine] playEffect:@"自行车声音.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectBicycle:)],nil];
                break;
        }
        [[[CCDirector sharedDirector] runningScene] runAction:action];

    }
    else if (self.gameScene==kXBTW)
    {
        int value = arc4random() % 3;
        CCAction* action;
        switch (value)
        {
            case 0:
                [[Car sharedCar] collisionHouse];
                [[SimpleAudioEngine sharedEngine] playEffect:@"撞到路障.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectHouse:)], nil];
                break;
            case 1:
                [[Car sharedCar] collisionSnow];
                [[SimpleAudioEngine sharedEngine] playEffect:@"撞到路障.mp3"];
                action=[CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(playEffectSnow:)], nil];
                break;
            case 2:
                [[Car sharedCar] collisionHuman];
                [[SimpleAudioEngine sharedEngine] playEffect:@"惨叫.mp3"];
                action=[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(playEffectHuman:)],nil];
                break;
        }
        [[[CCDirector sharedDirector] runningScene] runAction:action];
    }
}

-(void) checkCollisionL:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] stopEffect:barrierEffect];
    if ([Car sharedCar].lane==kLEFT_LAND)
    {
        [self collisionBarrier];
    }
    else
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"路障超越L.mp3"];
    }
    self.barrierL=false;
}

-(void) startBarrierL
{
    barrierEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"路障提示音_L.mp3" loop:true];
    
    self.barrierL=true;
    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].barrierTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(checkCollisionL:)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) checkCollisionR:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] stopEffect:barrierEffect];
    if ([Car sharedCar].lane==kRIGHT_LAND)
    {
        [self collisionBarrier];
    }
    else
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"路障超越R.mp3"];
    }
    self.barrierR=false;
}

-(void) startBarrierR
{
    barrierEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"路障提示音_R.mp3" loop:true];
    
    self.barrierR=true;
    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].barrierTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(checkCollisionR:)],nil];
    
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

#pragma mark sun
/*
 太阳规则，在播放玩sun提示音后
 检测所在车道，如果和sun所在车道一致。成功吃到太阳
 */
-(void) checkSunL:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] stopEffect:sunEffect];
    if ([Car sharedCar].lane==kLEFT_LAND)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"SunEatenL.mp3"];
        [Car sharedCar].isEatSun=true;
        [[Car sharedCar] eatSun];
    }
    [Car sharedCar].isFinishSun=true;
}

-(void) startSunL
{
    sunEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"sun提示L.mp3" loop:true];
    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].sunTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(checkSunL:)],nil];
    
    [[[CCDirector sharedDirector] runningScene] runAction:action];
    
}

-(void) checkSunR:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] stopEffect:sunEffect];
    if ([Car sharedCar].lane==kRIGHT_LAND)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"SunEatenR.mp3"];
        [Car sharedCar].isEatSun=true;
        [[Car sharedCar] eatSun];
    }
    [Car sharedCar].isFinishSun=true;
}

-(void) startSunR
{
    
    sunEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"sun提示R.mp3" loop:true];

    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].sunTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(checkSunR:)],nil];
    
    [[[CCDirector sharedDirector] runningScene] runAction:action];

}

#pragma mark trafficLight

/*
    红绿灯规则：
    红灯转绿灯： 
        在播放玩红灯转绿灯后  测试距离
        在播放完红灯转绿灯的音效后 在红灯时间内形式距离不能超过 
            trafficeLightTime/3*2*normalSpeed+trafficLightTime/3*accelerateSpeed
        在播放完绿灯转红灯的音效后 在绿灯时间内形式距离不能低于 
            trafficeLightTime/3*2*accelerateSpeed+trafficLightTime/2*normalSpeed
            
 
 
*/

-(void) checkRed2Green:(id)pSender
{
    //计算这3s的时间行驶距离 看时候通过红绿灯测试
    if ([Car sharedCar].nowDistance-startDistance>trafficLightTime/3*2*normalSpeed+trafficLightTime/3*accelerateSpeed)    //失败
    {
        [[Car sharedCar] breakRedLight];
      
    }
    else
    {
        //通过
    }
}

-(void) startRed2GreenEffect:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"交通信号灯红灯03.mp3"];
    startDistance=[Car sharedCar].nowDistance;
    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:trafficLightTime],[CCCallFunc actionWithTarget:self selector:@selector(checkRed2Green:)], nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) startRed2Green
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"前方红灯转绿灯.mp3"];
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:trafficReadyTime],[CCCallFunc actionWithTarget:self selector:@selector(startRed2GreenEffect:)], nil];
    [[[CCDirector sharedDirector] runningScene] runAction: action];
}


-(void) checkGreen2Red:(id) pSender
{
    if ([Car sharedCar].nowDistance-startDistance<  trafficLightTime/3*2*accelerateSpeed+trafficLightTime/2*normalSpeed)    //失败
    {
        [[Car sharedCar] breakRedLight];
    }
    else
    {
        
    }
}

-(void) startGreen2RedEffect:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"交通信号灯绿灯03.mp3"];
    startDistance=[Car sharedCar].nowDistance;
    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:trafficLightTime], [CCCallFunc actionWithTarget:self selector:@selector(checkGreen2Red:)],nil];
    
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) startGreen2Red
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"前方绿灯转红灯.mp3"];
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:trafficReadyTime], [CCCallFunc actionWithTarget:self selector:@selector(startGreen2RedEffect:)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
    
}

#pragma turn
-(void) checkTurnLeft:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] stopEffect:turnEffect];
    if (![Car sharedCar].isNeedTurnLeft)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"完成转弯提示音.mp3"];
    }
    else
    {
        [Car sharedCar].isNeedTurnLeft=false;
        [[SimpleAudioEngine sharedEngine] playEffect:@"撞到路障.mp3"];
        [[Car sharedCar] turnFail];
    }
}


-(void) checkTurnRight
{
    [[SimpleAudioEngine sharedEngine] stopEffect:turnEffect];
    if (![Car sharedCar].isNeedTurnRight)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"完成转弯提示音.mp3"];
    }
    else
    {
        [Car sharedCar].isNeedTurnRight=false;
        [[SimpleAudioEngine sharedEngine] playEffect:@"撞到路障.mp3"];
        [[Car sharedCar] turnFail];
    }
}

-(void) startTurnLeft
{
    [Car sharedCar].isNeedTurnLeft=true;
    turnEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"向左转提示音单位.mp3" loop:true];
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].turnTotalTime],[CCCallFunc actionWithTarget:self selector:@selector(checkTurnLeft:)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) startTurnRight
{
    [Car sharedCar].isNeedTurnRight=true;
    turnEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"向右转提示音单位.mp3" loop:true];
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:[Obstacle sharedObstacle].turnTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(checkTurnRight)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];

}

@end
