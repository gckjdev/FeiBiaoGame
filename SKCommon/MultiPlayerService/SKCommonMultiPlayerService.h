//
//  SKCommonMultiPlayerService.h
//  Shuriken
//
//  Created by Orange on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKCommonBlueToothService.h"
#import "SKCommonGameCenterService.h"
enum {
    BLUETOOTH = 1,
    GAMECENTER,
}ConnectionTypes;

enum MULTI_GAME_TYPE {
    GAME_CENTER_GAME = 0,
    BLUETOOTH_GAME = 1
};

@protocol SKCommonMultiPlayerServiceDelegate <NSObject>

- (void)multiPlayerGamePrepared;
- (void)multiPlayerGameEnd;
- (void)gameRecieveData:(NSData*)data from:(NSString*)playerId;
- (void)playerLeaveGame:(NSString*)playerId;
- (void)gameCanceled;

@end

@interface SKCommonMultiPlayerService : NSObject  <SKCommonBlueToothServiceDelegate, SKCommonGameCenterServiceDelegate> {
    int _multiGameType;
    SKCommonBlueToothService* _bluetoothService;
    
}
@property (assign, nonatomic) id<SKCommonMultiPlayerServiceDelegate> delegate;
@property (retain, nonatomic) SKCommonBlueToothService* bluetoothService;
- (id)initWithMultiPlayerGameType:(NSInteger)aType;
- (void)findPlayers:(UIViewController*)superController;
- (void)sendDataToAllPlayers:(NSData*)data;
- (void)quitMultiPlayersGame;
@end
