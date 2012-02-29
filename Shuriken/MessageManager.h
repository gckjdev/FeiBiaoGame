//
//  MessageManager.h
//  Shuriken
//
//  Created by Orange on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum MESSAGE_TYPE {
    MY_NAME = 120120229,
    I_GET_HURT = 220120229,
    I_LOSE = 120120229
    };

@interface MessageManager : NSObject {
    
}

+ (NSData*)makeMyName;
+ (NSData*)makeHurtWithBlood:(NSInteger)bloodCount;
+ (NSData*)makeLoseMessage;
+ (NSArray*)unpackMessage;
@end
