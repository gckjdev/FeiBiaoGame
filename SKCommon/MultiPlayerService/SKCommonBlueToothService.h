//
//  SKCommonBlueToothService.h
//  Shuriken
//
//  Created by Orange on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
@protocol SKCommonBlueToothServiceDelegate <NSObject>

- (void)receiveData: (NSData*) data fromPeer: (NSString*) peerID;
- (void)connectDeviceSuccessfully:(NSString*)peerId;
- (void)peerDisconnectFromSession:(NSString*)peerId;
- (void)peerPickerCanceled;
@end

@interface SKCommonBlueToothService : NSObject <GKPeerPickerControllerDelegate, GKSessionDelegate> {
    GKSession* _currentSession;
    BOOL _actingAsHost;
}
@property (assign, nonatomic) id<SKCommonBlueToothServiceDelegate> delegate;
@property (retain, nonatomic) NSString* peerName;
- (void)findDevice;
- (void)sendData:(NSData*)data;
- (id)initWithName:(NSString*)aName;
- (void)disconnectFromAllPeers;

@end
