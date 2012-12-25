//
//  MenuLayer.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/20.
//
//

#import "MainRootLayer.h"

#import "MenuLayer.h"

@interface MenuLayer ()

@property (nonatomic, retain) CCLabelTTF* turnLabel;
@property (nonatomic, retain) CCLabelTTF* blueCountLabel;
@property (nonatomic, retain) CCLabelTTF* redCountLabel;

- (void) initializeMenuItems;
- (void) initializePointLabels;

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
                                 [[CCDirector sharedDirector] replaceScene: [MainRootLayer scene]];
                             }];
    
    CCMenu* menu = [CCMenu menuWithItems: item1, nil];
    [menu alignItemsVerticallyWithPadding: 45];
    menu.position = CGPointMake(size.width / 2, size.height - 20);
    
    [self addChild: menu];
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
{
    [[self turnLabel] setString: (isBlue == YES) ? @"Blue\nTurn" : @"Red\nTurn"];
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




@end
