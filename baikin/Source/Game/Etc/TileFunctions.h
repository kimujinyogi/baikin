//
//  TileFunctions.h
//  baikin
//
//  Created by Kim JinHyuck on 12/12/16.
//
//

#import <Foundation/Foundation.h>


// x何番目、y何番目のマスかを渡して、その増すの中心座標を返してもらう
extern CGPoint getCenterXAndY(int x, int y);

// x何番目、y何番目のマスかを渡して、indexを渡してもらう
// * * * * * * *
// 7 8 9 * * * *
// 0 1 2 3 4 5 6
extern int getIndexXAndY(int x, int y);

// 座標でindexを返す
extern int getIndexPosition(CGPoint point);

















