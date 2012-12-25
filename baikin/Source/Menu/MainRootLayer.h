//
//  MainRootLayer.h
//  baikin
//
//  Created by 金 珍奕 on 12/12/25.
//
//

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface MainRootLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>


// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene*) scene;


@end










