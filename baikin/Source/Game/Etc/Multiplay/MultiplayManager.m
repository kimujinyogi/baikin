//
//  MultiplayManager.m
//  baikin
//
//  Created by Kim JinHyuck on 2013/01/05.
//
//

#import "MultiplayManager.h"

@interface MultiplayManager ()

@property (nonatomic, retain) GKMatch* match;
@property (nonatomic, retain) GKPlayer* otherPlayer;

// プレイヤーの配列を渡して、画面を更新する処理
- (void) updateOtherPlayerLabelWithPlayerIDs: (NSArray*)array;

// 先攻を決めるメソッド
- (BOOL) seekBatFirst;

@end

@implementation MultiplayManager

static MultiplayManager* _instance;

- (id) init
{
    if (_instance != nil)
    {
        NSLog(@"来てはいけない");
        abort();
    }
    
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

- (void) dealloc
{
    [self setDelegate: nil];
    [[self match] setDelegate: nil];
    [self setMatch: nil];
    [self setOtherPlayer: nil];
    _instance = nil;
    [super dealloc];
}

+ (MultiplayManager*) shareInstance
{
    if (_instance == nil)
    {
        _instance = [[MultiplayManager alloc] init];
    }
    
    return _instance;
}

+ (void) deleteInstance
{
    [_instance release];
    _instance = nil;
}


- (void) setGameMatch: (GKMatch*)match
{
    [self setMatch: match];
    [[self match] setDelegate: self];
    NSLog(@"%@", [match playerIDs]);
    if ([match playerIDs] != nil)
        [self updateOtherPlayerLabelWithPlayerIDs: [match playerIDs]];
}

- (GKPlayer*) getLocalPlayer
{
    return [GKLocalPlayer localPlayer];
}

- (GKPlayer*) getOtherPlayer
{
    return self.otherPlayer;
}


#pragma mark - 通信

// 相手にタッチしたポイント(X,Y何番目)を送信するメソッド
- (void) sendTouchPoint: (CGPoint)point
{
    NSError* error = nil;
    
    NSData* data = [NSData dataWithBytes:"ABC" length:3];
    
    [[self match] sendDataToAllPlayers: data
                          withDataMode: GKMatchSendDataUnreliable
                                 error: &error];
    if (error != nil)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else
    {
        NSLog(@"送信できた？かな。？");
    }
}


#pragma mark - Private mathod
// プレイヤーの配列を渡して、画面を更新する処理
- (void) updateOtherPlayerLabelWithPlayerIDs: (NSArray*)array
{
    [GKPlayer loadPlayersForIdentifiers: array
                  withCompletionHandler: ^(NSArray *players, NSError *error)
     {
         // ここは相手プレーヤーは一人
         if (error != nil)
         {
             NSLog(@"プレーヤーの情報の取得に失敗 : %@", [error localizedDescription]);
         }
         else
         {
             [self setOtherPlayer: [players lastObject]];
             [self.delegate multiplayDidDownloadOtherPlayer: self.otherPlayer];
             UIAlertView* alert = [[[UIAlertView alloc] initWithTitle: [NSString stringWithFormat: @"俺は先攻%@", [self seekBatFirst] == YES ? @"だ" : @"ではない"]
                                                              message: @""
                                                             delegate: nil
                                                    cancelButtonTitle: @"ok"
                                                    otherButtonTitles: nil] autorelease];
             [alert show];
         }
     }];
}

- (BOOL) seekBatFirst
{
    NSString* myID = [[GKLocalPlayer localPlayer] playerID];
    NSString* enemyID = [[self otherPlayer] playerID];
    
    NSString* lastMyID = [myID substringFromIndex: 1];
    NSString* lastEnemyID = [myID substringFromIndex: 1];
    NSLog(@"%@, %@", myID, enemyID);
    return [myID compare: enemyID] == NSOrderedAscending ? YES : NO;
}


#pragma mark - Match Delegate

// The match received data sent from the player.
- (void) match: (GKMatch*)match
didReceiveData: (NSData*)data
    fromPlayer: (NSString*)playerID
{
    NSString* str = [[NSString alloc] initWithBytes: [data bytes]
                                             length: 3
                                           encoding: NSUTF8StringEncoding];
    NSLog(@"str = %@", str);
    NSLog(@"%@", playerID);
    // 相手からデータをもらったので、更新させる？
}


// The player state changed (eg. connected or disconnected)
- (void) match: (GKMatch*)match
        player: (NSString*)playerID
didChangeState: (GKPlayerConnectionState)state
{
//    GKPlayerStateUnknown,       // initial player state
//    GKPlayerStateConnected,     // connected to the match
//    GKPlayerStateDisconnected   // disconnected from the match
    NSLog(@"player = %@, state = %d", playerID, state);
    if (state == GKPlayerStateDisconnected)
    {
        [self.delegate multiplayFailedConnect];
    }
    else if (state == GKPlayerStateConnected)
    {
        [self updateOtherPlayerLabelWithPlayerIDs: @[playerID]];
    }
}

// The match was unable to be established with any players due to an error.
- (void) match: (GKMatch*)match
didFailWithError: (NSError*)error
{
    NSLog(@"eerrroror");
    NSLog(@"%@", [error localizedDescription]);
    [self.delegate multiplayFailedConnect];
}

// This method is called when the match is interrupted; if it returns YES, a new invite will be sent to attempt reconnection. This is supported only for 1v1 games
- (BOOL) match: (GKMatch*)match
shouldReinvitePlayer: (NSString*)playerID
{
    NSLog(@"%@", playerID);
    return YES;
}

@end














