//
//  SKCommonMultiPlayerService.m
//  Shuriken
//
//  Created by Orange on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SKCommonMultiPlayerService.h"

@implementation SKCommonMultiPlayerService
@synthesize delegate = _delegate;
@synthesize bluetoothService = _bluetoothService;

- (void)dealloc
{
    [_bluetoothService release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _bluetoothService = [[SKCommonBlueToothService alloc] init];
        _bluetoothService.delegate = self;
    }
    return self;
}

#pragma --bluetooth service delegate
- (void)receiveData: (NSData*) data fromPeer: (NSString*) peerID
{
    if (_delegate && [_delegate respondsToSelector:@selector(gameRecieveData:from:)]) {
        [_delegate gameRecieveData:data from:peerID];
    }
}

- (void)didConnectToDevice:(NSString*)peerId
{
    if (_delegate && [_delegate respondsToSelector:@selector(multiPlayerGamePrepared)]) {
        [_delegate multiPlayerGamePrepared];
    }
}

- (void)acceptDevice
{
    if (_delegate && [_delegate respondsToSelector:@selector(multiPlayerGamePrepared)]) {
        [_delegate multiPlayerGamePrepared];
    }

}

- (void)peerDisconnectFromSession:(NSString*)peerId;

{
    if (_delegate && [_delegate respondsToSelector:@selector(playerLeaveGame:)]) {
        [_delegate playerLeaveGame:peerId];
    }

}

- (void)peerPickerCanceled
{
    if (_delegate && [_delegate respondsToSelector:@selector(gameCanceled)]) {
        [_delegate gameCanceled];
    }
}



- (void)sendDataToAllPlayers:(NSData*)data
{
    if (_bluetoothService) {
        [_bluetoothService sendData:data];
    }
}

- (void)findPlayers
{
    if (_bluetoothService == nil) {
        _bluetoothService = [[SKCommonBlueToothService alloc] init];
    }
    [_bluetoothService findDevice];
}

- (void)quitMultiPlayersGame
{
    if (_bluetoothService) {
        [_bluetoothService disconnectFromAllPeers];
    }
}
@end
