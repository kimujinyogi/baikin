//
//  TouchInterfaceLayer.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/11.
//
//

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
    static const float oneTileWH = 42.0f; //(318.0f - (3 * 8)) / 7.0f;
    static const float intarval = 3.0f;
    CGPoint point = [touch locationInView: [touch view]];
    point = [[CCDirector sharedDirector] convertToGL: point];
    
    // ここで、どのマスが選択されたか取得する
    int x = -1;
    int y = -1;
    
    // まずボックスの中か？
    if (CGRectContainsPoint(CGRectMake(1, 44, 318 - intarval, 318 - intarval), point) == NO)
    {
        return;
    }
    
    // 左と下のmarginを引く
    point.x -= 1;
    point.y -= 44;
    
    float intervalCheckX = (int)point.x % (int)(oneTileWH + intarval);
    float intervalCheckY = (int)point.y % (int)(oneTileWH + intarval);
    if ((intervalCheckX > 3) &&
        (intervalCheckY > 3))
    {
        x = point.x / (oneTileWH + intarval);
        y = point.y / (oneTileWH + intarval);
    }
    
    if ((x >= 0) &&
        (y >= 0))
    {
        NSLog(@"(%d, %d)", x + 1, y + 1);
        NSLog(@"%d", x + (y * 7));
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









