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
{
@private
    CharBase* selectedCharP_;         // 選択されたキャラクター
}

@property (nonatomic, retain) NSArray* baikinList;

// 待機中のキャラを返す
- (CharBase*) getReadyObj;

// キャラをコピーさせる
- (void) setCopyCharaWithXY: (CGPoint)point
                       Blue: (BOOL)isBlue;
// キャラを移動させる
- (void) setMoveCharaWithXY: (CGPoint)point
                        Obj: (CharBase*)obj;

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
    
    // 既に選択されている物がある
    if (selectedCharP_ != nil)
    {
        // 同じマスなら
        if (selectedCharP_.index == index)
        {
            // キャラの状態を戻す
            [selectedCharP_ setStatusReady];
            // 同じ物なのでキャンセル
            selectedCharP_ = nil;
        }
        // 違うマスなら
        else
        {
            // 自分とタッチ座標のマスを求める
            CGPoint my = getXAndYFromIndex(selectedCharP_.index);
            CGPoint other = getXAndYFromIndex(index);

            // 距離を求める
            int difX = fabs(my.x - other.x);
            int difY = fabs(my.y - other.y);
            
            // 範囲内か？
            if ((difX < 3) &&
                (difY < 3))
            {
                // 1マス離れているindexか？
                if ((difX < 2) &&
                    (difY < 2))
                {
                    [self setCopyCharaWithXY: other
                                        Blue: selectedCharP_.isBlue];
                }
                // 2マス離れているindexか？
                else
                {
                    [self setMoveCharaWithXY: other
                                         Obj: selectedCharP_];
                }
            }
            
            // キャラの状態を戻す
            [selectedCharP_ setStatusReady];
            // 範囲外なのでキャンセル
            selectedCharP_ = nil;
        }
        returnValue = YES;
    }
    // 選択されている物がない
    else
    {
        for (CharBase* obj in self.baikinList)
        {
            if ([obj status] == kCharaStatus_Ready)
            {
                if (obj.index == index)
                {
                    selectedCharP_ = obj;
                    [selectedCharP_ setStatusSelect];
                    returnValue = YES;
                    break;
                }
            }
        }
    }
    
    return returnValue;
}



// 待機中のキャラを返す
- (CharBase*) getReadyObj
{
    CharBase* returnValue = nil;
    for (CharBase* obj in self.baikinList)
    {
        if (obj.status == kCharaStatus_Dead)
        {
            returnValue = obj;
            break;
        }
    }
    
    // 無い場合(ないはずがない)
    if (returnValue == nil)
    {
        NSMutableArray* ar = [NSMutableArray arrayWithCapacity: [self.baikinList count] + 1];
        returnValue = [CharBase node];
        [ar addObject: returnValue];
        [self addChild: returnValue
                     z: 10];
        [self setBaikinList: [NSArray arrayWithArray: ar]];
    }
    
    return returnValue;
}

// キャラをコピーする
- (void) setCopyCharaWithXY: (CGPoint)point
                       Blue: (BOOL)isBlue
{
    CharBase* obj = [self getReadyObj];
    [obj setIndex: getIndexXAndY(point.x, point.y)];
    [obj setPosition: getCenterXAndY(point.x, point.y)];
    if (isBlue == YES)
    {
        [obj setBlueBaikin];
    }
    else
    {
        [obj setRedBaikin];
    }
}

// キャラを移動させる
- (void) setMoveCharaWithXY: (CGPoint)point
                        Obj: (CharBase*)obj
{
    [obj setIndex: getIndexXAndY(point.x, point.y)];
    [obj setPosition: getCenterXAndY(point.x, point.y)];
}



@end












