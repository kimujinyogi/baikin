//
//  CharLayer.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/15.
//
//


#import "MenuLayer.h"
#import "HelloWorldLayer.h"

// タイル計算メソッド
#import "TileFunctions.h"

// キャラクター
#import "CharBase.h"


#import "CharLayer.h"


@interface CharLayer ()
{
@private
    CharBase* selectedCharP_;         // 選択されたキャラクター
    BOOL isBlueTurn_;
    int blueCount_;
    int redCount_;
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

// 周りの座標を返す
- (void) surroundingLoopProcWithPoint: (CGPoint)point
                               Offset: (int)offset
                                Block: (void (^)(int posX, int posY, BOOL* isStop))block;

// キャラクターのターンであるかを調べる
- (BOOL) checkTurnWithObj: (CharBase*)obj;

// ターンを変更
- (void) changeTurn;

// 現在のターンの人が移動出来るマスがあるかをチェック
- (BOOL) checkCanMoveTile;

// 現在のターンを表示
- (void) showWhosTurn;

// 現在のblue,redカウントを表示
- (void) showCharCount;


@end


@implementation CharLayer


- (id) init
{
    if ((self = [super init]))
    {
        isBlueTurn_ = YES;
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
    
    // テスト用
    for (int i = 0; i < 46; i++)
    {
        if (i == 29)
        {
            
        }
        else if (i == 28)
        {
            
        }
        else
        {
            CharBase* obj = [self.baikinList objectAtIndex: i];
            CGPoint point = getXAndYFromIndex(i);
            [obj setPosition: getCenterXAndY(point.x, point.y)];
            [obj setBlueBaikin];
            [obj setIndex: getIndexXAndY(point.x, point.y)];
        }
    }
    
    CharBase* obj = [self.baikinList objectAtIndex: 48];
    CGPoint point = getXAndYFromIndex(48);
    [obj setPosition: getCenterXAndY(point.x, point.y)];
    [obj setRedBaikin];
    [obj setIndex: getIndexXAndY(point.x, point.y)];
    
//    for (int i = 0; i < count; i++)
//    {
//        if ((i + 1) < [self.baikinList count])
//        {
//            CharBase* obj = [self.baikinList objectAtIndex: i * 2];
//            [obj setPosition: getCenterXAndY((redP + i)->x, (redP + i)->y)];
//            [obj setRedBaikin];
//            [obj setIndex: getIndexXAndY((redP + i)->x, (redP + i)->y)];
//            obj = [self.baikinList objectAtIndex: i * 2 + 1];
//            [obj setPosition: getCenterXAndY((blueP + i)->x, (blueP + i)->y)];
//            [obj setBlueBaikin];
//            [obj setIndex: getIndexXAndY((blueP + i)->x, (blueP + i)->y)];
//        }
//    }
    
    
    // 表示
    [self showWhosTurn];
    [self showCharCount];
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
                if ([self checkTurnWithObj: otherObj] == YES)
                {
                    // キャラの状態を戻す
                    [selectedCharP_ setStatusReady];
                    // そのキャラクターを選択する
                    selectedCharP_ = otherObj;
                    [selectedCharP_ setStatusSelect];
                }
                else
                {
                    // 選択中のキャラを待機状態にする
                    [self setReadyCurrentSelectedObj];
                }
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
                    *
                    [self changeTurn];
                }
                else
                {
                    // 選択中のキャラを待機状態にする
                    [self setReadyCurrentSelectedObj];
                }
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
            if ([self checkTurnWithObj: selectedCharP_] == YES)
            {
                [selectedCharP_ setStatusSelect];
                returnValue = YES;
            }
            else
            {
                selectedCharP_ = nil;
            }
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
//    [(NSMutableArray*)self.baikinList enumerateObjectsUsingBlock:<#^(id obj, NSUInteger idx, BOOL *stop)block#>
}

// 周りのキャラを自分と同じにする
- (void) setSurroundingObjToDye: (CGPoint)point
                           Blue: (BOOL)isBlue
{
    __block int index = -1;
    __block CharBase* otherObj = nil;
    
    // 周りの８マスのキャラを検索
    [self surroundingLoopProcWithPoint: point
                                Offset: 1
                                 Block: ^(int posX, int posY, BOOL* isStop)
     {
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
     }];
}

- (void) surroundingLoopProcWithPoint: (CGPoint)point
                               Offset: (int)offset
                                Block: (void (^)(int posX, int posY, BOOL* isStop))block
{
    BOOL isStop = NO;
    int posX, posY;
    for (int x = -offset; x < (offset + 1); x++)
    {
        for (int y = -offset; y < (offset + 1); y++)
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
            
            block(posX, posY, &isStop);
            if (isStop == YES)
                return;
        }
    }
}


// キャラクターのターンであるかを調べる
- (BOOL) checkTurnWithObj: (CharBase*)obj
{
    return (obj.isBlue == isBlueTurn_);
}


// ターンを変更
- (void) changeTurn
{
    isBlueTurn_ = !isBlueTurn_;
    
    // 順番が来たキャラクターが送る場所があるのか確認する
    // 戻す
    if ([self checkCanMoveTile] == NO)
    {
        isBlueTurn_ = !isBlueTurn_;
        // 勝利
        // 全てのますが埋まっているか？？
        if ((blueCount_ + redCount_) >= (7 * 7))
        {
            if (blueCount_ == redCount_)
            {
                NSLog(@"引き分け");
            }
            // 数が多い色が勝利
            else
            {
                NSLog(@"%@の勝利", (blueCount_ > redCount_) ? @"Blue" : @"Red");
            }
        }
        // 埋まってない
        else
        {
            // isBlueTurn_の勝利
            NSLog(@"%@の勝利", (isBlueTurn_ == YES) ? @"Blue" : @"Red");
        }
    }
    
    // 表示
    [self showWhosTurn];
    [self showCharCount];
}

// 現在のターンの人が移動出来るマスがあるかをチェック
- (BOOL) checkCanMoveTile
{
    __block BOOL returnValue = NO;
    for (CharBase* obj in self.baikinList)
    {
        if (obj.status != kCharaStatus_Dead)
        {
            // 現在ターンのキャラクター
            if (obj.isBlue == isBlueTurn_)
            {
                CGPoint other = getXAndYFromIndex(obj.index);
                // objの座標を元に、周りに空いている所があるのか調べて行く
                [self surroundingLoopProcWithPoint: other
                                            Offset: 2
                                             Block: ^(int posX, int posY, BOOL* isStop)
                 {
                     if ([self getReadyCharWithIndex: getIndexXAndY(posX, posY)] == nil)
                     {
                         returnValue = YES;
                         (*isStop) = YES;
                     }
                 }];
                
                if (returnValue == YES)
                    break;
            }
        }
    }
    
    return returnValue;
}


// 現在のターンを表示
- (void) showWhosTurn
{
    HelloWorldLayer* hello = [HelloWorldLayer shareInstance];
    [hello.menuLayer setTurnWithIsBlue: isBlueTurn_];
}

// 現在のblue,redカウントを表示
- (void) showCharCount
{
    blueCount_ = 0;
    redCount_ = 0;
    HelloWorldLayer* hello = [HelloWorldLayer shareInstance];
    
    for (CharBase* obj in self.baikinList)
    {
        if (obj.status != kCharaStatus_Dead)
        {
            if (obj.isBlue)
                blueCount_++;
            else
                redCount_++;
        }
    }
    
    [hello.menuLayer setBlueCount: blueCount_];
    [hello.menuLayer setRedCount: redCount_];
}

@end












