//
//  CharBase.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/14.
//
//

#import "CharBase.h"

@interface CharBase ()

@property (nonatomic, retain) CCSprite* sprite;

@end

@implementation CharBase

- (id) init
{
    if ((self = [super init]))
    {
        [self setContentSize: CGSizeMake(42.0f, 42.0f)];
        [self setPosition: ccp(1 + 3 + 42 / 2, 44.0f + 3 + 42 / 2)];
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage: @"baikin.png"];
        [self setSprite: [CCSprite spriteWithTexture: texture]];
        [self addChild: self.sprite];
    }
    
    return self;
}

- (void) dealloc
{
    [self setSprite: nil];
    
    [super dealloc];
}


@end
