//
//  CharLayer.h
//  baikin
//
//  Created by 金 珍奕 on 12/12/15.
//
//

#import "cocos2d.h"

@interface CharLayer : CCLayer

- (void) setStartCharaSetRedPositions: (CGPoint*)redP
                        BluePositions: (CGPoint*)blueP
                                Count: (int)count;

- (BOOL) touchedIndex: (int)index;

- (void) setPlayerBlue: (BOOL)isBlue;
- (void) set2Player;
- (void) setVSAI;

@end














