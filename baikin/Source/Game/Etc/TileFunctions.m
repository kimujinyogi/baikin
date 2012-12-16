//
//  TileFunctions.m
//  baikin
//
//  Created by Kim JinHyuck on 12/12/16.
//
//

#import "TileFunctions.h"

#define kTILE_X_MARGIN 1
#define kTILE_Y_MARGIN 44
#define kTILE_X_INTERVAL 3
#define kTILE_Y_INTERVAL 3
#define kTILE_WIDTH 42
#define kTILE_HEIGHT 42

CGPoint getCenterXAndY(int x, int y)
{
//    return CGPointMake(1 + 3 + ((3 + 42) * x) + 42 / 2,
//                       44.0f + 3 + ((3 + 42) * y) + 42 / 2)];
    return CGPointMake(kTILE_X_MARGIN + kTILE_X_INTERVAL + ((kTILE_X_INTERVAL + kTILE_WIDTH) * x) + kTILE_WIDTH / 2,
                       kTILE_Y_MARGIN + kTILE_Y_INTERVAL + ((kTILE_Y_INTERVAL + kTILE_HEIGHT) * y) + kTILE_HEIGHT / 2);
}



int getIndexXAndY(int x, int y)
{
    return x + (y * 7);
}


int getIndexPosition(CGPoint point)
{
    static const float oneTileWH = 42.0f; //(318.0f - (3 * 8)) / 7.0f;
    static const float intarval = 3.0f;
    
    int x = -1;
    int y = -1;
    
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
    
    return getIndexXAndY(x, y);
}












