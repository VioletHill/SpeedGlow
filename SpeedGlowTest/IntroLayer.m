//
//  IntroLayer.m
//  SpeedGlowTest
//
//  Created by 邱峰 on 13-1-1.
//  Copyright VioletHill 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) preloadMusic        //预载入每个场景都有的音效
{
    NSLog(@"preloadMusic");
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"按键音二双击.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"按键音一单击.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"滑屏音.mp3"];
    
    //场景音效
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"选择关卡.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"场景一.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"场景二.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"场景三.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"场景四.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"双击任意位置选择进入场景.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"左右滑屏左右上角.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"太阳总数.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"已获得太阳数量.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"已获得所有太阳.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"1.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"2.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"3.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"4.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"5.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"6.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"7.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"8.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"9.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"10.mp3"];
    
    
    //加载选择关卡的音效
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"选择难度.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"左上角返回主菜单右上角帮助文档.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"左右滑屏切换难度选择.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"一难度简单.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"二难度中等.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"三难度困难.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"排名第一.mp3"];
    
    
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"BGM.mp3"];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"游戏界面.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"321Go.mp3"];
    
    //车音效
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"变道L2R.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"变道R2L.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"拐弯音效"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"启动发车.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"常速行驶音效.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"加速音效.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"重启间隙2s.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"重启间隙4s.mp3"];
    
    
    //路障
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"路障提示音_L.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"路障提示音_R.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"路障超越L.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"路障超越R.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"撞到路障.mp3"];
    
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"货箱.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"路牌.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"猫咪.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"猫咪的惨叫.mp3"];
    
    
    //太阳
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"SunEatenL.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"SunEatenR.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sun提示L.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sun提示R.mp3"];
    
    //红绿灯
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"前方红灯转绿灯.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"前方绿灯转红灯.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"交通信号灯红灯03.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"交通信号灯绿灯03.mp3"];
    
    //转弯
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"完成转弯提示音.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"向右转提示音单位.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"向左转提示音单位.mp3"];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"欢呼.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"嘘声.mp3"];
    
    //帮助-音效
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"当前页音效页.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"上下滚动切换查看不同音效.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"向右滑屏切换操作页.mp3"];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"音效提示路障L.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"音效提示路障R.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"红绿灯红转绿音效.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"红绿灯绿转红音效.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"音效提示转弯左+右.mp3"];
    
    //帮助-规则
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"1规则车道.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"2规则障碍物.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"3规则刹车键.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"4规则动力加速键.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"5规则红灯.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"6规则惩罚.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"7规则解锁比赛.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"8规则吃太阳.mp3"];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"当前页规则页.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"规则说明.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"上下滚动切换查看不同规则.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"向左滑屏切换操作页.mp3"];
}

-(void) preloadNum
{
    for (int i=0; i<10; i++)
    {
        CCSpriteFrame* smallNumFrame=[CCSpriteFrame frameWithTextureFilename:[NSMutableString stringWithFormat:(@"small%d.png"),i] rect:CGRectMake(0, 0, 30, 30)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:smallNumFrame name:[NSMutableString stringWithFormat:(@"small%d"),i]];
        
        CCSpriteFrame* sunNumFrame=[CCSpriteFrame frameWithTextureFilename:[NSMutableString stringWithFormat:(@"SunNum%d.png"),i] rect:CGRectMake(0, 0, 26, 38)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:sunNumFrame name:[NSMutableString stringWithFormat:@"SunNum%d",i]];
    }
}
//
-(id) init
{
	if( (self=[super init])) {
   
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
        
        [self preloadMusic];
        [self preloadNum];
	}
	
	return self;
}


-(void) onEnter
{

    
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.1 scene:[MainMenuScene scene]]];
    
}
@end
