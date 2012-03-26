//
//  SKCommonGameCenterService.h
//  Shuriken
//
//  Created by Orange on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
@protocol SKCommonGameCenterServiceDelegate <NSObject>
 @optional
- (void)matchStarted;
- (void)playerLeaveGame:(NSString*)playerId;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data 
   fromPlayer:(NSString *)playerID;
- (void)inviteReceived;
- (void)quitGame;
- (void)cancelFromGameCenter;
@end

@interface SKCommonGameCenterService : NSObject <GKMatchDelegate, 
GKMatchmakerViewControllerDelegate>{
    GKMatch* _match;
    GKInvite *_pendingInvite;
    NSArray *_pendingPlayersToInvite;
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    id<SKCommonGameCenterServiceDelegate> _delegate;
    BOOL _matchStarted;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain, nonatomic) GKMatch* match;
@property (retain, nonatomic) UIViewController* gameViewController;
@property (retain) NSMutableDictionary *playersDict;
@property (retain, nonatomic) id<SKCommonGameCenterServiceDelegate> delegate;
@property (retain, nonatomic) GKInvite* pendingInvite;
@property (retain, nonatomic) NSArray* pendingPlayersToInvite;

+ (SKCommonGameCenterService *) sharedInstance;
- (void)authenticateLocalUser;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers 
                 viewController:(UIViewController *)viewController 
                       delegate:(id<SKCommonGameCenterServiceDelegate>)aDelegate;
- (void)reportScore: (int64_t) score forCategory: (NSString*) category;
- (void)sendData:(NSData *)data;
- (void) loadCategoryTitles;
- (void)quitMatch;
@end
