//
//  TouchInterfaceLayer.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/11.
//
//

#import "HelloWorldLayer.h"

// キャラクターのレイヤー
#import "CharLayer.h"

#import "TileFunctions.h"

#import "TouchInterfaceLayer.h"

@implementation TouchInterfaceLayer

- (id) init
{
    if ((self = [super init]))
    {
        CCDirector* director = [CCDirector sharedDirector];
        [[director touchDispatcher] addTargetedDelegate: self
                                               priority: 0
                                        swallowsTouches: YES];
    }
    
    return self;
}

- (void) dealloc
{
    
    
    [super dealloc];
}

- (BOOL) ccTouchBegan: (UITouch*)touch
            withEvent: (UIEvent*)event
{
    return YES;
}

- (void) ccTouchEnded: (UITouch*)touch
            withEvent: (UIEvent*)event
{
    static const float intarval = 3.0f;
    
    CGPoint point = [touch locationInView: [touch view]];
    point = [[CCDirector sharedDirector] convertToGL: point];
    
    // ここで、どのマスが選択されたか取得する
    
    // まずボックスの中か？
    if (CGRectContainsPoint(CGRectMake(1, 44, 318 - intarval, 318 - intarval), point) == NO)
    {
        return;
    }
    

    BOOL isCharacterAction = NO;
    int index = getIndexPosition(point);
    HelloWorldLayer* layer = [HelloWorldLayer shareInstance];

    if (index >= 0)
        isCharacterAction = [[layer charaLayer] touchedIndex: index];
    
    if (isCharacterAction == NO)
    {
        NSLog(@"キャラが無い");
    }
}

- (void) ccTouchCancelled: (UITouch*)touch
                withEvent: (UIEvent*)event
{
    
}

- (void) ccTouchMoved: (UITouch*)touch
            withEvent: (UIEvent*)event
{
    
}

@end









