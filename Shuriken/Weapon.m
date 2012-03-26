//
//  Weapon.m
//  Shuriken
//
//  Created by Orange on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"

@implementation Weapon
@synthesize weaponCount = _weaponCount;
@synthesize damage = _damage;
@synthesize observer = _observer;
@synthesize accuracy = _accuracy;
@synthesize maxWeaponCount = _maxWeaponCount;
@synthesize recoverTime = _recoverTime;

- (void)setWeaponCount:(int)weaponCount
{
    if (_weaponCount != weaponCount && weaponCount <= _maxWeaponCount) {
        _weaponCount = weaponCount;
        if (_observer && [_observer respondsToSelector:@selector(weapon:updateWeaponCount:)]) {
            [_observer weapon:self updateWeaponCount:weaponCount];
        }
    }
}

- (id)initWithCount:(int)maxWeaponCount damage:(float)damage recoverTime:(float)recoverTime observer:(id<weaponDelegate>)anObserver
{
    self = [super init];
    if (self) {
        _weaponCount = maxWeaponCount;
        _maxWeaponCount = maxWeaponCount;
        _damage = damage;
        _observer = anObserver;
        _recoverTime = recoverTime;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //[aCoder encodeInt:_weaponCount forKey:@"weaponCount"];
    //[aCoder encodeInt:_maxWeaponCount forKey:@"maxWeaponCount"];
    [aCoder encodeFloat:_accuracy forKey:@"accuracy"];
    [aCoder encodeFloat:_damage forKey:@"damage"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.damage = [aDecoder decodeFloatForKey:@"damage"];
        self.accuracy = [aDecoder decodeFloatForKey:@"accuracy"];
        self.observer = nil;
    }
return self;
}

@end
