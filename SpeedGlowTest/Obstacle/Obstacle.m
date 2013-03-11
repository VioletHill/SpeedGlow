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
 
    CMMotionManager* motionManager;
    float startDistance;
}

@synthesize barrierL=_barrierL;
@synthesize barrierR=_barrierR;
@synthesize gameScene=_gameScene;

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
    self.barrierL=false;
    self.barrierR=false;
    
    motionManager=[[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval=0.1;
    motionManager.deviceMotionUpdateInterval=0.1;
   // motionManager.
    [motionManager startDeviceMotionUpdates];
    [motionManager startAccelerometerUpdates];
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


-(double) getRotationRateByAcceleor
{
    CMAccelerometerData *newestAccel = motionManager.accelerometerData;
    double accelerationX = newestAccel.acceleration.x;
    double accelerationY = newestAccel.acceleration.y;
    double accelerationZ = newestAccel.acceleration.z;
    if (accelerationZ>0.5 || accelerationX>0.5 || accelerationY>0.5)
    NSLog(@"%f %f %f",accelerationX,accelerationY,accelerationZ);
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
}

-(void) checkCollisionL:(id)pSender
{
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
    [[SimpleAudioEngine sharedEngine] playEffect:@"路障提示音_L.mp3"];
    
    self.barrierL=true;
    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:barrierTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(checkCollisionL:)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) checkCollisionR:(id)pSender
{
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
    [[SimpleAudioEngine sharedEngine] playEffect:@"路障提示音_R.mp3"];
    
    self.barrierR=true;
    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:barrierTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(checkCollisionR:)],nil];
    
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

#pragma mark sun
/*
 太阳规则，在播放玩sun提示音后
 检测所在车道，如果和sun所在车道一致。成功吃到太阳
 */
-(void) checkSunL:(id)pSender
{
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
    [[SimpleAudioEngine sharedEngine] playEffect:@"sun提示L.mp3"];
    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:sunTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(checkSunL:)],nil];
    
    [[[CCDirector sharedDirector] runningScene] runAction:action];
    
}

-(void) checkSunR:(id)pSender
{
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
    [[SimpleAudioEngine sharedEngine] playEffect:@"sun提示R.mp3"];

    
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:sunTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(checkSunR:)],nil];
    
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

-(void) playTurnLeftEffect:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"向左转提示音单位.mp3"];
}

-(void) startTurnTwoLeft
{
    [Car sharedCar].isNeedTurnLeft=true;
    [[SimpleAudioEngine sharedEngine] playEffect:@"向左转提示音单位.mp3"];
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:turnOneTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(playTurnLeftEffect:)],[CCDelayTime actionWithDuration:turnOneTotalTime],[CCCallFunc actionWithTarget:self selector:@selector(checkTurnLeft:)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

-(void) checkTurnRight
{
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

-(void) playTurnRightEfect:(id)pSender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"向右转提示音单位.mp3"];
}

-(void) startTurnTwoRight
{
    [Car sharedCar].isNeedTurnRight=true;
    [[SimpleAudioEngine sharedEngine] playEffect:@"向右转提示音单位.mp3"];
    CCAction* action=[CCSequence actions:[CCDelayTime actionWithDuration:turnOneTotalTime], [CCCallFunc actionWithTarget:self selector:@selector(playTurnRightEfect:)],[CCDelayTime actionWithDuration:turnOneTotalTime],[CCCallFunc actionWithTarget:self selector:@selector(checkTurnRight)],nil];
    [[[CCDirector sharedDirector] runningScene] runAction:action];
}

@end
