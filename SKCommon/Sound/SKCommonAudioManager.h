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
//播放短音效的方法。使用前必须使用Initsound的方法把需要的短音效注册好。soundNams音效名的array,建议用wav。
- (void)initSounds:(NSArray*)soundNames;
- (void)playSoundById:(NSInteger)aSoundIndex;
- (void)vibrate;
//下面是背景音乐播放的方法，目前功能暂时已注释掉，无法使用
- (void)setBackGroundMusicWithName:(NSString*)aMusicName;
- (void)backgroundMusicStart;
- (void)backgroundMusicPause;
- (void)backgroundMusicContinue;
- (void)backgroundMusicStop;

@end
