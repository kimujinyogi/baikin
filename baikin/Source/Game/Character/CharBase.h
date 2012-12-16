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
};

@interface CharBase : CCNode

@property (nonatomic, readonly) enum kCharaStatus status;
@property (nonatomic, assign) int index;

- (void) setDead;
- (void) setRedBaikin;
- (void) setBlueBaikin;

@end
