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

// 選択中のキャラを待機状態にする
- (void) setReadyCurrentSelectedObj;

// 待機中のキャラを返す
- (CharBase*) getReadyObj;

// キャラをコピーさせる
- (void) setCopyCharaWithXY: (CGPoint)point
                       Blue: (BOOL)isBlue;
// キャラを移動させる
- (void) setMoveCharaWithXY: (CGPoint)point
                        Obj: (CharBase*)obj;

// 周りのキャラを自分と同じにする
- (void) setSurroundingObjToDye: (CGPoint)point
                           Blue: (BOOL)isBlue;

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
            // 選択中のキャラを待機状態にする
            [self setReadyCurrentSelectedObj];
        }
        // 違うマスなら
        else
        {
            // 違うマスに既に他のオブジェクトがいるか？
            CharBase* otherObj = [self getReadyCharWithIndex: index];
            if (otherObj != nil)
            {
                // キャラの状態を戻す
                [selectedCharP_ setStatusReady];
                // そのキャラクターを選択する
                selectedCharP_ = otherObj;
                [selectedCharP_ setStatusSelect];
            }
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
                
                // 選択中のキャラを待機状態にする
                [self setReadyCurrentSelectedObj];
            }
        }
        returnValue = YES;
    }
    // 選択されている物がない
    else
    {
        selectedCharP_ = [self getReadyCharWithIndex: index];
        if (selectedCharP_ != nil)
        {
            [selectedCharP_ setStatusSelect];
            returnValue = YES;
        }
    }
    
    return returnValue;
}


// 選択中のキャラを待機状態にする
- (void) setReadyCurrentSelectedObj
{
    // キャラの状態を戻す
    [selectedCharP_ setStatusReady];
    // 範囲外なのでキャンセル
    selectedCharP_ = nil;
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

// indexで表示されているキャラを返す
- (CharBase*) getReadyCharWithIndex: (int)index
{
    CharBase* returnValue = nil;
    for (CharBase* obj in self.baikinList)
    {
        if ([obj status] == kCharaStatus_Ready)
        {
            if (obj.index == index)
            {
                returnValue = obj;
                break;
            }
        }
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
    [self setSurroundingObjToDye: point
                            Blue: obj.isBlue];
}

// キャラを移動させる
- (void) setMoveCharaWithXY: (CGPoint)point
                        Obj: (CharBase*)obj
{
    [obj setIndex: getIndexXAndY(point.x, point.y)];
    [obj setPosition: getCenterXAndY(point.x, point.y)];
    [self setSurroundingObjToDye: point
                            Blue: obj.isBlue];
}

// 周りのキャラを自分と同じにする
- (void) setSurroundingObjToDye: (CGPoint)point
                           Blue: (BOOL)isBlue
{
    int index = -1;
    CharBase* otherObj = nil;
    int posX, posY;
    // 周りの８マスのキャラを検索
    for (int x = -1; x < 2; x++)
    {
        for (int y = -1; y < 2; y++)
        {
            // 自分
            if ((y == 0) &&
                (x == 0))
                continue;
            
            posX = point.x + x;
            posY = point.y + y;
            if ((posX < 0) ||
                (posX > 6) ||
                (posY < 0) ||
                (posY > 6))
                continue;
            
            index = getIndexXAndY(posX, posY);
            otherObj = [self getReadyCharWithIndex: index];
            if (otherObj.isBlue != isBlue)
            {
                if (isBlue == YES)
                {
                    [otherObj setBlueBaikin];
                }
                else
                {
                    [otherObj setRedBaikin];
                }
            }
        }
    }
}


@end












