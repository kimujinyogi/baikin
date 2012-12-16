//
//  HelloWorldLayer.h
//  baikin
//
//  Created by Kim JinHyuck on 12/12/10.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "cocos2d.h"

@class CharLayer;
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

@property (nonatomic, retain) CharLayer* charaLayer;

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene*) scene;
+ (HelloWorldLayer*) shareInstance;

@end
