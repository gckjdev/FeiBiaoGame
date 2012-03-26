//
//  Player.h
//  Shuriken
//
//  Created by Orange on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Player;
@class Weapon;
@class Shield;

enum POSTURE {
    DEFENDING = -1,
    EXPOSEING = 0,
    ATTACKING = 1,
    UNAVAILABLE_DEFENDING
};

typedef enum {
    HIT = 0,
    BLOCK = 1,
    MISS
    }ATTACK_RESPONSE;


@protocol playerDelegate <NSObject>

- (void)player:(Player*)thePlayer updatePlayerPosture:(int)posture;
- (void)player:(Player*)thePlayer updatePlayerHealth:(int)health;

@end

@interface Player : NSObject {
    
}

@property (assign, nonatomic) id<playerDelegate> observer;
@property (assign, nonatomic) int health;
@property (assign, nonatomic) int posture;
@property (retain, nonatomic) NSString* name;
@property (assign, nonatomic) BOOL isRival;
@property (assign, nonatomic) Weapon* currentWeapon;
@property (assign, nonatomic) Shield* currentShield;

- (id)initWithPosture:(int)posture health:(int)health observer:(id<playerDelegate>)observer isRival:(BOOL)isRival;

- (ATTACK_RESPONSE)attackedByWeapon:(Weapon*)fromWeapon;
@end
