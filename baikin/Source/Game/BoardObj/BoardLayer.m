//
//  BoardLayer.m
//  baikin
//
//  Created by Kim JinHyuck on 12/12/10.
//
//

#import "BoardLayer.h"

@implementation BoardLayer

- (void) draw
{
    static const float oneTileWH = 42.0f;//(318.0f - (3 * 8)) / 7.0f;

    static const float boardWidth = 318.0f;
    static const float marginX = 1.0f;
    static const float marginY = 44.0f;
    static const float intarval = 3.0f;
    
    ccDrawSolidRect(ccp(marginX, marginY), ccp(boardWidth + marginX, boardWidth + marginY), ccc4f(1, 1, 1, 1));
    
    ccDrawColor4F(1, 1, 1, 1);
    
    float x1, x2, y1, y2;
    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            x1 = (marginX + intarval) + (j * (oneTileWH + intarval));
            y1 = (marginY + intarval) + (i * (oneTileWH + intarval));
            x2 = (marginX + intarval) + ((j + 1)  * (oneTileWH + intarval) - intarval);
            y2 = (marginY + intarval) + ((i + 1) * (oneTileWH + intarval) - intarval);
            ccDrawSolidRect(ccp(x1, y1), ccp(x2, y2), ccc4f(1, 1, 0, 1));
        }
    }
}

@end
