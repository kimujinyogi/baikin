//
//  MultiplayManager.h
//  baikin
//
//  Created by Kim JinHyuck on 2013/01/05.
//
//

#import <GameKit/GameKit.h>

@protocol MultiplayManagerDelegate <NSObject>

@required
// 自分の情報の取得が終了した
- (void) multiplayDidDownloadLocalPlayer: (GKPlayer*)player;

// 相手の情報の取得が終了した
- (void) multiplayDidDownloadOtherPlayer: (GKPlayer*)player;

// 相手と接続が切れた
- (void) multiplayFailedConnect;

@end

@interface MultiplayManager : NSObject <GKMatchDelegate>

@property (nonatomic, assign) id <MultiplayManagerDelegate>delegate;

+ (MultiplayManager*) shareInstance;

- (void) setGameMatch: (GKMatch*)match;

- (GKPlayer*) getLocalPlayer;
- (GKPlayer*) getOtherPlayer;

// 相手にタッチしたポイント(X,Y何番目)を送信するメソッド
- (void) sendTouchPoint: (CGPoint)point;

@end












