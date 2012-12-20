//
//  MenuLayer.h
//  baikin
//
//  Created by 金 珍奕 on 12/12/20.
//
//

#import "CCLayer.h"

@interface MenuLayer : CCLayer

// ターンをセット
- (void) setTurnWithIsBlue: (BOOL)isBlue;

// 何個を持っているかをセット
- (void) setBlueCount: (int)count;
- (void) setRedCount: (int)count;

@end
