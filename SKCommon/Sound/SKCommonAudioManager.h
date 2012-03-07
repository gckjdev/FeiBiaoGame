//
//  SKCommonAudioManager.h
//  Shuriken
//
//  Created by Orange on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVAudioPlayer;

@interface SKCommonAudioManager : NSObject {
    AVAudioPlayer* _backgroundMusicPlayer;
    NSMutableArray* _sounds;
}
@property (retain, nonatomic) AVAudioPlayer* backgroundMusicPlayer;
@property (retain, nonatomic) NSMutableArray* sounds;
+ (SKCommonAudioManager*)defaultManager;
- (void)initSounds:(NSArray*)soundNames;
- (void)setBackGroundMusicWithName:(NSString*)aMusicName;
- (void)playSoundById:(NSInteger)aSoundIndex;
- (void)backgroundMusicStart;
- (void)backgroundMusicPause;
- (void)backgroundMusicContinue;
- (void)backgroundMusicStop;
- (void)vibrate;
@end
