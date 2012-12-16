//
//  CharBase.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/14.
//
//

#import "CharBase.h"

@interface CharBase ()
{
    enum kCharaStatus status_;
}

@property (nonatomic, retain) CCSprite* sprite;

@end

@implementation CharBase

@synthesize
status = status_;

- (id) init
{
    if ((self = [super init]))
    {
        status_ = kCharaStatus_Dead;
        [self setContentSize: CGSizeMake(42.0f, 42.0f)];
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage: @"baikin.png"];
        [self setSprite: [CCSprite spriteWithTexture: texture]];
        [self addChild: self.sprite];
        [self.sprite setOpacity: 0];
    }
    
    return self;
}

- (void) dealloc
{
    [self setSprite: nil];
    
    [super dealloc];
}


- (void) setDead
{
    status_ = kCharaStatus_Dead;
    [self.sprite setOpacity: 0];
}

- (void) setRedBaikin
{
    CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage: @"baikinred.png"];
    [self.sprite setTexture: texture];
    [self.sprite setOpacity: 255];
    status_ = kCharaStatus_Ready;
}

- (void) setBlueBaikin
{
    CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage: @"baikin.png"];
    [self.sprite setTexture: texture];
    [self.sprite setOpacity: 255];
    status_ = kCharaStatus_Ready;
}

@end
