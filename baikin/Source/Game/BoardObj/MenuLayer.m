//
//  MenuLayer.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/20.
//
//

#import "MultiplayManager.h"
#import "MainRootLayer.h"

#import "MenuLayer.h"

@interface MenuLayer ()
{
@private
    BOOL isGameOver_;
    BOOL isTouchInterception_;
    BOOL isPause_;
}

@property (nonatomic, retain) CCLabelTTF* turnLabel;
@property (nonatomic, retain) CCLabelTTF* blueCountLabel;
@property (nonatomic, retain) CCLabelTTF* redCountLabel;
@property (nonatomic, retain) CCLabelTTF* winLabel;
@property (nonatomic, retain) CCLayerColor* colorLayer;

- (void) initializeMenuItems;
- (void) initializePointLabels;
- (void) setColorLayerHidden: (BOOL)isHidden;

@end


@implementation MenuLayer

- (id) init
{
    if ((self = [super init]))
    {
        [self initializeMenuItems];
        [self initializePointLabels];
    }

    return self;
}

- (void) dealloc
{
    CCDirector* director = [CCDirector sharedDirector];
    [[director touchDispatcher] removeDelegate: self];
    [self setColorLayer: nil];
    [self setWinLabel: nil];
    [self setTurnLabel: nil];
    [self setBlueCountLabel: nil];
    [self setRedCountLabel: nil];
    
    [super dealloc];
}



#pragma mark Initialize method

- (void) initializeMenuItems
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // メニュー
    [CCMenuItemFont setFontName: @"Helvetica-Bold"];
    [CCMenuItemFont setFontSize: 24];
    CCMenuItemFont* item1 = [CCMenuItemFont itemWithString: @"||"
                                                     block: ^(id sender)
                             {
                                 [self setTouchInterceptionOnAndFadeOut: !isPause_];
                             }];
    
    CCMenu* menu = [CCMenu menuWithItems: item1, nil];
    [menu alignItemsVerticallyWithPadding: 45];
    menu.position = CGPointMake(size.width / 2, size.height - 20);
    
    [self addChild: menu
                 z: 1];
}

- (void) initializePointLabels
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // ターンは真ん中、
    // ターン
    [self setTurnLabel: [CCLabelTTF labelWithString: @"Blue\nTurn"
                                           fontName: @"Helvetica-Bold"
                                           fontSize: 25]];
    [self addChild: self.turnLabel
                 z: 10];
    self.turnLabel.position = ccp(size.width * 0.5f, size.height - 70);
    [self.turnLabel setColor: ccc3(100, 100, 255)];
    
    
    // blueは左にカウント
    [self setBlueCountLabel: [CCLabelTTF labelWithString: @"10"
                                                fontName: @"Helvetica-Bold"
                                                fontSize: 35]];
    [self addChild: self.blueCountLabel
                 z: 20];
    self.blueCountLabel.position = ccp(30, size.height - 70);
    [self.blueCountLabel setColor: ccc3(60, 60, 255)];
    
    // redは右にカウント
    [self setRedCountLabel: [CCLabelTTF labelWithString: @"20"
                                               fontName: @"Helvetica-Bold"
                                               fontSize: 35]];
    [self addChild: self.redCountLabel
                 z: 20];
    self.redCountLabel.position = ccp(size.width - 30, size.height - 70);
    [self.redCountLabel setColor: ccc3(255, 60, 60)];
}

#pragma mark Instance method

// ターンをセット
- (void) setTurnWithIsBlue: (BOOL)isBlue
              IsMyCharBlue: (BOOL)myCharBlue
{
    NSString* str = nil;
    if (isBlue == myCharBlue)
        str = @"自分のターン";
    else
        str = @"相手のターン";
    
    [[self turnLabel] setString: str];
    if (isBlue)
        [[self turnLabel] setColor: ccc3(100, 100, 255)];
    else
        [[self turnLabel] setColor: ccc3(255, 100, 100)];
}


// 何個を持っているかをセット
- (void) setCount: (int)count
            Label: (CCLabelTTF*)label
{
    [label setString: [NSString stringWithFormat: @"%d", count]];
}

- (void) setBlueCount: (int)count
{
    [self setCount: count
             Label: [self blueCountLabel]];
}

- (void) setRedCount: (int)count
{
    [self setCount: count
             Label: [self redCountLabel]];
}


// YESだと、タッチイベントをメニューで横取りする（操作を不可能に）
- (void) setTouchInterceptionOn: (BOOL)flag
{
    if (isTouchInterception_ == flag) return;
    
    isTouchInterception_ = flag;
    
    CCDirector* director = [CCDirector sharedDirector];
    if (isTouchInterception_)
    {
        // swallowsTouchesをYESにしてccTouchBeganの戻り値をYESにすると、
        // 自分だけがイベントを受け取るようになる
        [[director touchDispatcher] addTargetedDelegate: self
                                               priority: 0
                                        swallowsTouches: YES];
    }
    else
    {        
        [[director touchDispatcher] removeDelegate: self];
    }
}

- (void) setTouchInterceptionOnAndFadeOut: (BOOL)flag
{
    if (isPause_ == flag) return;
    
    isPause_ = flag;
    
    [self setTouchInterceptionOn: flag];
    [self setColorLayerHidden: !isPause_];
}

// 勝者を表示させる
// ゲームプレーを止める
// 1はblueのwin
- (void) showVictoryLabelWithWin: (int)blue
{
    NSString* str = nil;
    if (blue > 0)
        str = @"Blue\nWin";
    else if (blue < 0)
        str = @"Red\nWin";
    else
        str = @"Draw";
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    [self setWinLabel: [CCLabelTTF labelWithString: str
                                          fontName: @"Helvetica-Bold"
                                          fontSize: 62]];
    [self addChild: self.winLabel
                 z: 5];
    self.winLabel.position = ccp(size.width / 2, size.height / 2);
    
    if (blue > 0)
        [self.winLabel setColor: ccc3(60, 60, 255)];
    else if (blue < 0)
        [self.winLabel setColor: ccc3(255, 60, 60)];
    else
        [self.winLabel setColor: ccc3(60, 255, 60)];
    
    [self setTouchInterceptionOn: YES];
    isGameOver_ = YES;
}


- (void) setColorLayerHidden: (BOOL)isHidden
{
    if (isHidden == YES)
    {
        [self.colorLayer removeFromParentAndCleanup: YES];
        [self setColorLayer: nil];
    }
    else
    {
        if (self.colorLayer == nil)
        {
            CGSize size = [[CCDirector sharedDirector] winSize];
            self.colorLayer = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 50)];
            self.colorLayer.contentSize = size;
            self.colorLayer.position = ccp(0, 0);
            [self addChild: self.colorLayer
                         z: 0];
        }
    }
}


// このメソッドが呼ばれる時は、もうゲームが中止されたと言う事になるので、自分で受け取るようにする
- (BOOL) ccTouchBegan: (UITouch*)touch
            withEvent: (UIEvent*)event
{
    return YES;
}


- (void) ccTouchEnded: (UITouch*)touch
            withEvent: (UIEvent*)event
{
    if (isGameOver_ == YES)
    {
        [[CCDirector sharedDirector] replaceScene: [MainRootLayer scene]];
        CCDirector* director = [CCDirector sharedDirector];
        [[director touchDispatcher] removeDelegate: self];
        isGameOver_ = NO;
    }
    else
    {
        if (isPause_ == YES)
        {
            [self setTouchInterceptionOnAndFadeOut: NO];
        }
    }
}

@end











