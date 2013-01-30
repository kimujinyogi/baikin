//
//  HelloWorldLayer.m
//  baikin
//
//  Created by Kim JinHyuck on 12/12/10.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// タッチ
#import "TouchInterfaceLayer.h"

// キャラクターのレイヤー
#import "CharLayer.h"

// 背景のボード
#import "MenuLayer.h"
#import "BoardLayer.h"

// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer ()
{
    CharLayer* charaLayer_;
    MenuLayer* menuLayer_;
}


@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize
charaLayer = charaLayer_,
menuLayer = menuLayer_;

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
	if((self = [super init]))
    {
        if (_instance != nil)
        {
            NSLog(@"どこから？？？");
            abort();
        }
        
        _instance = self;
        
        TouchInterfaceLayer* touchLayer = [TouchInterfaceLayer node];
        [self addChild: touchLayer
                     z: 0];
        
        BoardLayer* board = [BoardLayer node];
        
        [self addChild: board
                     z: 10
                   tag: 10];
        
        charaLayer_ = [[CharLayer node] retain];
        [self addChild: charaLayer_
                     z: 20];
        
        menuLayer_ = [[MenuLayer node] retain];
        [self addChild: menuLayer_
                     z: 30];
        
        CGPoint blue[2];
        CGPoint red[2];
        blue[0] = ccp(0, 0);
        blue[1] = ccp(6, 6);
        
        red[0] = ccp(6, 0);
        red[1] = ccp(0, 6);
        
        [charaLayer_ setStartCharaSetRedPositions: red
                                    BluePositions: blue
                                            Count: 2];
    
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(200,200,200,255)];
        colorLayer.contentSize = size;
        colorLayer.position = ccp(0, 0);
		
        [self addChild:colorLayer];
	}
    
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [charaLayer_ release];
    [menuLayer_ release];
    _instance = nil;
    
	[super dealloc];
}

- (void) setPlayerBlue: (BOOL)blueFlag
{
    
}

@end











