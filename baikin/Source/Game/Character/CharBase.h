//
//  CharBase.h
//  baikin
//
//  Created by 金 珍奕 on 12/12/14.
//
//

#import "cocos2d.h"

enum kCharaStatus
{
    kCharaStatus_Dead,
    kCharaStatus_Ready,
    kCharaStatus_Selected,
};

@interface CharBase : CCNode

@property (nonatomic, readonly) enum kCharaStatus status;
@property (nonatomic, assign) int index;
@property (nonatomic, readonly) BOOL isBlue;

- (void) setDead;
- (void) setRedBaikin;
- (void) setBlueBaikin;

// 選択した状態にする
- (void) setStatusSelect;
- (void) setStatusReady;

@end
