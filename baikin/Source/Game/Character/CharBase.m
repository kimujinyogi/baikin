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
    BOOL isBlue_;
}

@property (nonatomic, retain) CCSprite* sprite;

@end

@implementation CharBase

@synthesize
status = status_,
isBlue = isBlue_;

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
    isBlue_ = NO;
    [self setStatusReady];
}

- (void) setBlueBaikin
{
    CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage: @"baikin.png"];
    [self.sprite setTexture: texture];
    isBlue_ = YES;
    [self setStatusReady];
}

- (void) setStatusSelect
{
    [self.sprite setColor: ccc3(50, 50, 50)];
    status_ = kCharaStatus_Selected;
}

- (void) setStatusReady
{
    [self.sprite setColor: ccc3(255, 255, 255)];
    [self.sprite setOpacity: 255];
    status_ = kCharaStatus_Ready;
}

@end
