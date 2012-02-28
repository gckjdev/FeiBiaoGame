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

@protocol SKCommonMultiPlayerServiceDelegate <NSObject>

- (void)multiPlayerGamePrepared;
- (void)multiPlayerGameEnd;
- (void)gameRecieveData:(NSData*)data from:(NSString*)playerId;
- (void)playerLeaveGame:(NSString*)playerId;
- (void)gameCanceled;

@end

@interface SKCommonMultiPlayerService : NSObject  <SKCommonBlueToothServiceDelegate> {
    int _connectionType;
    SKCommonBlueToothService* _bluetoothService;
    
}
@property (assign, nonatomic) id<SKCommonMultiPlayerServiceDelegate> delegate;
@property (retain, nonatomic) SKCommonBlueToothService* bluetoothService;
- (void)findPlayers;
- (void)sendDataToAllPlayers:(NSData*)data;
- (void)quitMultiPlayersGame;
@end
