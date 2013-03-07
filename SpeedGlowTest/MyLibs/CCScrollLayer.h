//
//  CCScrollLayer.h
//  Museum
//
//  Created by GParvaneh on 29/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCScrollLayer : CCLayer {
	
	// Holds the current height and width of the screen
	int scrollHeight;
	int scrollWidth;
	
    int screenHeight;
    int screenWidth;
	
	// Holds the current page being displayed
	int currentScreen;
	
	// A count of the total screens available
	int totalScreens;
	
	// The initial point the user starts their swipe
	int startSwipe;
	
	NSInvocation *onPageMoved;
	NSInvocation *onClick;
}

@property (nonatomic, retain) NSInvocation *onPageMoved;
@property (nonatomic, retain) NSInvocation *onClick;
@property (nonatomic, readonly) int currentScreen;

-(id) initWithLayers:(NSMutableArray *)layers widthOffset: (int) widthOffset;

@end
