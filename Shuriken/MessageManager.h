//
//  MessageManager.h
//  Shuriken
//
//  Created by Orange on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum MESSAGE_TYPE {
    MY_NAME = 201202290,
    I_GET_HURT ,
    I_LOSE,
    ATTACK,
    POSTURE,
    RESTART
    };

@interface MessageManager : NSObject {
    
}

+ (NSData*)makeMyName;
+ (NSData*)makeHurtWithBlood:(NSInteger)bloodCount;
+ (NSData*)makeLoseMessage;
+ (NSData*)makeAttack;
+ (NSData*)makePosture:(NSInteger)aPosture;
+ (NSArray*)unpackMessage:(NSData*)data;
+ (NSData*)makeRestart:(NSInteger)aType;
@end
