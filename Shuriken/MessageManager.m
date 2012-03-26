//
//  MessageManager.m
//  Shuriken
//
//  Created by Orange on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MessageManager.h"
#import "SettingsManager.h"

@implementation MessageManager

+ (NSData*)makeMyName
{
    NSNumber* messageId = [NSNumber numberWithInt:MSG_MY_NAME];
    NSString* name = [SettingsManager getPlayerName];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}

+ (NSData*)makeAttack:(Weapon*)weapon
{
    NSNumber* messageId = [NSNumber numberWithInt:MSG_ATTACK];
    NSString* name = [SettingsManager getPlayerName];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, weapon, nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}

+ (NSData*)makePosture:(NSInteger)aPosture shieldStat:(int)shieldStat
{
    NSNumber* messageId = [NSNumber numberWithInt:MSG_POSTURE];
    NSString* name = [SettingsManager getPlayerName];
    NSNumber* posture = [NSNumber numberWithInt:aPosture];
    NSNumber* shield = [NSNumber numberWithInt:shieldStat];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, posture, shield, nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}

+ (NSData*)makeRestart:(NSInteger)aType
{
    NSNumber* messageId = [NSNumber numberWithInt:MSG_RESTART];
    NSString* name = [SettingsManager getPlayerName];
    NSNumber* type = [NSNumber numberWithInt:aType];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, type, nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}

+ (NSData*)makeControl:(NSInteger)aControl
{
    NSNumber* messageId = [NSNumber numberWithInt:MSG_GAME_CONTROL];
    NSString* name = [SettingsManager getPlayerName];
    NSNumber* control = [NSNumber numberWithInt:aControl];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, control, nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}

+ (NSData*)makeAttackResponse:(int)result
{
    NSNumber* messageId = [NSNumber numberWithInt:MSG_ATTACK_RESULT];
    NSString* name = [SettingsManager getPlayerName];
    NSNumber* response = [NSNumber numberWithInt:result];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, response, nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}

+ (NSData*)makeShieldStatus:(int)status
{
    NSNumber* messageId = [NSNumber numberWithInt:MSG_SHIELD_STAT];
    NSString* name = [SettingsManager getPlayerName];
    NSNumber* response = [NSNumber numberWithInt:status];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, response, nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}

+ (NSArray*)unpackMessage:(NSData*)data
{
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}




@end
