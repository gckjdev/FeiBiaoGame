//
//  Shield.h
//  Shuriken
//
//  Created by Orange on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Shield;
enum SHIELD_STAT {
    GOOD = 0,
    DAMAGE = 1,
    BADLY_DAMAGE,
    BROKEN    
};

@protocol ShieldDelegate <NSObject>

- (void)shield:(Shield*)theShield updateShieldDurability:(float)durability;
- (void)shield:(Shield*)theShield updateShieldStatus:(int)shieldStatus;

@end

@interface Shield : NSObject {
    
}

@property (assign, nonatomic) float durability;
@property (assign, nonatomic) float maxDurability;
@property (assign, nonatomic) float recoverTime;
@property (assign, nonatomic) int status;
@property (assign, nonatomic) id<ShieldDelegate> observer;

- (id)initWithDurability:(float)maxDurability status:(int)status recoverTime:(float)recoverTime observer:(id<ShieldDelegate>)observer;

@end


