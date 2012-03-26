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

- (id)init
{
    self = [super init];
    if (self) {
        self.isSoundOn = YES;
        self.isVibration = YES;
    }
    return self;
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
    NSNumber* vibration = [NSNumber numberWithBool:self.isVibration];
    NSNumber* sound = [NSNumber numberWithBool:self.isSoundOn];
    [[NSUserDefaults standardUserDefaults] setObject:self.playerName forKey:PLAYER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:vibration forKey:VIBRATION];
    [[NSUserDefaults standardUserDefaults] setObject:sound forKey:SOUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadSettings
{
    NSString* name = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_NAME];
    NSNumber* vibration = [[NSUserDefaults standardUserDefaults] objectForKey:VIBRATION];
    NSNumber* sound = [[NSUserDefaults standardUserDefaults] objectForKey:SOUND];
    if (name) {
        self.playerName = name;
    }
    if (vibration) {
        self.isVibration = vibration.boolValue;
    }
    if (sound) {
        self.isSoundOn = sound.boolValue;
    }
}
@end
