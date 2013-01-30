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

// 先攻を決めるプレイヤーから、先攻者のIDが送られた
- (void) multiplayDidSeekFirstTurn: (NSString*)playerID;

@end

@interface MultiplayManager : NSObject <GKMatchDelegate>

@property (nonatomic, assign) id <MultiplayManagerDelegate>delegate;

+ (MultiplayManager*) shareInstance;

- (void) setGameMatch: (GKMatch*)match;

- (GKPlayer*) getLocalPlayer;
- (GKPlayer*) getOtherPlayer;

// プレイヤーのidを比較して、自分の文字列が先ならYES
- (BOOL) seekBatFirst;

// 相手にタッチしたポイント(X,Y何番目)を送信するメソッド
- (void) sendTouchPoint: (CGPoint)point;

// 相手に誰が先攻が決まった後に知らせるメソッド
- (void) sendFirstTurn: (NSString*)playerID;

@end












