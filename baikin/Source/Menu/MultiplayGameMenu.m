//
//  MultiplayGameMenu.m
//  baikin
//
//  Created by Kim JinHyuck on 2013/01/06.
//
//


#import "CharLayer.h"
#import "HelloWorldLayer.h"

#import "MultiplayGameMenu.h"

@interface MultiplayGameMenu ()
{
@private
    // 開始を知らせるカウントダウンの物
    int startCount_;
    BOOL isFirstMyTurn_;
}

@property (nonatomic, retain) CCLabelTTF* localPlayerLabel;
@property (nonatomic, retain) CCLabelTTF* otherPlayerLabel;
@property (nonatomic, retain) CCLabelTTF* firstTurnPlayerLabel;
@property (nonatomic, retain) CCLabelTTF* countLabel;

// @brief ゲーム開始のカウントダウンを始める
// Author JinHyuck Kim
- (void) countDownStart;

// @brief 先攻ユーザーを表示する
// Author JinHyuck Kim
- (void) setFirstStartPlayerLabel;


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
        startCount_ = -1;
        
        [[MultiplayManager shareInstance] setDelegate: self];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        [self setLocalPlayerLabel: [CCLabelTTF labelWithString: @"MyName"
                                                      fontName: @"Helvetica-Bold"
                                                      fontSize: 20]];
        [self addChild: self.localPlayerLabel
                     z: 10];
        self.localPlayerLabel.position = ccp(50, size.height - 70);
        [self.localPlayerLabel setColor: ccc3(100, 100, 255)];
        [self.localPlayerLabel setContentSize: CGSizeMake(100, 80)];
        
        [self setOtherPlayerLabel: [CCLabelTTF labelWithString: @"otherPlayer"
                                                      fontName: @"Helvetica-Bold"
                                                      fontSize: 20]];
        [self addChild: self.otherPlayerLabel
                     z: 10];
        self.otherPlayerLabel.position = ccp(size.width - 50, size.height - 70);
        [self.otherPlayerLabel setColor: ccc3(100, 100, 255)];
        [self.otherPlayerLabel setDimensions: CGSizeMake(100, 80)];
        
        NSString* localName = [[[MultiplayManager shareInstance] getLocalPlayer] displayName];
        [[self localPlayerLabel] setString: localName];
        
        
        [self setFirstTurnPlayerLabel: [CCLabelTTF labelWithString: @"先攻を決定中"
                                                          fontName: @"Helvetica-Bold"
                                                          fontSize: 20]];
        [self addChild: self.firstTurnPlayerLabel
                     z: 10];
        self.firstTurnPlayerLabel.position = ccp(size.width * 0.5f, 100);
        [self.firstTurnPlayerLabel setColor: ccc3(180, 180, 180)];
        [self.firstTurnPlayerLabel setDimensions: CGSizeMake(300, 100)];
        
        [self setCountLabel: [CCLabelTTF labelWithString: @"3"
                                                fontName: @"Helvetica-Bold"
                                                fontSize: 32]];
        [self addChild: self.countLabel
                     z: 10];
        self.countLabel.position = ccp(size.width * 0.5f, size.height * 0.5f);
        [self.countLabel setColor: ccc3(180, 180, 180)];
        [self.countLabel setDimensions: CGSizeMake(140, 140)];
        
        // 準備ボタン
//        CGSize size = [[CCDirector sharedDirector] winSize];
        // メニュー
        [CCMenuItemFont setFontName: @"Helvetica-Bold"];
        [CCMenuItemFont setFontSize: 24];
        __block BOOL isReady = NO;
        CCMenuItemFont* item1 = [CCMenuItemFont itemWithString: @"Ready"
                                                         block: ^(CCMenuItemFont* sender)
                                 {
                                     if (isReady == NO)
                                     {
                                         isReady = YES;
                                         [sender setColor: ccc3(100, 150, 100)];
                                     }
                                 }];
        [item1 setColor: ccc3(150, 100, 100)];
        
        CCMenu* menu = [CCMenu menuWithItems: item1, nil];
        [menu alignItemsVerticallyWithPadding: 45];
        menu.position = CGPointMake(size.width / 2, 20);
        
        [self addChild: menu
                     z: 1];
    }
    
    return self;
}

- (void) dealloc
{
    [self setLocalPlayerLabel: nil];
    [self setOtherPlayerLabel: nil];
    [self setFirstTurnPlayerLabel: nil];
    [self setCountLabel: nil];
    [super dealloc];
}



#pragma mark - Private method




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
    
    if ([[MultiplayManager shareInstance] seekBatFirst] == YES)
    {
        isFirstMyTurn_ = ((rand() % 2) == 1) ? YES : NO;
        
        if (isFirstMyTurn_ == YES)
        {
            MultiplayManager* manager = [MultiplayManager shareInstance];
            [manager sendFirstTurn: [[manager getLocalPlayer] playerID]];
        }
        else
        {
            MultiplayManager* manager = [MultiplayManager shareInstance];
            [manager sendFirstTurn: [[manager getOtherPlayer] playerID]];
        }
        
        [self setFirstStartPlayerLabel];
        [self countDownStart];
    }
}

// 先攻を決めるプレイヤーから、先攻者のIDが送られた
- (void) multiplayDidSeekFirstTurn: (NSString*)playerID
{
    isFirstMyTurn_ = [[[[MultiplayManager shareInstance] getLocalPlayer] playerID] isEqualToString: playerID];
    
    [self setFirstStartPlayerLabel];
    [self countDownStart];
}

// 相手と接続が切れた
- (void) multiplayFailedConnect
{
    
}

- (void) countDownProc
{
    startCount_--;
    if (startCount_ < 0)
    {
        // ゲーム開始
        [[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
        [[[HelloWorldLayer shareInstance] charaLayer] setPlayerBlue: isFirstMyTurn_];
    }
    else
    {
        [[self countLabel] setString: [NSString stringWithFormat: @"%d", startCount_]];
    }
}

// @brief ゲーム開始のカウントダウンを始める
// Author JinHyuck Kim
- (void) countDownStart
{
    if (startCount_ < 0)
    {
        startCount_ = 3;
        [self schedule: @selector(countDownProc)
              interval: 1
                repeat: 3
                 delay: 5];
    }
}


// @brief 先攻ユーザーを表示する
// Author JinHyuck Kim
- (void) setFirstStartPlayerLabel
{
    NSString* str = @"先攻 : ";
    NSString* name = @"";
    MultiplayManager* manager = [MultiplayManager shareInstance];
    if (isFirstMyTurn_ == YES)
        name = [[manager getLocalPlayer] displayName];
    else
        name = [[manager getOtherPlayer] displayName];
    
    [[self firstTurnPlayerLabel] setString: [NSString stringWithFormat: @"%@%@", str, name]];
}

@end














