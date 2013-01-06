//
//  MainRootLayer.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/25.
//
//


#import "MultiplayManager.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
// Import the interfaces
#import "HelloWorldLayer.h"

#import "MultiplayGameMenu.h"

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
        // GameCenterにログインしてないなら、する
        if ([GKLocalPlayer localPlayer].authenticated == NO)
            [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler: nil];
        
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
        
        CCMenuItemFont* item3 = [CCMenuItemFont itemWithString: @"マルチプレー"
                                                         block: ^(id sender)
                                 {
                                     [[CCDirector sharedDirector] replaceScene: [MultiplayGameMenu scene]];
                                     
                                     if (0)
                                     {
                                         GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
                                         request.minPlayers = 2;
                                         request.maxPlayers = 2;
                                         GKMatchmakerViewController* mmvc =
                                         [[[GKMatchmakerViewController alloc] initWithMatchRequest:request]
                                          autorelease];
                                         
                                         AppController* app = (AppController*) [[UIApplication sharedApplication] delegate];
                                         mmvc.matchmakerDelegate = self;
                                         
                                         [[app navController] presentViewController: mmvc
                                                                           animated: YES
                                                                         completion: nil];
                                     }
                                 }];
        
        CCMenu* menu = [CCMenu menuWithItems: item1, item2, item3, nil];
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


#pragma mark GameKit(Matching) delegate

// The user has cancelled matchmaking
- (void) matchmakerViewControllerWasCancelled: (GKMatchmakerViewController *)viewController
{
    [viewController dismissModalViewControllerAnimated: YES];
}

// Matchmaking has failed with an error
- (void) matchmakerViewController: (GKMatchmakerViewController*)viewController
                 didFailWithError: (NSError*)error
{
    if (error != nil)
        NSLog(@"%@", [error localizedDescription]);
    NSLog(@"wqjefiwejfi;");
}


- (void) matchmakerViewController: (GKMatchmakerViewController*)viewController
                     didFindMatch: (GKMatch*)match
{
    [viewController dismissModalViewControllerAnimated: YES];
    
    [[CCDirector sharedDirector] replaceScene: [MultiplayGameMenu scene]];
    
    // matchを保存して置く
    [[MultiplayManager shareInstance] setGameMatch: match];
}

// Players have been found for a server-hosted game, the game should start
- (void) matchmakerViewController: (GKMatchmakerViewController*)viewController
                   didFindPlayers: (NSArray*)playerIDs
{

}




@end








