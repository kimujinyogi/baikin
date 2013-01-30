//
//  MenuLayer.h
//  baikin
//
//  Created by 金 珍奕 on 12/12/20.
//
//

#import "cocos2d.h"

@interface MenuLayer : CCLayer

// ターンをセット
- (void) setTurnWithIsBlue: (BOOL)isBlue
              IsMyCharBlue: (BOOL)myCharBlue;

// 何個を持っているかをセット
- (void) setBlueCount: (int)count;
- (void) setRedCount: (int)count;

// YESだと、タッチイベントをメニューで横取りする（操作を不可能に）
- (void) setTouchInterceptionOn: (BOOL)flag;
- (void) setTouchInterceptionOnAndFadeOut: (BOOL)flag;

// 勝者を表示させる
// ゲームプレーを止める
// 1はblueのwin
- (void) showVictoryLabelWithWin: (int)blue;

@end












