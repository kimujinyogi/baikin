//
//  MainRootLayer.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/25.
//
//


// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
// Import the interfaces
#import "HelloWorldLayer.h"

#import "MainRootLayer.h"

@implementation MainRootLayer



// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+ (CCScene*) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainRootLayer *layer = [MainRootLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


- (id) init
{
    if ((self = [super init]))
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
       
        [CCMenuItemFont setFontName: @"Helvetica-Bold"];
        [CCMenuItemFont setFontSize: 24];
        CCMenuItemFont* item1 = [CCMenuItemFont itemWithString: @"一人プレー"
                                                        block: ^(id sender)
                                {
                                    [[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
                                }];
        
        CCMenuItemFont* item2 = [CCMenuItemFont itemWithString: @"二人プレー"
                                                        block: ^(id sender)
                                {
                                    [[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
                                }];
        
        CCMenu* menu = [CCMenu menuWithItems: item1, item2, nil];
        [menu alignItemsVerticallyWithPadding: 45];
        menu.position = CGPointMake(winSize.width / 2, winSize.height / 2);
        [self addChild: menu];
    }
    
    return self;
}

- (void) dealloc
{
    
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish: (GKAchievementViewController*)viewController
{
	AppController* app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated: YES];
}

-(void) leaderboardViewControllerDidFinish: (GKLeaderboardViewController*)viewController
{
	AppController* app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated: YES];
}

@end








