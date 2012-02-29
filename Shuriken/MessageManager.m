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
    NSNumber* messageId = [NSNumber numberWithInt:MY_NAME];
    NSString* name = [SettingsManager getPlayerName];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}
+ (NSData*)makeHurtWithBlood:(NSInteger)bloodCount
{
//    NSString* message =  [NSString stringWithFormat:@"%d^%@^%d", I_LOSE, [SettingsManager getPlayerName], bloodCount];
//    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
//    return data;
    NSNumber* messageId = [NSNumber numberWithInt:I_GET_HURT];
    NSNumber* bloods = [NSNumber numberWithInt:bloodCount];
    NSString* name = [SettingsManager getPlayerName];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, bloods,nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}
+ (NSData*)makeLoseMessage
{
//    NSString* message =  [NSString stringWithFormat:@"%d^%@", I_LOSE, [SettingsManager getPlayerName]];
//    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
//    return data;
    NSNumber* messageId = [NSNumber numberWithInt:I_LOSE];
    NSString* name = [SettingsManager getPlayerName];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}

+ (NSData*)makeAttack
{
    NSNumber* messageId = [NSNumber numberWithInt:ATTACK];
    NSString* name = [SettingsManager getPlayerName];
    NSArray* message = [NSArray arrayWithObjects:messageId, name, nil];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    return data;
}

+ (NSArray*)unpackMessage:(NSData*)data
{
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}


@end
