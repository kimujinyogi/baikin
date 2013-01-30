//
//  MultiplayDataObject.m
//  baikin
//
//  Created by 金 珍奕 on 2013/01/08.
//
//

#import "MultiplayDataObject.h"

@implementation MultiplayDataObject

- (id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

- (void) dealloc
{
    [self setSendStr: nil];
    [super dealloc];
}

- (id) initWithCoder: (NSCoder*)aDecoder
{
	if ((self = [super init]) != nil)
	{
        [self setType: [aDecoder decodeIntForKey: @"type"]];
        [self setSendStr: [aDecoder decodeObjectForKey: @"sendStr"]];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder*)aCoder
{
    [aCoder encodeInt: [self type]
               forKey: @"type"];
    [aCoder encodeObject: [self sendStr]
                  forKey: @"sendStr"];
}

@end













