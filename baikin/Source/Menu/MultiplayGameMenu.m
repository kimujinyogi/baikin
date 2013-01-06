//
//  MultiplayGameMenu.m
//  baikin
//
//  Created by Kim JinHyuck on 2013/01/06.
//
//


#import "MultiplayGameMenu.h"

@interface MultiplayGameMenu ()

@property (nonatomic, retain) CCLabelTTF* localPlayerLabel;
@property (nonatomic, retain) CCLabelTTF* otherPlayerLabel;

@end

@implementation MultiplayGameMenu

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+ (CCScene*) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MultiplayGameMenu *layer = [MultiplayGameMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
    if ((self = [super init]))
    {
        [[MultiplayManager shareInstance] setDelegate: self];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        [self setLocalPlayerLabel: [CCLabelTTF labelWithString: @"MyName"
                                                      fontName: @"Helvetica-Bold"
                                                      fontSize: 20]];
        [self addChild: self.localPlayerLabel
                     z: 10];
        self.localPlayerLabel.position = ccp(50, size.height - 70);
        [self.localPlayerLabel setColor: ccc3(100, 100, 255)];
        [self.localPlayerLabel setContentSize: CGSizeMake(100, 50)];
        
        [self setOtherPlayerLabel: [CCLabelTTF labelWithString: @"otherPlayer"
                                                      fontName: @"Helvetica-Bold"
                                                      fontSize: 20]];
        [self addChild: self.otherPlayerLabel
                     z: 10];
        self.otherPlayerLabel.position = ccp(size.width - 50, size.height - 70);
        [self.otherPlayerLabel setColor: ccc3(100, 100, 255)];
        [self.otherPlayerLabel setContentSize: CGSizeMake(100, 50)];
        
        NSString* localName = [[[MultiplayManager shareInstance] getLocalPlayer] displayName];
        [[self localPlayerLabel] setString: localName];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}



#pragma mark - MultiplayManager delegate

// 自分の情報の取得が終了した
- (void) multiplayDidDownloadLocalPlayer: (GKPlayer*)player
{
    [[self localPlayerLabel] setString: [player displayName]];
}

// 相手の情報の取得が終了した
- (void) multiplayDidDownloadOtherPlayer: (GKPlayer*)player
{
    [[self otherPlayerLabel] setString: [player displayName]];
}

// 相手と接続が切れた
- (void) multiplayFailedConnect
{
    
}

@end














