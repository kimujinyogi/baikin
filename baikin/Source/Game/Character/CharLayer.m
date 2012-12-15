//
//  CharLayer.m
//  baikin
//
//  Created by 金 珍奕 on 12/12/15.
//
//


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
            [chara setPosition: ccp(1 + 3 + ((3 + 42) * x) + 42 / 2,
                                    44.0f + 3 + ((3 + 42) * y) + 42 / 2)];
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

@end












