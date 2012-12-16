//
//  CharLayer.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/15.
//
//


// タイル計算メソッド
#import "TileFunctions.h"

// キャラクター
#import "CharBase.h"


#import "CharLayer.h"


@interface CharLayer ()

@property (nonatomic, retain) NSArray* baikinList;

@end


@implementation CharLayer


- (id) init
{
    if ((self = [super init]))
    {
        // キャラクターは最大数を先に生成して置く。
        CharBase* chara = nil;
        int x, y;
        NSMutableArray* ar = [NSMutableArray arrayWithCapacity: 49];
        for (int i = 0; i < 49; i++)
        {
            chara = [CharBase node];
            [ar addObject: chara];
            [self addChild: chara
                         z: 10];
            x = i % 7;
            y = i / 7;
            [chara setPosition: getCenterXAndY(x, y)];
        }
        [self setBaikinList: [NSArray arrayWithArray: ar]];
    }
    
    return self;
}


- (void) dealloc
{
    [self setBaikinList: nil];
    
    [super dealloc];
}

- (void) setStartCharaSetRedPositions: (CGPoint*)redP
                        BluePositions: (CGPoint*)blueP
                                Count: (int)count
{
    for (CharBase* obj in self.baikinList)
    {
        [obj setPosition: ccp(-100, -100)];
        [obj setDead];
    }
    
    for (int i = 0; i < count; i++)
    {
        if ((i + 1) < [self.baikinList count])
        {
            CharBase* obj = [self.baikinList objectAtIndex: i * 2];
            [obj setPosition: getCenterXAndY((redP + i)->x, (redP + i)->y)];
            [obj setBlueBaikin];
            [obj setIndex: getIndexXAndY((redP + i)->x, (redP + i)->y)];
            obj = [self.baikinList objectAtIndex: i * 2 + 1];
            [obj setPosition: getCenterXAndY((blueP + i)->x, (blueP + i)->y)];
            [obj setRedBaikin];
            [obj setIndex: getIndexXAndY((blueP + i)->x, (blueP + i)->y)];
        }
    }
}

- (BOOL) touchedIndex: (int)index
{
    BOOL returnValue = NO;
    
    for (CharBase* obj in self.baikinList)
    {
        if ([obj status] == kCharaStatus_Ready)
        {
            if (obj.index == index)
            {
                returnValue = YES;
                break;
            }
        }
    }
    
    return returnValue;
}

@end












