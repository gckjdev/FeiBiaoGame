//
//  MessageManager.h
//  Shuriken
//
//  Created by Orange on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Weapon;

enum MESSAGE_TYPE {
    MSG_MY_NAME = 201202290,
    MSG_ATTACK,
    MSG_POSTURE,
    MSG_SHIELD_STAT,
    MSG_RESTART,
    MSG_GAME_CONTROL,
    MSG_ATTACK_RESULT
    };

@interface MessageManager : NSObject {
    
}

+ (NSData*)makeMyName;
+ (NSData*)makeAttack:(Weapon*)weapon;
+ (NSData*)makePosture:(NSInteger)aPosture shieldStat:(int)shieldStat;
+ (NSArray*)unpackMessage:(NSData*)data;
+ (NSData*)makeRestart:(NSInteger)aType;
+ (NSData*)makeControl:(NSInteger)aControl;
+ (NSData*)makeAttackResponse:(int)result;
+ (NSData*)makeShieldStatus:(int)status;
@end
