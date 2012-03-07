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
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data 
   fromPlayer:(NSString *)playerID;
@end

@interface SKCommonGameCenterService : NSObject <GKMatchDelegate, 
GKMatchmakerViewControllerDelegate>{
    GKMatch* _match;
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

+ (SKCommonGameCenterService *) sharedInstance;
- (void)authenticateLocalUser;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers 
                 viewController:(UIViewController *)viewController 
                       delegate:(id<SKCommonGameCenterServiceDelegate>)aDelegate;
- (void)show:(int)anItem;
- (void)reportScore: (int64_t) score forCategory: (NSString*) category;
- (void)sendData:(NSData *)data;
- (void) loadCategoryTitles;

@end
