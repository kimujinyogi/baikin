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

#define kCHARLARYER_CHAR_Z 10
#define kCHARLARYER_CHAR_MOVE_Z 11


@interface CharLayer ()
{
@private
    CharBase* selectedCharP_;           // 選択されたキャラクター
    CharBase* movingCharP_;             // 何らかのアニメーション中のキャラクター
    BOOL isBlueTurn_;
    int blueCount_;
    int redCount_;
    BOOL isMyCharacterBlue_;            // 自分が先攻（blue）ならYES
    BOOL is2Player_;                    // １つのデバイスで２人でやる時はYES
    BOOL isVsAI_;                       // パソコンと対決
}

@property (nonatomic, retain) NSArray* baikinList;
@property (nonatomic, retain) NSMutableArray* movingBaikinList;

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

// 周りのキャラを自分と同Lじにする
- (NSArray*) setSurroundingObjToDye: (CGPoint)point
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



#pragma mark - init / dealloc

- (id) init
{
    if ((self = [super init]))
    {
        // 最初はタッチが出来ない
        MenuLayer* menu = [HelloWorldLayer shareInstance].menuLayer;
        [menu setTouchInterceptionOn: YES];
        
        isBlueTurn_ = YES;
        // キャラクターは最大数を先に生成して置く。
        CharBase* chara = nil;
        int x, y;
        NSMutableArray* ar = [NSMutableArray arrayWithCapacity: 49];
        for (int i = 0; i < 49 + 8; i++)
        {
            chara = [CharBase node];
            [ar addObject: chara];
            [self addChild: chara
                         z: kCHARLARYER_CHAR_Z];
            x = i % 7;
            y = i / 7;
            [chara setPosition: getCenterXAndY(x, y)];
        }
        [self setBaikinList: [NSArray arrayWithArray: ar]];
        [self setMovingBaikinList: [NSMutableArray array]];
    }
    
    return self;
}


- (void) dealloc
{
    [self setMovingBaikinList: nil];
    [self setBaikinList: nil];
    
    [super dealloc];
}



#pragma mark - Instance method

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
//    for (int i = 0; i < 46; i++)
//    {
//        if (i == 29)
//        {
//            
//        }
//        else if (i == 28)
//        {
//            
//        }
//        else
//        {
//            CharBase* obj = [self.baikinList objectAtIndex: i];
//            CGPoint point = getXAndYFromIndex(i);
//            [obj setPosition: getCenterXAndY(point.x, point.y)];
//            [obj setBlueBaikin];
//            [obj setIndex: getIndexXAndY(point.x, point.y)];
//        }
//    }
//    
//    CharBase* obj = [self.baikinList objectAtIndex: 48];
//    CGPoint point = getXAndYFromIndex(48);
//    [obj setPosition: getCenterXAndY(point.x, point.y)];
//    [obj setRedBaikin];
//    [obj setIndex: getIndexXAndY(point.x, point.y)];
    
    for (int i = 0; i < count; i++)
    {
        if ((i + 1) < [self.baikinList count])
        {
            CharBase* obj = [self.baikinList objectAtIndex: i * 2];
            [obj setPosition: getCenterXAndY((redP + i)->x, (redP + i)->y)];
            [obj setRedBaikin];
            [obj setIndex: getIndexXAndY((redP + i)->x, (redP + i)->y)];
            obj = [self.baikinList objectAtIndex: i * 2 + 1];
            [obj setPosition: getCenterXAndY((blueP + i)->x, (blueP + i)->y)];
            [obj setBlueBaikin];
            [obj setIndex: getIndexXAndY((blueP + i)->x, (blueP + i)->y)];
        }
    }
    
    
    // 表示
    [self showWhosTurn];
    [self showCharCount];
}

- (BOOL) touchedIndex: (int)index
{
    // マルチプレイ中なら
    if ((is2Player_ == NO) &&
        (isVsAI_ == NO))
    {
        // 自分のターンじゃない場合は処理しない
        if (isBlueTurn_ != isMyCharacterBlue_)
        {
            return NO;
        }
    }
    
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

- (void) setPlayerBlue: (BOOL)isBlue
{
    isMyCharacterBlue_ = isBlue;
    [self showWhosTurn];
}

- (void) set2Player
{
    is2Player_ = YES;
}

- (void) setVSAI
{
    isVsAI_ = YES;
}


#pragma mark - 


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
                     z: kCHARLARYER_CHAR_Z];
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
    // 属性
    if (isBlue == YES)
        [obj setBlueBaikin];
    else
        [obj setRedBaikin];
    // まず選択されたキャラクターと同じ位置に表示させる
    [obj setPosition: selectedCharP_.position];

    // 移動先（複製）のindexセット
    [obj setIndex: getIndexXAndY(point.x, point.y)];

    CCMoveTo* moveTo = [CCMoveTo actionWithDuration: 0.3f
                                           position: getCenterXAndY(point.x, point.y)];
    CCCallFunc* fanc = [CCCallFuncO actionWithTarget: self
                                            selector: @selector(moveEndProc: )
                                              object: obj];
    CCSequence* seq = [CCSequence actions: moveTo, fanc, nil];
    [obj runAction: seq];
    
    // 選択中のキャラを待機状態にする
    [self setReadyCurrentSelectedObj];
    
    // 移動中の者をselectedCharPにする
//    selectedCharP_ = obj;
}

// キャラを移動させる
- (void) setMoveCharaWithXY: (CGPoint)point
                        Obj: (CharBase*)obj
{
    // タッチを防ぐ
    MenuLayer* menu = [HelloWorldLayer shareInstance].menuLayer;
    [menu setTouchInterceptionOn: YES];
    
    [obj setIndex: getIndexXAndY(point.x, point.y)];
    CCMoveTo* moveTo = [CCMoveTo actionWithDuration: 0.3f
                                           position: getCenterXAndY(point.x, point.y)];
    CCCallFunc* fanc = [CCCallFuncO actionWithTarget: self
                                            selector: @selector(moveEndProc: )
                                              object: obj];
    CCSequence* seq = [CCSequence actions: moveTo, fanc, nil];
    [obj runAction: seq];
    
    // 選択中のキャラを待機状態にする
    [self setReadyCurrentSelectedObj];
    
    // 移動中の者をselectedCharPにする
    selectedCharP_ = obj;
}


#pragma mark - アニメーションの終了イベント

- (void) moveEndProc: (CharBase*)selectedChar
{
    CGPoint point = getXAndYFromIndex(selectedChar.index);
    
    // 自分の見方にするキャラクターのリストを取得
    NSArray* willChangeList = [self setSurroundingObjToDye: point
                                                      Blue: selectedChar.isBlue];

    // 移動アニメーションするキャラクターを準備
    [[self movingBaikinList] removeAllObjects];
    for (int i = 0; i < [willChangeList count]; i++)
    {
        CharBase* obj = [self getReadyObj];
        CharBase* targetObj = [willChangeList objectAtIndex: i];
        [obj setPosition: selectedChar.position];
        if (selectedChar.isBlue)
            [obj setBlueBaikin];
        else
            [obj setRedBaikin];
        
        [obj setZOrder: kCHARLARYER_CHAR_MOVE_Z];
        [[self movingBaikinList] addObject: obj];
        // indexを同じにする
        [obj setIndex: targetObj.index];
        CCMoveTo* moveTo = [CCMoveTo actionWithDuration: 0.3f
                                               position: targetObj.position];
        CCCallFuncO* fanc = [CCCallFuncO actionWithTarget: self
                                                 selector: @selector(copyAnimationEndProc: )
                                                   object: obj];
        CCSequence* seq = [CCSequence actions: moveTo, fanc, nil];
        [obj runAction: seq];
    }
    
    if ([willChangeList count] == 0)
    {
        MenuLayer* menu = [HelloWorldLayer shareInstance].menuLayer;
        [menu setTouchInterceptionOn: NO];
        // 選択中のキャラを待機状態にする
        [self changeTurn];
    }
}

- (void) copyAnimationEndProc: (CharBase*)obj
{
    for (CharBase* cha in self.baikinList)
    {
        if (cha != obj)
        {
            if (cha.index == obj.index)
            {
                if (cha.isBlue)
                    [cha setRedBaikin];
                else
                    [cha setBlueBaikin];
            }
        }
    }
    [obj setZOrder: kCHARLARYER_CHAR_Z];
    [obj setDead];
    
    [[self movingBaikinList] removeObject: obj];
    
    if ([[self movingBaikinList] count] == 0)
    {
        MenuLayer* menu = [HelloWorldLayer shareInstance].menuLayer;
        [menu setTouchInterceptionOn: NO];
        // 選択中のキャラを待機状態にする
        [self changeTurn];
    }
}


#pragma mark - キャラクターの状態処理

// 周りのキャラを自分と同じにする
- (NSArray*) setSurroundingObjToDye: (CGPoint)point
                               Blue: (BOOL)isBlue
{
    __block int index = -1;
    __block CharBase* otherObj = nil;
    
    NSMutableArray* returnValue = [NSMutableArray array];
    // 周りの８マスのキャラを検索
    [self surroundingLoopProcWithPoint: point
                                Offset: 1
                                 Block: ^(int posX, int posY, BOOL* isStop)
     {
         index = getIndexXAndY(posX, posY);
         otherObj = [self getReadyCharWithIndex: index];
         if (otherObj != nil)
             if (otherObj.isBlue != isBlue)
                 [returnValue addObject: otherObj];
     }];
    
    return returnValue;
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
                HelloWorldLayer* hello = [HelloWorldLayer shareInstance];
                [hello.menuLayer showVictoryLabelWithWin: 0];
            }
            // 数が多い色が勝利
            else
            {
                HelloWorldLayer* hello = [HelloWorldLayer shareInstance];
                [hello.menuLayer showVictoryLabelWithWin: (blueCount_ > redCount_) ? 1 : -1];
            }
        }
        // 埋まってない
        else
        {
            // 埋まってない時、すべてを埋めた後の数で勝負を決める
            if (isBlueTurn_ == YES)
            {
                blueCount_ = (7 * 7) - (blueCount_ + redCount_);
            }
            else
            {
                redCount_ = (7 * 7) - (blueCount_ + redCount_);
            }
            // 数が多い色が勝利
            HelloWorldLayer* hello = [HelloWorldLayer shareInstance];
            [hello.menuLayer showVictoryLabelWithWin: (blueCount_ > redCount_) ? 1 : -1];
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

#pragma mark - 画面更新処理

// 現在のターンを表示
- (void) showWhosTurn
{
    HelloWorldLayer* hello = [HelloWorldLayer shareInstance];
    [hello.menuLayer setTurnWithIsBlue: isBlueTurn_
                          IsMyCharBlue: isMyCharacterBlue_];

    // 自分のターンの時のみタッチを有効にする
    MenuLayer* menu = [HelloWorldLayer shareInstance].menuLayer;
    [menu setTouchInterceptionOn: (isBlueTurn_ == isMyCharacterBlue_) ? NO : YES];
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












