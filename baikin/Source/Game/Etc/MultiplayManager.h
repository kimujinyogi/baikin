//
//  MultiplayManager.h
//  baikin
//
//  Created by Kim JinHyuck on 2013/01/05.
//
//

#import <GameKit/GameKit.h>

@interface MultiplayManager : NSObject <GKMatchDelegate>

+ (MultiplayManager*) shareInstance;

- (void) setGameMatch: (GKMatch*)match;

// 相手にタッチしたポイント(X,Y何番目)を送信するメソッド
- (void) sendTouchPoint: (CGPoint)point;

@end












