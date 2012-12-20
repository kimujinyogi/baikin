//
//  MenuLayer.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/20.
//
//

#import "cocos2d.h"

#import "MenuLayer.h"

@interface MenuLayer ()

@property (nonatomic, retain) CCLabelTTF* turnLabel;
@property (nonatomic, retain) CCLabelTTF* blueCountLabel;
@property (nonatomic, retain) CCLabelTTF* redCountLabel;

@end


@implementation MenuLayer

- (id) init
{
    if ((self = [super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
     
        // ターンは真ん中、
        // ターン
        [self setTurnLabel: [CCLabelTTF labelWithString: @"Blue\nTurn"
                                               fontName: @"Helvetica-Bold"
                                               fontSize: 25]]; 
        [self addChild: self.turnLabel
                     z: 10];
        self.turnLabel.position = ccp(size.width * 0.5f, size.height - 30);
        [self.turnLabel setColor: ccc3(100, 100, 255)];
        
        
        // blueは左にカウント
        [self setBlueCountLabel: [CCLabelTTF labelWithString: @"10"
                                                    fontName: @"Helvetica-Bold"
                                                    fontSize: 35]];
        [self addChild: self.blueCountLabel
                     z: 20];
        self.blueCountLabel.position = ccp(30, size.height - 30);
        [self.blueCountLabel setColor: ccc3(60, 60, 255)];
        
        // redは右にカウント
        [self setRedCountLabel: [CCLabelTTF labelWithString: @"20"
                                                   fontName: @"Helvetica-Bold"
                                                   fontSize: 35]];
        [self addChild: self.redCountLabel
                     z: 20];
        self.redCountLabel.position = ccp(size.width - 30, size.height - 30);
        [self.redCountLabel setColor: ccc3(255, 60, 60)];
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

// ターンをセット
- (void) setTurnWithIsBlue: (BOOL)isBlue
{
    
}


// 何個を持っているかをセット
- (void) setBlueCount: (int)count
{
    
}

- (void) setRedCount: (int)count
{
    
}

@end
