//
//  Player.m
//  Shuriken
//
//  Created by Orange on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Weapon.h"
#import "Shield.h"

#define ACCURACY 100

@implementation Player
@synthesize posture = _posture;
@synthesize health = _health;
@synthesize observer = _observer;
@synthesize name = _name;
@synthesize isRival = _isRival;
@synthesize currentShield = _currentShield;
@synthesize currentWeapon = _currentWeapon;

- (void)dealloc
{
    [_currentShield release];
    [_currentWeapon release];
    [super dealloc];
}

- (ATTACK_RESPONSE)attackedByWeapon:(Weapon*)fromWeapon
{
    int ranValue = arc4random()%ACCURACY;
    if (ranValue  >= fromWeapon.accuracy * ACCURACY) {
        return MISS;
    } else {
        if (self.posture == DEFENDING && self.currentShield.durability > 0) {
            self.currentShield.durability -- ;
            return BLOCK;
        } else {
            self.health -- ;
            return HIT;
        }
    }
    return MISS;
}

- (void)setHealth:(int)health
{
    if (_health != health) {
        _health = health;
        if (_observer && [_observer respondsToSelector:@selector(player:updatePlayerHealth:)]) {
            [_observer player:self updatePlayerHealth:health];
        }
    }
}

- (void)setPosture:(int)posture
{
    if (_posture != posture) {
        _posture = posture;
        if (_observer && [_observer respondsToSelector:@selector(player:updatePlayerPosture:)]) {
            [_observer player:self updatePlayerPosture:posture];
        }
    }    
}

- (id)initWithPosture:(int)posture health:(int)health observer:(id<playerDelegate>)observer isRival:(BOOL)isRival
{
    self = [super init];
    if (self) {
        _posture = posture;
        _health = health;
        _observer = observer;
        _isRival = isRival;
    }
    return self;
}

@end
