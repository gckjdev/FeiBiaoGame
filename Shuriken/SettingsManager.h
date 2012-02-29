//
//  SettingsManager.h
//  Shuriken
//
//  Created by Orange on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject {
    
}

@property (nonatomic, retain) NSString* playerName;
@property (assign, nonatomic) BOOL isVibration;
@property (assign, nonatomic) BOOL isSoundOn;

+ (SettingsManager*)shareInstance;
+ (NSString*) getPlayerName;
- (void)saveSettings;
- (void)loadSettings;

@end
