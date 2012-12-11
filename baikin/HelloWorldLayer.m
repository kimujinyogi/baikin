//
//  HelloWorldLayer.m
//  baikin
//
//  Created by Kim JinHyuck on 12/12/10.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// タッチ
#import "TouchInterfaceLayer.h"

// 背景のボード
#import "BoardLayer.h"

// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

static HelloWorldLayer* _instance = nil;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (HelloWorldLayer*) shareInstance
{
    return _instance;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        if (_instance != nil)
        {
            NSLog(@"どこから？？？");
            abort();
        }
        
        _instance = self;
        
        TouchInterfaceLayer* touchLayer = [TouchInterfaceLayer node];
        [self addChild: touchLayer];
        
        BoardLayer* board = [BoardLayer node];
        
        [self addChild: board
                     z: 10
                   tag: 10];
        
    
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255,0,255,255)];
        colorLayer.contentSize = size;
        colorLayer.position = ccp(0, 0);
		
        [self addChild:colorLayer];

        
	}
    
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
