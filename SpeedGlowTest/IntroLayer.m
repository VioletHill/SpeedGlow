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
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"按键音二双击.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"按键音一单击.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"滑屏音.mp3"];
}

// 
-(id) init
{
	if( (self=[super init])) {
        

        
        [[CCTextureCache sharedTextureCache] addImage:@"YlfcScrollLayer.png"];
        [[CCTextureCache sharedTextureCache] addImage:@"ByymScrollLayer.png"];
        [[CCTextureCache sharedTextureCache] addImage:@"MytjScrollLayer.png"];
        [[CCTextureCache sharedTextureCache] addImage:@"XbtwScrollLayer.png"];
        
        [[CCTextureCache sharedTextureCache] addImage:@"FrameLayer.png"];
        // [[CCTextureCache sharedTextureCache] addImage:@"YlfcBackground.png"];
        // [[CCTextureCache sharedTextureCache] addImage:@"FrameLayer.png"];
        // [[CCTextureCache sharedTextureCache] addImage:@"YlfcTitle.png"];
        // [[CCTextureCache sharedTextureCache] addImage:@"ByymTitle.png"];
        // [[CCTextureCache sharedTextureCache] addImage:@"MytjTitle.png"];
        // [[CCTextureCache sharedTextureCache] addImage:@"XbtwTitle.png"];
        
//        [CCSprite spriteWithFile:@"YlfcScrollLayer.png"];
//        [CCSprite spriteWithFile:@"ByymScrollLayer.png"];
//        [CCSprite spriteWithFile:@"MytjScrollLayer.png"];
//        [CCSprite spriteWithFile:@"XbtwScrollLayer.png"];
//        
//        [CCSprite spriteWithFile:@"YlfcBackground.png"];
//        [CCSprite spriteWithFile:@"FrameLayer.png"];
//        [CCSprite spriteWithFile:@"YlfcTitle.png"];
//        [CCSprite spriteWithFile:@"ByymTitle.png"];
//        [CCSprite spriteWithFile:@"MytjTitle.png"];
//        [CCSprite spriteWithFile:@"XbtwTitle.png"];
        
   
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
	}
	
	return self;
}


-(void) onEnter
{

    
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.1 scene:[MainMenuScene scene]]];
    
}
@end
