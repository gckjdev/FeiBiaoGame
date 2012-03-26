//
//  Shield.m
//  Shuriken
//
//  Created by Orange on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Shield.h"

@implementation Shield
@synthesize durability = _durability;
@synthesize status = _status;
@synthesize observer = _observer;
@synthesize maxDurability = _maxDurability;
@synthesize recoverTime = _recoverTime;

- (void)setStatus:(int)status
{
    if (_status != status) {
        _status = status;
        if (_observer && [_observer respondsToSelector:@selector(shield:updateShieldStatus:)]) {
            [_observer shield:self updateShieldStatus:status];
        }
    }
}

- (void)setDurability:(float)durability
{
    if (_durability != durability && durability <= _maxDurability) {
        _durability = durability;
        if (_observer && [_observer respondsToSelector:@selector(shield:updateShieldDurability:)]) {
            [_observer shield:self updateShieldDurability:durability];
        }
    }
}

- (id)initWithDurability:(float)maxDurability status:(int)status recoverTime:(float)recoverTime observer:(id<ShieldDelegate>)observer
{
    self = [super init];
    if (self) {
        _durability = maxDurability;
        _maxDurability = maxDurability;
        _status = status;
        _observer = observer;
        _recoverTime = recoverTime;
    }
    return self;
}

@end
