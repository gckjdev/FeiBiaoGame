//
//  SettingsManager.m
//  Shuriken
//
//  Created by Orange on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingsManager.h"

#define PLAYER_NAME @"player_name"
#define VIBRATION   @"isVibration"
#define SOUND       @"isSoundOn"

static SettingsManager* globalSettingsManager;

static SettingsManager* globalGetSettingsManager()
{
    if (!globalSettingsManager) {
        globalSettingsManager = [[SettingsManager alloc] init];
        globalSettingsManager.playerName = NSLocalizedString(@"unKnown", @"无名氏");
        [globalSettingsManager loadSettings];
    }
    return globalSettingsManager;
}

@implementation SettingsManager
@synthesize isVibration;
@synthesize isSoundOn;
@synthesize playerName = _playerName;

- (void)dealloc
{
    [_playerName release];
    [super dealloc];
}

+ (SettingsManager*)shareInstance
{
    return globalGetSettingsManager();
}

+ (NSString*)getPlayerName
{
    return globalGetSettingsManager().playerName;
}


- (void)saveSettings
{
    [[NSUserDefaults standardUserDefaults] setObject:self.playerName forKey:PLAYER_NAME];
    [[NSUserDefaults standardUserDefaults] setBool:isVibration forKey:VIBRATION];
    [[NSUserDefaults standardUserDefaults] setBool:self.isSoundOn forKey:SOUND];
}

- (void)loadSettings
{
    NSString* name = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_NAME];
    self.isVibration = [[NSUserDefaults standardUserDefaults] boolForKey:VIBRATION];
    self.isSoundOn = [[NSUserDefaults standardUserDefaults] boolForKey:SOUND];
    if (name) {
        self.playerName = name;
    }
}
@end
