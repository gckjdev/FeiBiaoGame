//
//  Weapon.h
//  Shuriken
//
//  Created by Orange on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Weapon;

@protocol weaponDelegate <NSObject>
 @optional
- (void)weapon:(Weapon*)theWeapon updateWeaponCount:(int)weaponCount;

@end

@interface Weapon : NSObject <NSCoding> {
    int _weaponCount;
    int _maxWeaponCount;
    float _damage;
    id<weaponDelegate> _observer;
    float _accuracy;
    float _recoverTime;
}

@property (assign, nonatomic) int weaponCount;
@property (assign, nonatomic) int maxWeaponCount;
@property (assign, nonatomic) float damage;
@property (assign, nonatomic) id<weaponDelegate> observer;
@property (assign, nonatomic) float accuracy;
@property (assign, nonatomic) float recoverTime;

- (id)initWithCount:(int)maxWeaponCount damage:(float)damage recoverTime:(float)recoverTime observer:(id<weaponDelegate>)anObserver;

@end
